//
//  BrowseViewController.swift
//  WayfairMovieDB
//
//  Created by Alexandra Grimes on 6/21/18.
//  Copyright © 2018 Alexandra Grimes. All rights reserved.
//

import Foundation
import UIKit

class BrowseViewController: UIViewController {
    

    private var mediaEntries: SearchResponse?
    
    struct SearchResponse: Decodable {
        let results: [MediaEntry]
        
        init(results: [MediaEntry]) {
            self.results = results
        }
    }
    
    struct MediaEntry: Decodable {
        
        let id: Int
        let mediaType: String
        let title: String?
        let name: String?
        let posterPath: String?
        let profilePath: String?
        
        let voteAverage: Double?
        let voteCount: Double?
        
        let overview: String?
   
    }
    
    func parseJSON () {
        
        // Get the data
        // let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=71ab1b19293efe581c569c1c79d0f004"
        let urlString = "https://api.themoviedb.org/3/search/multi?api_key=71ab1b19293efe581c569c1c79d0f004&query=shield"
        let url = URL(string: urlString)
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard error == nil else {
                print("Error: The URL Session returned error.")
                return
            }
            
            guard let jsonContent = data else {
                print("Error: No data.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.mediaEntries = try decoder.decode(SearchResponse.self, from: jsonContent)
            } catch let error {
                print("Error: Could not decode data.")
            }
            
//            print(self.mediaEntries?.results.first?.mediaType)
//            print(self.mediaEntries?.results.count)
        
            
        }
        
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        parseJSON()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BrowseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numEntries = mediaEntries?.results.count else {
            return 0
        }
        
        return numEntries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = mediaEntries?.results[indexPath.row].mediaType
        
        let type = self.mediaEntries?.results[indexPath.row].mediaType
        if type == "movie"{
            cell.detailTextLabel?.text = mediaEntries?.results[indexPath.row].title
        } else if type == "person" || type == "tv" {
            cell.detailTextLabel?.text = mediaEntries?.results[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}









