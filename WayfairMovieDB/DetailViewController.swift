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
    @IBOutlet weak var detailsLabel: UITextView!
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    
    var detailInfo: DetailInfo?
    
    let personBaseUrl = "https://api.themoviedb.org/3/person/"
    let key = "?api_key=71ab1b19293efe581c569c1c79d0f004"
    
    var id: Int = 0
    var mediaType: String = ""
    var mediaTitle: String? = ""
    var name: String? = ""

    var image: UIImage? = UIImage()
    
    var biography: String? = ""
    var overview: String? = ""
    
    var starsText: String? = ""
    
    struct DetailInfo: Decodable {
        var name: String?
        var biography: String?
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func parseDetailInfoJSON(closure: @escaping (_ medias: DetailInfo) -> Void) {
        
        // Get the data
        let urlString = personBaseUrl + String(id) + key

        if mediaType != "person" {
            return
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
                let detailInfoTmp = try decoder.decode(DetailInfo.self, from: jsonContent)
                closure(detailInfoTmp)
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
            
            if self.mediaType == "person" {
                self.headerLabel.text = self.detailInfo?.name
                self.detailsLabel.text = self.detailInfo?.biography
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parseDetailInfoJSON(closure: getData)
        
        var headerText: String?
        var detailText: String?
        var typeText: String?
        var typeColor: UIColor?
        let type = mediaType
        if type == "movie" {
            headerText = mediaTitle
            detailText = overview
            typeText = "MOVIE"
            typeColor = .red
        } else if type == "tv"{
            headerText = name
            detailText = overview
            typeText = "TV SHOW"
            typeColor = .green
        } else if type == "person" {
            headerText = name
            detailText = biography
            typeText = "THE ACTOR"
            typeColor = .blue
        }
        
        headerLabel.text = headerText
        detailsLabel.text = detailText

        detailImageView.image = image
        detailImageView.contentMode = UIViewContentMode.scaleAspectFill
        detailImageView.clipsToBounds = true
        detailImageView.layer.borderWidth = 0
        
        mainLabel.text = headerText
        typeLabel.text = typeText
        // typeLabel.backgroundColor = typeColor
        starLabel.text = starsText

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
