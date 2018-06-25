//
//  ViewController.swift
//  WayfairMovieDB
//
//  Created by Alexandra Grimes on 6/21/18.
//  Copyright © 2018 Alexandra Grimes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchText: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var browseButton: UIButton!
    
    
//    func parseJSON () {
//        
//        // Get the data
//        let urlString = "https://api.themoviedb.org/3/search/multi?api_key=71ab1b19293efe581c569c1c79d0f004&query=shield"
//        let url = URL(string: urlString)
//        
//        let request = NSMutableURLRequest(url: url!)
//        request.httpMethod = "GET"
//        
//        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
//            guard error == nil else {
//                print("Error: The URL Session returned error.")
//                return
//            }
//            
//            guard let content = data else {
//                print("Error: No data.")
//                return
//            }
//            
//            guard let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers), let jsonDict = json as? [String: Any] else {
//                print("Error: Data could not be parsed.")
//                return
//            }
//            
//            guard let dict = jsonDict as [String: Any]? else {
//                print("Error: Json not read.")
//                return
//            }
//            
//            print(dict)
//        }
//    
//        task.resume()
//        
//    }
//    
//    @IBAction func searchButtonHandler(sender: UIButton) {
//
//        let searchInput = searchBar.text
//
//    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

