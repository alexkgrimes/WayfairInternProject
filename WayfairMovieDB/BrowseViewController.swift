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
    
    let imageSize = "w185/"
    let baseImageUrl = "https://image.tmdb.org/t/p/"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var images: [UIImage]? = []
    
    struct SearchResponse: Decodable {
        var results: [MediaEntry]
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
    
    func parseDataJSON(closure: @escaping (_ medias: SearchResponse) -> Void) {
        
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
    
    func getData(mediaEntries: SearchResponse) -> Void {
        DispatchQueue.main.async {
             if self.table != nil {
                self.mediaEntries = mediaEntries
                guard let entries = self.mediaEntries?.results else {
                    print("Media entries not set.")
                    return
                }
                
                for entry in entries {
                    var imagePath: String?
                    
                    if entry.mediaType == "tv" || entry.mediaType == "movie" {
                        imagePath = entry.posterPath
                    } else if entry.mediaType == "person" {
                        imagePath = entry.profilePath
                    }
                    
                    guard let path = imagePath else {
                        print("Path not set")
                        return
                    }
                    
                    self.parseImageJSON(imagePath!, self.setImage)
                }
                self.table.reloadData()
            }
        }
    }
    
    func parseImageJSON(_ imagePath: String, _ imageClosure: @escaping (_ image: UIImage) -> Void) -> Void {
        let urlString = baseImageUrl + imageSize + imagePath
        let url = URL(string: urlString)
        
        let session = URLSession(configuration: .default)
        
        let getImageFromUrl = session.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print("Error: The URL Session returned error.")
                return
            }
            
            guard let imageData = data else {
                print("Error: image file is corrupted")
                return
            }
            
            let imageTmp = UIImage(data: imageData)
            imageClosure(imageTmp!)
        }
        
        getImageFromUrl.resume()
        
    }
    
    func setImage(_ image: UIImage) -> Void {
        DispatchQueue.main.async {
            if self.table != nil {
                self.images?.append(image)
                print(self.images?.count)
                self.table.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        parseDataJSON(closure: getData)
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
        let cell: SearchCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! SearchCell
        
        cell.typeLabel?.text = mediaEntries?.results[indexPath.row].mediaType
        
        let type = self.mediaEntries?.results[indexPath.row].mediaType
        var imagePath: String? = ""
        if type == "movie"{
            cell.mainLabel?.text = mediaEntries?.results[indexPath.row].title
            imagePath = mediaEntries?.results[indexPath.row].posterPath
        } else if type == "person" {
            cell.mainLabel?.text = mediaEntries?.results[indexPath.row].name
            imagePath = mediaEntries?.results[indexPath.row].profilePath
        }
        else if type == "tv" {
            cell.mainLabel?.text = mediaEntries?.results[indexPath.row].name
            imagePath = mediaEntries?.results[indexPath.row].posterPath
        }
        
        guard imagePath != nil else {
            print("Error: image path not set")
            return cell
        }
        
        if indexPath.row < images!.count {
            guard let cellImage = images?[indexPath.row] else {
                print("Image not set")
                return cell
            }
            
            cell.searchImage.image = cellImage
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
        detailsView.mediaTitle = md[indexPath.row].title
        detailsView.name = md[indexPath.row].name
        detailsView.overview = md[indexPath.row].overview
        detailsView.posterPath = md[indexPath.row].posterPath
        detailsView.profilePath = md[indexPath.row].profilePath
        detailsView.voteAverage = md[indexPath.row].voteAverage
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}









