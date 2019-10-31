//
//  AttributesTableView.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/10/13.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

class AttributesWindowView: UIView, UITableViewDelegate, UITableViewDataSource {
    var headers:[String]!
    var values:[Any]!
    var tableView:UITableView!
    
    func initTableView() {
        self.tableView = UITableView(frame:self.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.allowsSelection = false
        tableView.rowHeight = 30
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        tableView.delegate = self
        tableView.dataSource = self
        
        //custom cell
        let nib = UINib(nibName: "AttributesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "attributesTableViewCell")
        
        self.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( headers != nil ) {
            return headers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attributesTableViewCell") as! AttributesTableViewCell
        
        if ( headers != nil ) {
            cell.headerLabel?.text = headers[indexPath.row]
            cell.valueLabel?.text = String(describing: values[indexPath.row])
        } else {
            cell.headerLabel?.text = ""
            cell.valueLabel?.text = ""
        }
        return cell
    }
}
