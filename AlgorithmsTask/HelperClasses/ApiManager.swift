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
    
    func getAllAlbums()  {
        let params = [String: Any]()
        
        let actionType = ActionType.getAllAlbums;
        let url = URL(string: "\(baseUrl)photos")!
        
        requestConnection(action: actionType, method: "get", url: url, body: params, shouldCache: false)
    }
    
    
    
    override func onSuccess(action: Any, response: URLResponse!, data: Data!) {
        let actionType: ActionType = action as! ApiManager.ActionType
        do {
            //_ = String(data: data, encoding: .utf8)
            
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
  
            let success :Bool!
            if jsonResponse!.isEmpty {
                success = false
            } else {
                success = true
            }
            
            
            if success {
                switch actionType {
                case .getAllAlbums :
                    var albums = [Album] ()
                    for item in jsonResponse! {
                        let album = Album(json: item)
                        albums.append(album)
                    }
                    delegate.onPostExecute(success: true, action: actionType, message: "", response: albums)
                    break
                default:
                    break
                }
            }else {
                //let code = jsonResponse["error_code"] as? Int ?? -1
                let code = 404
                let codeMessage = "NO ITEMS FOUND"
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
        
        delegate.onPostExecute(success: false, action: action as! ApiManager.ActionType, message: error.localizedDescription , response: nil)
        
    }
    
}
