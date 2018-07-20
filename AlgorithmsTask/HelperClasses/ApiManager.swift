//
//  ApiManager.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//

import Foundation
public class ApiManager : BaseUrlSession{
    
    var delegate: ActionDelegate!
    
    let baseUrl = "https://jsonplaceholder.typicode.com/"
    
    public enum ActionType  {
        case getAllAlbums , None
    }
    
    init<T: Any>(delegate: T) where T: ActionDelegate {
        super.init()
        self.delegate = delegate
    }
    
    
    
    override func onSuccess(action: Any, response: URLResponse!, data: Data!) {
        let actionType: ActionType = action as! ApiManager.ActionType
        do {
            _ = String(data: data, encoding: .utf8)
            var jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [String: Any]()
            
            var message: String!
            if let m = jsonResponse["error"] as? [String] {
                if m.count > 0 {
                    message = m[0]
                }
            } else if let m = jsonResponse["error"] as? String {
                message = m
            }
            
            message = message != nil ? message : jsonResponse["error_message"] as? String
            let success = message == nil
            if success {
                print(jsonResponse)
                switch actionType {
                default:
                    break
                }
                
            }else {
                let code = jsonResponse["error_code"] as? Int ?? -1
                let codeMessage = message ?? ""
                onFailure(action: actionType, error: NSError(domain: codeMessage, code: code, userInfo: nil))
            }
            
        }catch {
            onFailure(action: actionType, error: error)
        }
        
    }
    
    
    override func onPreExecute(action: Any) {
        onPreExecute(action: action as! ActionType)
    }
    
    func onPreExecute(action: ActionType) {
        delegate.onPreExecute(action: action)
    }
    
    
    override func onFailure(action: Any, error: Error) {
        if error != nil {
            delegate.onPostExecute(success: false, action: action as! ApiManager.ActionType, message: error._domain , response: nil)
        } else {
            
            delegate.onPostExecute(success: false, action: action as! ApiManager.ActionType, message: error.localizedDescription , response: nil)
        }
        
    }
    
}
