//
//  SupportPostCell.swift
//  Posetivity
//
//  Created by Summer Hasama on 10/17/20.
//

import UIKit

class SupportPostCell: UITableViewCell {


    @IBOutlet weak var poseTopLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
        
    @IBAction func likeButtonClicked(_ sender: Any) {
        self.favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
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
