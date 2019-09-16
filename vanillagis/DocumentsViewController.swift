//
//  DocumentsViewController.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/16.
//  Copyright © 2019 Labo288. All rights reserved.
//

//与えられたdirectoryに存在するすべてのファイルを一覧表示するビュー
//選択されたファイルは遷移元のビューのインスタンスへ直接入力される

import Foundation
import UIKit

class DocumentsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var directory:String!
    var senderViewController:MapViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        var myToolbar: UIToolbar!
        self.view.backgroundColor = UIColor.cyan
        myToolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.size.height - 44, width: self.view.bounds.size.width, height: 40.0))
        myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
        myToolbar.barStyle = UIBarStyle.blackTranslucent
        myToolbar.tintColor = UIColor.white
        myToolbar.backgroundColor = UIColor.black
        let barCancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style:.bordered, target: self, action: #selector(self.cancelButtonCilick(sender:)))
        barCancelButton.tag = 1
        myToolbar.items = [barCancelButton]
        
        self.view.addSubview(myToolbar)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: self.directory) else {
            return 0
        }
        return fileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: self.directory) else {
            return cell
        }
        cell.textLabel?.text = fileNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択されたgeojsonファイルのデータを、遷移元のビューコントローラのインスタンスに渡す
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: self.directory) else {
            return
        }
        let filepath = URL(fileURLWithPath: self.directory + "/" + fileNames[indexPath.row])
        let gjSourceModel = GeoJsonSourceModel(filepath: filepath)
        let source = gjSourceModel.makeSource()
        let layer = gjSourceModel.makeLayer()
        //set source and layer directly to the instance of previous ViewController
        self.senderViewController.mapModel.appendSource(source: source)
        self.senderViewController.mapModel.appendLayer(layer: layer)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonCilick(sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}