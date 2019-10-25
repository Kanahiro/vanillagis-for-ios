//
//  FirstViewController.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/13.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import UIKit

class FirstViewController: UIViewController {
    var tableView: UITableView!
    var mapModels: [MapModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Vanilla GIS"
        
        self.createDocumentDir()
        
        self.initSettingButton()
        self.initNewButton()
        self.loadUserdefaults()
        self.initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func initSettingButton() {
        let settingBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.pushSettingButton(sender:)))
        self.navigationItem.leftBarButtonItem = settingBtn
    }
    
    func initNewButton() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.pushNewButton(sender:)))
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
    
    @objc func pushSettingButton(sender: UIButton){
        let sb = UIStoryboard(name: "SettingViewController", bundle: nil)
        guard let settingVc = sb.instantiateInitialViewController() as? SettingViewController else { return }
        self.navigationController?.pushViewController(settingVc, animated: true)
    }
    
    //ファイルアプリにvanillagisフォルダを作成する
    //geojson読み込みフォルダ、mapModel保存フォルダ
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

    }
    
}
extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapVc = MapViewController()
        let mapsPath = NSHomeDirectory() + "/Documents/maps"
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: mapsPath) else {
            return
        }
        
        let selectedPath = URL(fileURLWithPath: mapsPath + "/" + fileNames[indexPath.row])
        let mapData = try! Data(contentsOf: selectedPath)
        let loadedMap = NSKeyedUnarchiver.unarchiveObject(with: mapData) as! MapModel
        mapVc.mapModel = loadedMap
        
        self.navigationController?.pushViewController(mapVc, animated: true)
    }
}
