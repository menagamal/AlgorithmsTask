//
//  CircleImage.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {
    
    override func didMoveToWindow() {
        
        let size = frame.size.width
        self.layer.cornerRadius = size / 3
        clipsToBounds = true
        
        super.didMoveToWindow()
    }
}


