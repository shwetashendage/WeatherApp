//
//  WATableViewCell.swift
//  Weather
//
//  Created by Shrikant on 25/03/18.
//  Copyright © 2018 Shweta. All rights reserved.
//

import UIKit

class WATableViewCell: UITableViewCell {
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
