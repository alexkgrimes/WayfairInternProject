//
//  ViewController.swift
//  WayfairMovieDB
//
//  Created by Alexandra Grimes on 6/21/18.
//  Copyright © 2018 Alexandra Grimes. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    @IBOutlet weak var searchText: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var movieLogoView: UIImageView!
    
    @IBAction func browseButtonHandler(_ sender: Any) {
        let browseView = storyboard?.instantiateViewController(withIdentifier: "BrowseViewController") as! BrowseViewController
        browseView.query = searchBar.text!
        navigationController?.pushViewController(browseView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set logo image
        let logoName = "TMDb logo.png"
        let logoImage = UIImage(named: logoName)
        movieLogoView.image = logoImage
        movieLogoView.contentMode = UIViewContentMode.scaleAspectFit
        
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let browseView = storyboard?.instantiateViewController(withIdentifier: "BrowseViewController") as! BrowseViewController
        browseView.query = searchBar.text!
        navigationController?.pushViewController(browseView, animated: true)
    }
}


