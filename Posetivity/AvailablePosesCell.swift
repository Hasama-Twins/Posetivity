//
//  AvailablePosesCell.swift
//  Posetivity
//
//  Created by Summer Hasama on 10/17/20.
//

import UIKit

class AvailablePosesCell: UITableViewCell {

    @IBOutlet weak var availablePoseImage: UIImageView!
    
    @IBOutlet weak var poseName: UILabel!
    @IBOutlet weak var poseLevel: UILabel!
    @IBOutlet weak var poseDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
