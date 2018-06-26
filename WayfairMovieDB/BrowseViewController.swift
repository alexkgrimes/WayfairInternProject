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
    
    @IBOutlet weak var table: UITableView!
    
    private var mediaEntries: SearchResponse?
    var query: String = ""
    let baseUrl = "https://api.themoviedb.org/3/search/multi?api_key=71ab1b19293efe581c569c1c79d0f004&query="
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    struct SearchResponse: Decodable {
        let results: [MediaEntry]
        
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
    
    func parseJSON(closure: @escaping (_ medias: SearchResponse) -> Void) {
        
        // Get the data
        let urlString = baseUrl + query
        let url = URL(string: urlString)
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        
        // Process the data into mediaEntries
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
                let mediaEntriestmp = try decoder.decode(SearchResponse.self, from: jsonContent)
                closure(mediaEntriestmp)
            } catch let error {
                print("Error when loading into mediaEntries")
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getData(mediaEntries: SearchResponse) -> Void{
        DispatchQueue.main.async {
             if self.table != nil {
                self.mediaEntries = mediaEntries
                self.table.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        parseJSON(closure: getData)
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
        let detailsView = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        guard let md = mediaEntries?.results else {
            print("Error: Invalid media entry")
            return
        }
        detailsView.id = md[indexPath.row].id
        detailsView.mediaType = md[indexPath.row].mediaType
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}









