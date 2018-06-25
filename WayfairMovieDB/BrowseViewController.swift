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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseJSON(closure: getData)
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
                var mediaEntriestmp = try decoder.decode(SearchResponse.self, from: jsonContent)
                closure(mediaEntriestmp)
            } catch let error {
                print("Error when loading into mediaEntries")
            }
            
            print("Self.mediaEntries.count after json reading; \(self.mediaEntries?.results.count)")
            
            
        }
        
        task.resume()
    }
    
    func getData(mediaEntries: SearchResponse) -> Void{
        DispatchQueue.main.async {
            self.mediaEntries = mediaEntries
            self.table.reloadData()
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

extension BrowseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Table view numEntries: \(mediaEntries?.results.count)")
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
        let detailsView = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}









