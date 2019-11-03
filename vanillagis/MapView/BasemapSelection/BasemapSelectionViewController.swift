//
//  SettingViewController.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/10/23.
//  Copyright © 2019 Labo288. All rights reserved.
//

import UIKit
import Mapbox

class BasemapSelectionViewController: UIViewController {
    var mapView:MGLMapView!
    let basemaps = [
        ["identifier":"国土地理院オルソ",
         "tileUrl":"https://cyberjapandata.gsi.go.jp/xyz/seamlessphoto/{z}/{x}/{y}.jpg",
         "attributionUrl":"https://maps.gsi.go.jp/development/ichiran.html"],
        ["identifier":"国土地理院標準地図",
        "tileUrl":"https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png",
        "attributionUrl":"https://maps.gsi.go.jp/development/ichiran.html"],
        ["identifier":"国土地理院陰影起伏図",
        "tileUrl":"https://cyberjapandata.gsi.go.jp/xyz/hillshademap/{z}/{x}/{y}.png",
        "attributionUrl":"https://maps.gsi.go.jp/development/ichiran.html"],
        ["identifier":"MIERUNE",
        "tileUrl":"https://tile.mierune.co.jp/mierune/{z}/{x}/{y}.png",
        "attributionUrl":"https://mierune.co.jp/"],
        ["identifier":"MIERUNE MONO",
        "tileUrl":"https://tile.mierune.co.jp/mierune_mono/{z}/{x}/{y}.png",
        "attributionUrl":"https://mierune.co.jp/"],
    ]
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTableView()
        self.initToolbar()
    }
    
    func initTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 44), style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    func initToolbar() {
        var myToolbar: UIToolbar!
        myToolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.size.height - 44, width: self.view.bounds.size.width, height: 44.0))
        myToolbar.isTranslucent = false
        let barCancelButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.closeButtonCilick(sender:)))
        barCancelButton.tag = 1
        
        myToolbar.items = [barCancelButton]
        
        self.view.addSubview(myToolbar)
    }
    
    @objc func closeButtonCilick(sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BasemapSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.basemaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.basemaps[indexPath.row]["identifier"]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let basemap = self.basemaps[indexPath.row]
        var msManager = MapStyleManager()
        msManager.setBasemap(name:basemap["identifier"]!, tileUrlStr:basemap["tileUrl"]!, attributionUrl:basemap["attributionUrl"]!)
        mapView.styleURL = msManager.writeJson(outputDir:"/tmp", filename:basemap["identifier"]!)
        self.dismiss(animated: true, completion: nil)
    }
}
