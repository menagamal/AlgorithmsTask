//
//  AlbumTableViewCell.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//

import UIKit
import SDWebImage


class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelAlbumId: UILabel!
    
    @IBOutlet weak var selectButtonOutlet: UIButton!
    
    private var selectedAction:(() -> Void)!
    
    var selectedFlag = false 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }
    override func prepareForReuse() {
        selectButtonOutlet.setImage(UIImage(named:"ic_master_visa_unselected"), for: .normal)
        selectedFlag = false 
    }
    
    @IBAction func selectButtonAction(_ sender: UIButton) {
        selectedAction()
    }
    
    
    func setDetails(album:Album , selectedButtonAction: (() -> Void)! = nil) {
        selectedAction = selectedButtonAction
        
        labelTitle.text = album.title
        labelAlbumId.text = "Album ID : \(album.albumID!)"
        
        if let temp = album.thumbnailUrl as? String {
            let x = URL(string:temp)
             albumImageView?.sd_setImage(with: x, completed: nil)
        }
     
      
    }
    
    

    
}
