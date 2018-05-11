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
    var delegate:ImageCaptureDelegate?
    
    @IBOutlet var flashOptionView: UIView!
    
    @IBAction func flashOnAction(_ sender: UIButton) {
        self.flashBtnOutlet.setImage(UIImage(named: "flash_on")?.tint(with:UIColor.green), for: .normal)

        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            try device?.lockForConfiguration()
            device?.torchMode = .on
            self.removeFlashOptionView()
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func flashoffAction(_ sender: UIButton) {
        self.flashBtnOutlet.setImage(UIImage(named: "flash_off")?.tint(with:UIColor.green), for: .normal)


        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            try device?.lockForConfiguration()
            device?.torchMode = .off
            self.removeFlashOptionView()
        }
        catch {
            print(error)
        }
    }
    
    
    @IBAction func flashAutoAction(_ sender: UIButton) {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            try device?.lockForConfiguration()
            device?.torchMode = .auto
            self.removeFlashOptionView()
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
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                if let image = UIImage(data: imageData!){
                    self.delegate?.didCaptured(image: image)
                }
            }
        }
    }
    
    @IBOutlet private weak var cameraView: UIView?
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var error: NSError?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flashBtnOutlet.setImage(UIImage(named: "flash_off")?.tint(with:UIColor.green), for: .normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.prepareCamera()
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        self.previewLayer?.frame = CGRect(x: 0, y: 0, width: Int(self.cameraView!.frame.width), height: Int(self.cameraView!.frame.height))
        
        let videoOrientation: AVCaptureVideoOrientation
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            videoOrientation = .landscapeLeft
        case .landscapeRight:
            videoOrientation = .landscapeRight
        default:
            videoOrientation = .portrait
        }
        previewLayer?.connection?.videoOrientation = videoOrientation
        
    }
    
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    func prepareCamera() {
        if(self.captureSession.inputs.count>0){
            print("inputs already there")
        }
        //Add inputs
        if let captureDevice = self.devices.first as? AVCaptureDevice  {
            
            try? captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            //            previewLayer.position = CGPoint(view.bounds.midX, view.bounds.midY)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.frame = self.cameraView!.frame
            previewLayer?.bounds = (cameraView?.bounds)!
            cameraView?.layer.addSublayer(previewLayer!)
            //            cameraPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"saveToCamera:"))
            
            self.cameraView?.addSubview(self.settingsView)
            self.cameraView?.addSubview(self.captureView)
        }
    }
    
    func saveToCamera(sender: UITapGestureRecognizer) {
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.captureSession.stopRunning()
        cameraView?.layer.sublayers?.first?.removeFromSuperlayer()
        ///Remove inputs
        if let inputs = self.captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
