//
//  Toast.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//



import Foundation
import UIKit

public class Toast {
    
    public static let ButtonColor = UIColor(red: 0x7A / 255, green: 0x66 / 255, blue: 0x8B / 255, alpha: 1)
    
    public static func showAlert(viewController: UIViewController,  title: String! = nil, text: String) {
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        action.setValue( ButtonColor, forKey: "titleTextColor")
        
        Toast.showAlert(viewController: viewController, text: text, style: UIAlertControllerStyle.actionSheet, action)
    }
    
    public static func showAlert(viewController: UIViewController, title: String! = nil, text: String, style: UIAlertControllerStyle, _ actions: UIAlertAction...) {
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: style)
        
        if actions.count == 1 {
            
            let action = actions[0]
            
            action.setValue(ButtonColor, forKey: "titleTextColor")
            
            alert.addAction(action)
            
            if let popoverController = alert.popoverPresentationController {
                alert.popoverPresentationController?.sourceView = viewController.view
                //  alert.popoverPresentationController?.sourceRect = viewController.view.bounds
                
            }
            
            
            alert.preferredAction = action
        } else {
            
            for i in 0..<actions.count {
                let action = actions[i]
                if i == 0 {
                    
                    action.setValue(ButtonColor, forKey: "titleTextColor")
                } else {
                    
                    action.setValue(ButtonColor, forKey: "titleTextColor")
                }
                
                alert.addAction(action)
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = viewController.view
                    popoverController.sourceRect = viewController.view.bounds
                }
                alert.preferredAction = action
            }
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func showAlert(viewController: UIViewController, title: String! = nil, text: String, fieldHint: String! , _ actions: UIAlertAction...) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.placeholder = fieldHint
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        if actions.count == 1 {
            
            let action = actions[0]
            
            action.setValue(ButtonColor, forKey: "titleTextColor")
            
            alert.addAction(action)
            
            alert.preferredAction = action
        } else {
            
            for i in 0..<actions.count {
                let action = actions[i]
                if i == 0 {
                    
                    action.setValue(ButtonColor, forKey: "titleTextColor")
                } else {
                    
                    action.setValue(ButtonColor, forKey: "titleTextColor")
                }
                
                alert.addAction(action)
                alert.preferredAction = action
            }
        }
        
        alert.view.backgroundColor = UIColor.white
        alert.view.layer.cornerRadius = 10
        if let popoverController = alert.popoverPresentationController {
            alert.popoverPresentationController?.sourceView = viewController.view
            //  alert.popoverPresentationController?.sourceRect = viewController.view.bounds
            
        }
        viewController.present(alert, animated: true, completion: nil)
        
        
        return alert
    }
}

