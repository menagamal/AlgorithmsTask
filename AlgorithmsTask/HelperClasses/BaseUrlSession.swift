//
//  BaseUrlSession.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
//import Just

public class BaseUrlSession {
    
    public enum Actions {
    }
    
    func requestConnection(action: Any, url: URL, shouldCache: Bool) {
        requestConnection(action: action, method: "GET", url: url, body: nil, header: nil, shouldCache: shouldCache, shouldLoadFromCache: false)
    }
    
    func requestConnection(action: Any, method: String, url: URL, body: [String: Any]!, shouldCache: Bool) {
        requestConnection(action: action, method: method, url: url, body: body, header: nil, shouldCache: shouldCache, shouldLoadFromCache: false)
    }
    
    func requestConnection(action: Any, method: String, url: URL, body: [String: Any]!, header: [String: String]!, shouldCache: Bool) {
        requestConnection(action: action, method: method, url: url, body: body, header: header, shouldCache: shouldCache, shouldLoadFromCache: false)
    }
    
    func requestConnection(action: Any, method: String, url: URL, body: [String: Any]!, header: [String: String]! , image : UIImage , imageKey: String ) {
        
        onPreExecute(action: action)
//
//        let manager = SettingsManager()
        let mHeader = header ?? [String: String]()
//        mHeader["Authorization"] = "Bearer \(manager.getUserToken())"
//        mHeader["Accept"] = "application/json"
        
        let mBody = body ?? [String: Any]()
        
        let method = HTTPMethod(rawValue: method.uppercased())!
        
        let urlRequest = try! URLRequest(url: url, method: method, headers: mHeader)
        
        let imgData = UIImageJPEGRepresentation(image, 1)!
        
        Alamofire.upload(multipartFormData: { (data) in
            //  data.append(imgData, withName: "image")
            data.append(imgData, withName: imageKey, fileName: "im.jpg", mimeType: "image/jpg")
            
            for (key, value) in mBody {
                data.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
        }, with: urlRequest) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    self.onSuccess(action: action, response: response.response, data: response.data!)
                }
                
            case .failure(let encodingError):
                print(encodingError)
                if !NetworkReachabilityManager()!.isReachable {
                    
                    self.onFailure(action: action, error: NSError(domain: NSLocalizedString("no_internet", comment: ""), code: -1, userInfo: nil))
                } else {
                    self.onFailure(action: action, error: encodingError)
                }
                
            }
        }
    }
    
    func requestConnection(action: Any, method: String, url: URL, body: [String: Any]!, header: [String: String]!, shouldCache: Bool, shouldLoadFromCache: Bool) {
        
        onPreExecute(action: action)
        
//        let manager = SettingsManager()
        let mHeader = header ?? [String: String]()
//        mHeader["Authorization"] = "Bearer \(manager.getUserToken())"
//        mHeader["Accept"] = "application/json"
        
        let mBody = body ?? [String: Any]()
        
        let method = HTTPMethod(rawValue: method.uppercased())
        
        Alamofire.request(url, method: method!, parameters: mBody, encoding: URLEncoding.httpBody, headers: mHeader).response { (response) in
            
            if let error = response.error {
                print(error)
                if !NetworkReachabilityManager()!.isReachable {
                    
                    self.onFailure(action: action, error: NSError(domain: NSLocalizedString("no_internet", comment: ""), code: -1, userInfo: nil))
                } else {
                    self.onFailure(action: action, error: error)
                }
            } else {
                self.onSuccess(action: action, response: response.response, data: response.data!)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print(jsonResult)
                } catch {
                    print(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                }
            }
        }
        
    }
    
    func requestMultiPartConnection(action: Any, url: URL, parameters: [String: Any]!, header: [String: String]!, imageKey: String, image: UIImage) {
        
        onPreExecute(action: action)
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        let body = NSMutableData()
        
        let boundary = NSUUID().uuidString
        
        for param in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(param.key)\"\r\n\r\n")
            body.appendString(string: "\(param.value)\r\n")
        }
        
        //        body.appendString(string: "--Boundary-\(boundary)\r\n")
        //        do{
        //            let bodyData = try JSONSerialization.data(withJSONObject: parameters)
        //            body.append(bodyData)
        //        } catch {
        //            print("Error:\(error)")
        //        }
        
        body.appendString(string: "--Boundary-\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "yourImageName.jpg"
        
        let imageData: Data!
        if image.size.width > 200 {
            imageData = UIImageJPEGRepresentation(resizeImage(image: image, newWidth: 200), 1)
        } else {
            imageData = UIImageJPEGRepresentation(image, 1)
        }
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        urlRequest.httpBody = body as Data
        
        if header != nil {
            urlRequest.allHTTPHeaderFields = header
        }
        urlRequest.addValue("multipart/form-data",forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json",forHTTPHeaderField: "Accept")
        
        // set up the session configuration
        let config = URLSessionConfiguration.default
        
        // set up the session
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            if (error != nil) {
                print(error!)
                self.onFailure(action: action, error: error!)
            } else {
                self.onSuccess(action: action, response: response, data: data!)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print(jsonResult)
                } catch {
                    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
                }
            }
        })
        task.resume()
    }
    
    func getCacheData(url: URL) -> Data! {
        
        if let cache = URLCache().cachedResponse(for: URLRequest(url: url)) {
            return cache.data
        }
        
        return nil
    }
    
    func getCache(url: URL) -> Any! {
        
        if let cache = URLCache().cachedResponse(for: URLRequest(url: url)) {
            do {
                let response = try JSONSerialization.jsonObject(with: cache.data, options: JSONSerialization.ReadingOptions.mutableContainers)
                return response
            } catch {
                print("Error:\(error)")
            }
        }
        
        return nil
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func onPreExecute(action: Any) {
    }
    
    func onSuccess(action: Any, response: URLResponse!, data: Data!) -> Void {
        preconditionFailure("This method must be overriden")
    }
    
    func onFailure(action: Any, error: Error) -> Void {
        preconditionFailure("This method must be overriden")
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

