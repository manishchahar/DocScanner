//
//  WebService.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/12/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import Foundation
import UIKit
enum ResponseStatus:String{
    case success = "Request processed successfully"
    case failed = "Failed to process your request at the time.Pleease try after some time"
    case timeOut = "Request Time Out.Unable to process your request withing specified time limit.Please try again later."
    case error = "Something went wrong.Please try again later"
    case empty = "Couldn't get any response from server. please try again later"
}
class WebService{
    static let shared = WebService()
    
    func get(fromUrl urlString:String,completion:@escaping((ResponseStatus,UIImage?)->Void)) {
        let getUrl = URL(string: "https://www.mttmg.in/screenshot.png")
        var request = URLRequest(url: getUrl!)
        request.timeoutInterval = 10
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ (resultData, response, error) in
            if let responseData = resultData{
                if let responseString = String(data: responseData, encoding: .utf8){
                    if let image = UIImage(data: responseString.data(using: .utf8)!){
                        completion(.success,image)
                    }
                    if let image = UIImage(data: resultData!){
                        completion(.success,image)
                    }
                }
            }else{
                completion(.empty,nil)
            }
        }
        task.resume()
    }
    
    func sendFile(fileUrl:URL) -> String {
        let response = ""
        if let file = FileUtility.shared.getPdfDocument(url: fileUrl){
            
        }
        return response
    }
}
