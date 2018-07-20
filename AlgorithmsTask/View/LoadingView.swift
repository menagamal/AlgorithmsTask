//
//  LoadingView.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//


import UIKit

class LoadingView: UIView {
    
    var loadingSize: Int = 70
    
    var imageView: UIImageView = UIImageView()
    
    func setLoadingImage(image: UIImage) {
        
        imageView.image = image
        
        imageView.frame = CGRect(x: self.frame.width / 2 - CGFloat(loadingSize / 2), y: self.frame.height / 2 - CGFloat(loadingSize / 2), width: CGFloat(loadingSize), height: CGFloat(loadingSize))
        
        addSubview(imageView)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        if isLoading {
            isHidden = false
            superview?.bringSubview(toFront: self)
            imageView.startAnimating()
            if !imageView.isAnimating {
                
                let rotation = CABasicAnimation(keyPath: "transform.rotation")
                rotation.fromValue = 0
                rotation.toValue = (2 * M_PI)
                rotation.duration = 1.5
                rotation.repeatCount = Float.greatestFiniteMagnitude
                
                imageView.layer.removeAllAnimations()
                imageView.layer.add(rotation, forKey: "rotation")
            }
        } else {
            isHidden = true
            imageView.stopAnimating()
        }
    }
}

