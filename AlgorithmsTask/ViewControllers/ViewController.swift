//
//  ViewController.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//

import UIKit

class ViewController: UIViewController , ActionDelegate , UITableViewDataSource , UITableViewDelegate{
    
    var loadingView:LoadingView!
    var content : ApiManager!
    
    @IBOutlet weak var albumsTableView: UITableView!
   
    
    var albums = [Album]()
    var selectedAlbums = [Album]()
    var selecteflag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        content = ApiManager(delegate: self)
        
        loadingView = LoadingView(frame: view.frame)
        loadingView.setLoadingImage(image: UIImage(named: "loading")!)
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        loadingView.isHidden = true
        
        self.view.addSubview(loadingView)
        
        albumsTableView.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "AlbumTableViewCell")
        albumsTableView.rowHeight = UITableViewAutomaticDimension
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        
        
        content.getAllAlbums()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.tintColor  = UIColor.white

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selecteflag {
            return selectedAlbums.count
        }
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as! AlbumTableViewCell
        
        if selectedAlbums.contains(where: { String.Encoding(rawValue: UInt($0.id!)) == String.Encoding(rawValue: UInt(albums[indexPath.row].id!)) }) {
            // found
            cell.selectButtonOutlet.setImage(UIImage(named:"ic_master_visa_selected"), for: .normal)

        } else {
            // not
            cell.selectButtonOutlet.setImage(UIImage(named:"ic_master_visa_unselected"), for: .normal)

        }
        
        cell.setDetails(album: albums[indexPath.row]) {
            if self.selecteflag {
                cell.selectButtonOutlet.isHidden = true
            } else {
                if cell.selectedFlag {
                    self.selectedAlbums.remove(at: indexPath.row)
                    cell.selectedFlag = false
                    cell.selectButtonOutlet.setImage(UIImage(named:"ic_master_visa_unselected"), for: .normal)
                    
                } else {
                    // ADD
                    if self.selectedAlbums.count < 11 {
                        
                        cell.selectedFlag = true
                        cell.selectButtonOutlet.setImage(UIImage(named:"ic_master_visa_selected"), for: .normal)
                        self.selectedAlbums.append(self.albums[indexPath.row])
                        
                    } else {
                        Toast.showAlert(viewController: self, text: "You can only select up to 10 Albums")
                    }
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height  = tableView.layer.frame.height / 4
        return height
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAction))
        
        self.navigationItem.rightBarButtonItems = [cancelButton]
        cancelButton.tintColor = UIColor.white
        selecteflag = true
        albumsTableView.reloadData()
        

      
    }
     @objc func cancelAction()  {
        self.navigationItem.rightBarButtonItems?.removeAll()
        selecteflag = false
        albumsTableView.reloadData()
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
                albumsTableView.reloadData()
                break
            default :
                break
            }
        } else {
            Toast.showAlert(viewController: self, text: message)
        }
        

    }

}

