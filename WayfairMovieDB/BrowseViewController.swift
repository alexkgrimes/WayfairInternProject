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
    @IBOutlet weak var queryLabel: UILabel!
    
    private var mediaEntries: SearchResponse?
    private var images: [String: UIImage] = [:]
    
    var query: String = ""
    let baseUrl: String = "https://api.themoviedb.org/3/search/multi?api_key=71ab1b19293efe581c569c1c79d0f004&query="
    let baseImageUrl = "https://image.tmdb.org/t/p/"
    
    var queryLabelText: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
            guard self.table != nil else {
                print("Table is not initialized")
                return
            }
            
            self.mediaEntries = mediaEntries
            guard let entries = self.mediaEntries?.results else {
                print("Media entries not set.")
                return
            }
        
            if entries.count == 0 {
                self.queryLabel.text = "No results found"
            } else {
                self.queryLabel.text = "Search Results for \"\(self.query)\""
            }
            
            for entry in entries {
                var imagePath: String?
                var imageSize: String?
                
                let type = entry.mediaType
                if type == "tv" || type == "movie" {
                    imagePath = entry.posterPath
                    imageSize = "w780/"
                } else if type == "person" {
                    imagePath = entry.profilePath
                    imageSize = "h632/"
                }
                
                guard imagePath != nil else {
                    print("JSON did not include a path")
                    continue
                }
            
                self.parseImageJSON(imagePath!, imageSize!, self.setImage)
            }
        }
    }
    
    func parseImageJSON(_ imagePath: String, _ imageSize: String, _ imageClosure: @escaping (_ image: UIImage, _ imagePath: String) -> Void) -> Void {
        
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
            
            guard let imageTmp = UIImage(data: imageData) else {
                print("Image not able to be cast to UIImage")
                return
            }
            
            imageClosure(imageTmp, imagePath)
        }
        getImageFromUrl.resume()
    }
    
    func setImage(_ image: UIImage, _ imagePath: String) -> Void {
        DispatchQueue.main.async {
            self.images[imagePath] = image
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        parseDataJSON(closure: getData)

//        queryLabel.text = "Search Results for \"\(self.query)\""
//        if mediaEntries?.results.count == 0 {
//             queryLabel.text = "No results"
//        }
        var searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
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
        
        if numEntries == 0 {
            queryLabel.text = "No results"
        }
        
        return numEntries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! SearchCell
        
        let type = self.mediaEntries?.results[indexPath.row].mediaType
        
        var mainText: String? = ""
        var imagePath: String? = ""
        var typeText: String? = ""
        var typeBackgroundColor: UIColor?
        if type == "movie"{
            mainText = mediaEntries?.results[indexPath.row].title
            typeText = "MOVIE"
            typeBackgroundColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:1.0)
            imagePath = mediaEntries?.results[indexPath.row].posterPath
        } else if type == "person" {
            mainText = mediaEntries?.results[indexPath.row].name
            typeText = "THE ACTOR"
            typeBackgroundColor = UIColor(red:0.20, green:0.40, blue:1.00, alpha:1.0)
            imagePath = mediaEntries?.results[indexPath.row].profilePath
        }
        else if type == "tv" {
            mainText = mediaEntries?.results[indexPath.row].name
            typeText = "TV SHOW"
            typeBackgroundColor = UIColor(red:0.40, green:0.80, blue:0.40, alpha:1.0)
            imagePath = mediaEntries?.results[indexPath.row].posterPath
        }
    
        var typeAttributedText = NSAttributedString(string: typeText!, attributes: [NSAttributedStringKey.backgroundColor : typeBackgroundColor])
        cell.typeLabel.attributedText = typeAttributedText
        cell.mainLabel?.text = mainText
        cell.starsLabel?.text = ""
        
        // Make stars label
        if mediaEntries?.results[indexPath.row].voteAverage != nil {
            let rating = mediaEntries?.results[indexPath.row].voteAverage
            let ratingOutOfFive = rating! / 2.0
            let starString = NSMutableString()
            let activeStar = "\u{2605}"
            let inactiveStar = "\u{2606}"
            
            for i in 1...5 {
                if (ratingOutOfFive >= Double(i)) {
                    starString.append(activeStar)
                } else {
                    starString.append(inactiveStar)
                }
            }
            cell.starsLabel?.text = String(starString)
        }
        
        // Set image in tableview
        guard let path = imagePath else {
            print("Image path not set in JSON, so don't set image in table cell")
            return cell
        }
        
        if let cellImage = images[path] {
            
            cell.searchImage.image = cellImage
            cell.searchImage.contentMode = UIViewContentMode.scaleAspectFill
            cell.searchImage.layer.cornerRadius = (cell.searchImage.frame.size.width) / 16
            cell.searchImage.clipsToBounds = true
            cell.searchImage.layer.borderWidth = 12
            cell.searchImage.layer.borderColor = UIColor.white.cgColor as CGColor
        
        } else {
            cell.searchImage.image = nil
        }
        
        return cell
    }
    
    /*
        Row selected at func
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailsView = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        guard let md = mediaEntries?.results else {
            print("Error: Media entries not set")
            return
        }
        
        detailsView.id = md[indexPath.row].id
        detailsView.mediaType = md[indexPath.row].mediaType
        detailsView.mediaTitle = md[indexPath.row].title
        detailsView.name = md[indexPath.row].name
        detailsView.overview = md[indexPath.row].overview
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! SearchCell
        
        detailsView.starsText = currentCell.starsLabel.text

        let type = self.mediaEntries?.results[indexPath.row].mediaType
        
        var imagePath: String? = ""
        if type == "movie" {
            imagePath = md[indexPath.row].posterPath
        } else if type == "person" {
            imagePath = md[indexPath.row].profilePath
        } else if type == "tv" {
            imagePath = md[indexPath.row].posterPath
        }
        
        if let path = imagePath, let detailImage = images[path] {
            detailsView.image = detailImage
        } else {
            let imageName = "no-image-available.jpg"
            let noImage = UIImage(named: imageName)
            detailsView.image = noImage
        }
        
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
}











