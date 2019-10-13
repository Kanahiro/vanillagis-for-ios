//
//  LayerViewCell.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/10/05.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

class LayerViewCell: UITableViewCell {
    var mapView:MGLMapView!
    var selectedLayer:MGLStyleLayer!
    var senderViewController:UIViewController!
    
    @IBOutlet weak var layerNameLabel: UILabel!
    @IBOutlet weak var layerTypeLabel: UILabel!
    
    @IBOutlet weak var layerSwitch: UISwitch!
    
    @IBAction func layerEditButton(_ sender: Any) {
        let sb = UIStoryboard(name: "LayerEditViewController", bundle: nil)
        guard let layerEditVc = sb.instantiateInitialViewController() as? LayerEditViewController else { return }
        layerEditVc.mapView = mapView
        layerEditVc.layer = selectedLayer
        senderViewController.present(layerEditVc, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layerType(layer:MGLStyleLayer) -> String {
        let layerClass = String(describing: type(of: layer))
        switch layerClass {
        case "MGLRasterStyleLayer":
            return "Raster"
        case "MGLCircleStyleLayer", "MGLHeatmapStyleLayer":
            return "Point"
        case "MGLLineStyleLayer":
            return "Polyline"
        case "MGLFillStyleLayer":
            return "Polygon"
        default:
            return layerClass
        }
    }
    
}
