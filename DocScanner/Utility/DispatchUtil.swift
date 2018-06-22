//
//  DispatchUtil.swift
//  HelloCordova
//
//  Created by Vivek Kumar on 4/18/18.
//

import Foundation
class DispatchUtil :NSObject{
    
    static let shared = DispatchUtil()

    public static let concurrentdefaultQueue = DispatchQueue(label: "com.enhancesys.concurrent.default", qos: .default, attributes:.concurrent)
    
    public static let concurrentUtilityQueue = DispatchQueue(label: "com.enhancesys.concurrent.utility", qos: .utility, attributes: .concurrent)
    
    public static let concurrentUserInitiatedQueue = DispatchQueue(label: "com.enhancesys.concurrent.userInitiated", qos: .userInitiated, attributes: .concurrent)
    
    public static let concurrentBackgroundQueue = DispatchQueue(label: "com.enhancesys.concurrent.background", qos: .background, attributes: .concurrent)
    
    public static let concurrentUserInteractiveQueue = DispatchQueue(label: "com.enhancesys.concurrent.userInteractive", qos: .userInteractive, attributes: .concurrent)
    
    public static let concurrentUnspecifiedQueue = DispatchQueue(label: "com.enhancesys.concurrent.userInteractive", qos: .unspecified, attributes: .concurrent)
    
//    public static let serialQueue = dispatch_queue_create("com.myApp.mySerialQueue", DISPATCH_QUEUE_SERIAL)

     let allQueue = [concurrentUnspecifiedQueue,concurrentBackgroundQueue,concurrentdefaultQueue,concurrentUtilityQueue,concurrentUserInitiatedQueue,concurrentUserInteractiveQueue]
    
    var count = 0
    func submitAsync(task:()){
        allQueue[count].async {
            task
        }
        if(count == 5){
           count = 0
        }else{
            count = count + 1
        }
    }
    
    var syncCount = 0
    func submitSync(task:()){
        allQueue[syncCount].async {
            task
        }
        if(syncCount == 5){
            syncCount = 0
        }else{
            syncCount = syncCount + 1
        }
    }
    
    func getThread(label:String) -> DispatchQueue {
         return DispatchQueue(label: "com.enhancesys.concurrent.utility.\(label)", qos: .utility, attributes: .concurrent)

    }
}
