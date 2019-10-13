//
//  AttributesTableViewCell.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/10/13.
//  Copyright © 2019 Labo288. All rights reserved.
//

import UIKit

class AttributesTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
