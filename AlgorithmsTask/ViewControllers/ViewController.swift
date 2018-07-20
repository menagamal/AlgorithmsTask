//
//  ViewController.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//

import UIKit

class ViewController: UIViewController , ActionDelegate{
    
    var loadingView:LoadingView!
    var content : ApiManager!
    
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content = ApiManager(delegate: self)
        
        loadingView = LoadingView(frame: view.frame)
        loadingView.setLoadingImage(image: UIImage(named: "loading")!)
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        loadingView.isHidden = true
        
        self.view.addSubview(loadingView)
        content.getAllAlbums()
    }
    
    func onPreExecute(action: ApiManager.ActionType) {
        loadingView.setIsLoading(true)

    }
    func onPostExecute(success: Bool, action: ApiManager.ActionType, message: String, response: Any!) {
        loadingView.setIsLoading(false)
        if success {
            switch action {
            case .getAllAlbums:
                albums = response as! [Album]
                
                break
            default :
                break
            }
        } else {
            
        }
        

    }

}

