//
//  CurrentNewsTableViewCell.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 14.05.2023..
//

import UIKit

class CurrentNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var newsImageView: UIImageView?
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
