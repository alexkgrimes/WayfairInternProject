//
//  SearchCellTableViewCell.swift
//  WayfairMovieDB
//
//  Created by Alexandra Grimes on 6/27/18.
//  Copyright © 2018 Alexandra Grimes. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchImage.image = nil
        searchImage.backgroundColor = .darkGray
        //mainLabel = nil
        //typeLabel = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
