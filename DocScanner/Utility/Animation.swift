//
//  Animation.swift
//  HelloCordova
//
//  Created by Vivek Kumar on 4/28/18.
//

import UIKit
class Animation: NSObject{
    
    static let shared = Animation()
    func popUp(parentView:UIView,childView:UIView) {
        childView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        childView.alpha = 0
        parentView.addSubview(childView)
        UIView.animate(withDuration: 0.25, animations: {
            childView.alpha = 1
            childView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    
    func popIn(view:UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: {(completed:Bool)in
            if(completed){
                view.removeFromSuperview()
            }
        })
    }
    func popIn(view:UIView,removeViews:[UIView?]) {
        UIView.animate(withDuration: 0.25, animations: {
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: {(completed:Bool)in
            if(completed){
                view.removeFromSuperview()
                for v in removeViews{
                    v?.removeFromSuperview()
                }
            }
        })
    }
    
    func slideInFromRight(parentView:UIView,childView:UIView) {
        childView.transform = CGAffineTransform(translationX: parentView.frame.maxX, y: 0)
        parentView.addSubview(childView)
        UIView.animate(withDuration: 0.25, animations: {
            childView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    func slideInFromLeft(parentView:UIView,childView:UIView) {
        childView.transform = CGAffineTransform(scaleX: 0, y: 1)
        parentView.addSubview(childView)
        UIView.animate(withDuration: 0.5, animations: {
            childView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }

    func slideOutToRight(view:UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            view.transform = CGAffineTransform(translationX: view.frame.maxX, y: 0)
        },completion:{(completed:Bool) in
            view.removeFromSuperview()
        })
    }
    
    func slideOutToLeft(view:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: 0)
        },completion:{(completed:Bool) in
            view.removeFromSuperview()
        })
    }
    
    func presentLeftScale(parentView:UIView,childView:UIView) {
        childView.transform = CGAffineTransform(scaleX: 0, y: 1)
        UIView.animate(withDuration: 0.25, animations: {
            
        })
    }
    
    //MARK:Drag Gesture
    var dragGesture = UIPanGestureRecognizer()
   var parentView = UIView()
    func make(dragableView :UIView, onView view:UIView ) {
        parentView = view
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        dragableView.isUserInteractionEnabled = true
        dragableView.addGestureRecognizer(dragGesture)
    }
   
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.parentView.bringSubview(toFront: sender.view!)
        let translation = sender.translation(in: self.parentView)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.self.parentView)
    }
 
    func scale(view:UIView) {
        
        UIView.animate(withDuration: 0.25, animations: {
            view.transform = CGAffineTransform(translationX: 2, y: 2)
        }) { (isCompleted) in
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        
        
        UIView.animate(withDuration: 0.25, animations: {
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
        }) { (isCompleted) in
            if(isCompleted){
             view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    
}
