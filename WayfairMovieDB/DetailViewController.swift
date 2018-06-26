//
//  DetailViewController.swift
//  WayfairMovieDB
//
//  Created by Alexandra Grimes on 6/25/18.
//  Copyright © 2018 Alexandra Grimes. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    private var detailInfo: DetailInfo?
    
    var headerText: String = ""
    var detailsText: String = ""
    var mediaType = ""
    
    let movieBaseUrl = "https://api.themoviedb.org/3/movie/"
    let tvBaseUrl = "https://api.themoviedb.org/3/tv/"
    let personBaseUrl = "https://api.themoviedb.org/3/person/"
    var id: Int = 0
    let key = "?api_key=71ab1b19293efe581c569c1c79d0f004"
    
    struct DetailInfo: Decodable {
        
        let name: String
        
        let overview: String?
        
        let biography: String?
        let profilePath: String?
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func parseDetailInfoJSON(closure: @escaping (_ medias: DetailInfo) -> Void) {
        
        // Get the data
        
        var urlString = String(id) + key
        if mediaType == "movie" {
            urlString = movieBaseUrl + urlString
        } else if mediaType == "tv" {
            urlString = tvBaseUrl + urlString
        } else if mediaType == "person" {
            urlString = personBaseUrl + urlString
        }
        
        print(urlString)
        
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
                var detailInfoTmp = try decoder.decode(DetailInfo.self, from: jsonContent)
                closure(detailInfoTmp)
                print(self.detailInfo)
            } catch let error {
                print("Error when loading into mediaEntries")
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getData(detailInfo: DetailInfo) -> Void{
        DispatchQueue.main.async {
            self.detailInfo = detailInfo
            self.headerLabel.text = self.detailInfo?.name
            if self.mediaType == "movie" || self.mediaType == "tv" {
                self.detailsLabel.text = self.detailInfo?.overview
            } else if self.mediaType == "person" {
                self.detailsLabel.text = self.detailInfo?.biography
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parseDetailInfoJSON(closure: getData)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
