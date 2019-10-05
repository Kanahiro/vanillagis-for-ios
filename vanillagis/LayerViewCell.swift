//
//  LayerViewCell.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/10/05.
//  Copyright © 2019 Labo288. All rights reserved.
//

import UIKit
import Mapbox

class LayerViewCell: UITableViewCell {

    @IBOutlet weak var layerNameLabel: UILabel!
    
    @IBOutlet weak var layerSwitch: UISwitch!
    @IBAction func layerSwitchChanged(_ sender: Any) {
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
