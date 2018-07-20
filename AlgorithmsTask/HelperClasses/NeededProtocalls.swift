//
//  NeededProtocalls.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//

import Foundation
public protocol ActionDelegate {
    
    func onPreExecute(action: ApiManager.ActionType)
    
    func onPostExecute(success: Bool, action: ApiManager.ActionType, message: String, response: Any!)
}

