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
    
    @IBAction func browseButtonHandler(_ sender: Any) {
        let browseView = storyboard?.instantiateViewController(withIdentifier: "BrowseViewController") as! BrowseViewController
        browseView.query = searchBar.text!
        navigationController?.pushViewController(browseView, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let browseView = segue.destination as? BrowseViewController {
            print("searchBar.text = \(searchBar.text!)")
            browseView.query = searchBar.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //
    }
}


