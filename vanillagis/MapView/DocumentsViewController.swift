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
    var directory:String!
    var senderViewController:MapViewController!
    var tableView: UITableView!
    
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
        DispatchQueue.global(qos: .userInteractive).async {
            //選択されたgeojsonファイルのデータを、遷移元のビューコントローラのインスタンスに渡す
            guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: self.directory) else {
                return
            }
            let filepath = URL(fileURLWithPath: self.directory + "/" + fileNames[indexPath.row])
            let gjSourceModel = GeoJsonSourceModel(filepath: filepath)
            let source = gjSourceModel.makeSource()
            let layer = gjSourceModel.makeLayer()
            //set source and layer directly to the instance of previous ViewController
            if (self.senderViewController.addLayer(source: source, layer: layer)) {
                print("error")
            }
        }
        self.dismiss(animated: true, completion: nil)
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
