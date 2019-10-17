//
//  FirstViewController.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/13.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var mapModels: [MapModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Vanilla GIS"
        
        self.createDocumentDir()
        
        self.initNewButton()
        self.loadUserdefaults()
        self.initTableView()
    }
    
    func initNewButton() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.pushNewButton(sender:)))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    func initTableView() {
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func loadUserdefaults() {
        //get mapmodel data from userdefaults
        if let storedData = UserDefaults.standard.object(forKey: "MapModels") as? Data {
             if let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? [MapModel] {
                self.mapModels = unarchivedObject
             }
         }
    }
    
    @objc func pushNewButton(sender: UIButton){
        let mapVc = MapViewController()
        self.navigationController?.pushViewController(mapVc, animated: true)
    }
    
    //ファイルアプリにvanillagisフォルダを作成する
    func createDocumentDir() {
        let fm = FileManager.default
        let documentsPath = NSHomeDirectory() + "/Documents"
        let mapsDir = "/maps"
        let geojsonsDir = "/geojsons"
        do {
            try fm.createDirectory(atPath: (documentsPath + mapsDir) , withIntermediateDirectories: false, attributes: [:])
            try fm.createDirectory(atPath: (documentsPath + geojsonsDir) , withIntermediateDirectories: false, attributes: [:])
        } catch {
        }
        
        /*
        //default.jsonを保存
         let filename = "/testest.geojson"
         let filePath = documentsPath + geojsonsDir + filename
         if fm.fileExists(atPath: filePath) {return}
         
         var fileData:Data?
         do {
         let fileUrl = Bundle.main.url(forResource: "sample", withExtension: "geojson")
         fileData = try Data(contentsOf: fileUrl!)
         } catch {
         fileData = nil
         }
         
         fm.createFile(atPath: filePath, contents: fileData, attributes: [:])
         */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mapsPath = NSHomeDirectory() + "/Documents/maps"
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: mapsPath) else {
            return 0
        }
        return fileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mapsPath = NSHomeDirectory() + "/Documents/maps"
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: mapsPath) else {
            return cell
        }
        cell.textLabel?.text = fileNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapVc = MapViewController()
        let mapsPath = NSHomeDirectory() + "/Documents/maps"
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: mapsPath) else {
            return
        }
        
        self.navigationController?.pushViewController(mapVc, animated: true)
    }
}
