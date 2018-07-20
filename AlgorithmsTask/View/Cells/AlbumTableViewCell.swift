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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func selectButtonAction(_ sender: UIButton) {
        selectedAction()
    }
    
    
    func setDetails(album:Album , selectedButtonAction: (() -> Void)! = nil) {
        labelTitle.text = album.title
        labelAlbumId.text = "\(album.albumID)"
        albumImageView?.sd_setImage(with: URL(string: album.photo), completed: nil)
    }
    
    

    
}
