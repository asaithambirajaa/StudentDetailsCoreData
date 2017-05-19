//
//  StudentTableViewCell.swift
//  StudentDetailsCoreData
//
//  Created by raja A on 5/9/17.
//  Copyright © 2017 Canny. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet var nameLab: UILabel!
    @IBOutlet var regNoLab: UILabel!
    @IBOutlet var emailLab: UILabel!
    @IBOutlet var phoneLab: UILabel!
    @IBOutlet var dobLab: UILabel!
    @IBOutlet var genderLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
