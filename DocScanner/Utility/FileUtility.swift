//
//  FileManager.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/5/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import PDFKit
class FileUtility{
    static let shared = FileUtility()
    let fileManager = FileManager.default
    let defaultPath : URL = {
        let path = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("DocScanner")
        return path
    }()
    
    func createFolder(name:String) -> String {
        
        let currentPath = self.defaultPath.appendingPathComponent(name)
        if(fileManager.fileExists(atPath: currentPath.path)){
            return "Folder already exist"
        }else{
            do{
                try fileManager.createDirectory(atPath: currentPath.path, withIntermediateDirectories: true, attributes: nil)
                return "Folder created"
            }catch{
                return "unable create folder due to \n \(error.localizedDescription.description)"
            }
        }
    }
    
    func createFolder(directory:URL,name:String) -> String {
        let currentPath = directory.appendingPathComponent(name)
        if(fileManager.fileExists(atPath: currentPath.path)){
            return "Folder already exist with same name"
        }else{
            do{
                try fileManager.createDirectory(atPath: currentPath.path, withIntermediateDirectories: true, attributes: nil)
                return ""
            }catch{
                return "unable create folder due to \n \(error.localizedDescription.description)"
            }
        }
    }
    
    func renameFile(atPath path:URL,newName name : String) -> String {
        let currentPath = path
        do {
            try  fileManager.moveItem(at: path, to: currentPath.deletingLastPathComponent().appendingPathComponent("\(name).pdf"))
            return ""
        } catch  {
            return error.localizedDescription.description
        }
    }
    
    func renameDirectory(atPath path : URL, newName name : String) -> String {
        var currentPath = path

        do {
            try  fileManager.moveItem(at: path, to: currentPath.deletingLastPathComponent().appendingPathComponent("\(name)"))

            return ""
        } catch  {
            return error.localizedDescription
        }
    }
    
    func scanDirectory()->[URL]{
        do {
            var fileURLs = try fileManager.contentsOfDirectory(at: self.defaultPath, includingPropertiesForKeys: nil)
            if let index = fileURLs.index(of: defaultPath.appendingPathComponent(".DS_Store")){
                fileURLs.remove(at: index)
            }
            return fileURLs
        } catch {
            return []
        }
    }
    
    func scanDirectory(directory :URL)->[File]{
        var allFiles : [File] = []
        var allFileUrl : [URL] = []
        do {
            allFileUrl = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            if let index = allFileUrl.index(of: defaultPath.appendingPathComponent(".DS_Store")){
                allFileUrl.remove(at: index)
            }
        } catch {
            print(error.localizedDescription)
        }
        for fileUrl in allFileUrl{
            allFiles.append(File.init(fileUrl: fileUrl))
        }
        return allFiles
    }
    
    func writeFile(file:Data,fileName:String) -> String {
        let path = defaultPath.appendingPathComponent(fileName)
        do{
            try fileManager.createFile(atPath: path.path, contents: file, attributes: nil)
            return ""
        }catch{
            return error.localizedDescription.description
        }
    }
    
    func writeFile(directory:URL,file:Data,fileName:String) -> String {
        let path = directory.appendingPathComponent(fileName)
        do{
            try fileManager.createFile(atPath: path.path, contents: file, attributes: nil)
            return ""
        }catch{
            return error.localizedDescription.description
        }
    }
    
    
    func deleteFile(url:URL) -> String {
        do{
            try fileManager.removeItem(at: url)
            return ""
        }catch{
            return(error.localizedDescription.description)
        }
    }
    func readFile(atPath path : URL) -> Data? {
        do {
            let fileData = try fileManager.contents(atPath: path.path)
            return fileData
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func drawPDFfromURL(url: URL) -> [UIImage]? {
        var allImage : [UIImage] = []
        guard let document = PDFDocument(url: url) else { return nil }
        for i in 1..<document.pageCount+1{
            let page = document.page(at: i)
            let image = UIImage(data: page!.dataRepresentation!)
            allImage.append(image!)
        }
        return allImage
    }
    func getPdfDocument(url: URL) -> PDFDocument? {
        guard let document = PDFDocument(url: url) else { return nil }
        return document
    }
    
    func getPdfPage(atPageIndex pageNumber : Int,atPath url: URL) -> PDFPage? {
        guard let document = PDFDocument(url: url) else { return nil }
        guard let page = document.page(at: pageNumber) else{return nil}
        return page
    }
    
    func getSinglePage(atPath path : URL,atPage pagenumber: Int) {
        
    }
    
    func getPageCount(atPath url : URL) -> Int {
        guard let document = PDFDocument(url: url) else { return 0 }
        return document.pageCount
    }
//    func getImage(forPage page:PDFPage) -> UIImage {
//    
//    }
    func drawPDFfromURL(url: URL,pageNumber : Int) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: pageNumber + 1) else { return nil }
        let size = CGSize(width:200,height:200)
        let f = UIGraphicsImageRendererFormat.default() // *
        f.opaque = true
        let r = UIGraphicsImageRenderer(size:size)
        let img = r.image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1500, height: 1500)))
            ctx.cgContext.translateBy(x: 0.0, y: page.getBoxRect(.mediaBox).size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            ctx.cgContext.drawPDFPage(page)
        }
        UIGraphicsEndImageContext()
        return img
    }
    
    func splitPdf(atPath path : URL) {
        let workingPdfDirectory = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workingPdfDirectory")
        let pdfDocument = PDFDocument(url: path)
        for i in 0..<pdfDocument!.pageCount{
            let page = pdfDocument!.page(at: i)
            let document = PDFDocument()
            document.insert(page!, at: 0)
            self.writeFile(directory: workingPdfDirectory, file: document.dataRepresentation()!, fileName: "workingCopy_\(i).pdf")
        }
    }
    func getSplitedPageUrl(pdfUrl : URL,pageNumber:Int) -> URL {
        let workingPdfDirectory = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workingPdfDirectory")
        let filePath = workingPdfDirectory.appendingPathComponent("workingCopy_\(pageNumber).pdf")
        return filePath
    }
    func getSplitedPageData(pdfUrl : URL,pageNumber:Int) -> Data {
        let workingPdfDirectory = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workingPdfDirectory")
        let filePath = workingPdfDirectory.appendingPathComponent("workingCopy_\(pageNumber).pdf")
        let pdfDocument = PDFDocument(url: filePath)
        return pdfDocument!.dataRepresentation()!
    }
    
    
    
    func getCachedDirectory() -> URL? {
        let currentPath = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cachedDirectory")

        if(self.fileManager.fileExists(atPath: currentPath.path)){
            return currentPath
        }else{
            do{
                try fileManager.createDirectory(atPath: currentPath.path, withIntermediateDirectories: true, attributes: nil)
                return currentPath
            }
            catch{
                return nil
            }
        }
    }
}


public enum FileType {
    case folder,pdf,doc,txt,png,gpeg,image
}
struct File {
    let name : String!
    let type : FileType!
    let image : UIImage!
    let path : String!
    let url : URL!
    init(fileUrl:URL) {
        path = fileUrl.path
        self.url = fileUrl
        let fileExtension = fileUrl.pathExtension
        switch fileExtension {
        case "":
            name = fileUrl.lastPathComponent
            type = .folder
            image = UIImage(named: "folder")?.tint(with: Theme.folderColor)
        case "pdf":
            name = fileUrl.deletingPathExtension().lastPathComponent
            type = .pdf
            image = UIImage(named: "pictureAsPdf")?.tint(with:Theme.pdfIconColor)
        default:
            name = fileUrl.lastPathComponent
            type = .folder
            image = UIImage(named: "folder")
        }
    }
}
