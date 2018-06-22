//
//  CameraViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/6/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
protocol ImageCaptureDelegate {
    func didCaptured(image:UIImage)
}
class CameraViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    public static let shared = CameraViewController()
    var delegate:ImageCaptureDelegate?
    
    
    @IBOutlet weak var zoomSliderOutlet: UISlider!
    
    @IBAction func zoomSliderAction(_ sender: UISlider) {
        do{
            try self.devices.first?.lockForConfiguration()
            self.devices.first?.videoZoomFactor = CGFloat(sender.value)
            self.devices.first?.unlockForConfiguration()
        }catch{
            
        }
    }
    
    @IBOutlet var flashOptionView: UIView!
    
    @IBAction func flashOnAction(_ sender: UIButton) {
        self.flashBtnOutlet.setImage(UIImage(named: "flash_on")?.tint(with:UIColor.white), for: .normal)
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            try device?.lockForConfiguration()
            if(device!.isTorchModeSupported(.on)){
                device?.torchMode = .on
                self.removeFlashOptionView()
                }
                device?.unlockForConfiguration()
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func flashoffAction(_ sender: UIButton) {
        self.flashBtnOutlet.setImage(UIImage(named: "flash_off")?.tint(with:UIColor.white), for: .normal)
        
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            try device?.lockForConfiguration()
            if(device!.isTorchModeSupported(.off)){
            device?.torchMode = .off
            }
            self.removeFlashOptionView()
            device?.unlockForConfiguration()
        }
        catch {
            print(error)
        }
    }
    
    
    @IBAction func flashAutoAction(_ sender: UIButton) {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            try device?.lockForConfiguration()
            if(device!.isTorchModeSupported(.auto)){
                device?.torchMode = .auto
            }
            self.removeFlashOptionView()
            device?.unlockForConfiguration()
        }
        catch {
            print(error)
        }
    }
    
    func removeFlashOptionView()  {
        self.flashOptionView.removeFromSuperview()
    }
    
    
    @IBOutlet weak var flashBtnOutlet: UIButton!
    
    @IBAction func flashBtnAction(_ sender: UIButton) {
        if(flashOptionView.isDescendant(of: settingsView)){
            
            Animation.shared.slideOutToLeft(view: flashOptionView)
        }else{
            
            flashOptionView.frame = CGRect(x:50,y:0,width:settingsView.frame.width-50,height:settingsView.frame.height)
            Animation.shared.slideInFromLeft(parentView: settingsView, childView: flashOptionView)
        }
    }
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var captureView: UIView!
    
    @IBOutlet weak var captureBtnOutlet: UIButton!
    var devices : [AVCaptureDevice] = {
        let captureDevices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaType.video) && $0.position == AVCaptureDevice.Position.back
        }
        return captureDevices
    }()
    
    @IBAction func capturebtnAction(_ sender: UIButton) {
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                if let imageBuffer = imageDataSampleBuffer{
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageBuffer)
                    if let image = UIImage(data: imageData!){
                        CaptureImageSharing.shared.image = image.fixOrientation()
                    }
                }
            }
        }
    }
    
    @IBOutlet private weak var cameraView: UIView?
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var error: NSError?
    override func viewDidLoad(){
        super.viewDidLoad()
        self.flashBtnOutlet.setImage(UIImage(named: "flash_off")?.tint(with:UIColor.white), for: .normal)
        self.captureBtnOutlet.setImage(UIImage(named: "camera")?.tint(with: UIColor.blue), for: .normal)
        self.prepareCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.previewLayer?.frame = self.cameraView!.bounds
        let orientation = UIDevice.current.orientation
        if let videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue){
            self.previewLayer?.connection?.videoOrientation = videoOrientation
        }
    }
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    func prepareCamera() {
        if(self.captureSession.inputs.count>0){
            print("inputs already there")
        }else{
            if let captureDevice = self.devices.first {
                try? captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                captureSession.sessionPreset = AVCaptureSession.Preset.photo
                captureSession.startRunning()
                stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                if captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addOutput(stillImageOutput)
                }
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.connection?.videoOrientation = .portrait
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                let previewFrame = CGRect(x: 0, y: 0, width: self.cameraView!.frame.width, height: self.cameraView!.frame.height)
                previewLayer?.frame = previewFrame
                self.cameraView?.layer.addSublayer(previewLayer!)
                self.cameraView?.bringSubview(toFront: self.settingsView)
                self.cameraView?.bringSubview(toFront: self.captureView)
                //            cameraPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"saveToCamera:"))
                self.zoomSliderOutlet.minimumValue = Float(captureDevice.minAvailableVideoZoomFactor)
                self.zoomSliderOutlet.value = Float(captureDevice.minAvailableVideoZoomFactor)
                self.zoomSliderOutlet.maximumValue = Float(captureDevice.maxAvailableVideoZoomFactor)
                self.cameraView?.bringSubview(toFront: self.zoomSliderOutlet)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
