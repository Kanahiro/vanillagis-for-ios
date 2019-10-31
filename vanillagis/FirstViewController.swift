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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Vanilla GIS"
        
        self.createDocumentDir()
        
        self.initButtons()
        self.initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func initButtons() {
        let settingBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.pushSettingButton(sender:)))
        self.navigationItem.leftBarButtonItem = settingBtn
        
        let newBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.pushNewButton(sender:)))
        self.navigationItem.rightBarButtonItem = newBtn
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
    
    func initTableView() {
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
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

//tableview delegate protocols
extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    func getMapDataFileNames() -> [String] {
        let mapsPath = NSHomeDirectory() + "/Documents/maps"
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: mapsPath) else {
            return []
        }
        return fileNames
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getMapDataFileNames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.getMapDataFileNames()[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPath = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/maps/" + self.getMapDataFileNames()[indexPath.row])
        let mapData = try! Data(contentsOf: selectedPath)
        let loadedMap = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mapData) as! MapModel
        
        let mapVc = MapViewController()
        mapVc.mapModel = loadedMap
        
        self.navigationController?.pushViewController(mapVc, animated: true)
    }
}
