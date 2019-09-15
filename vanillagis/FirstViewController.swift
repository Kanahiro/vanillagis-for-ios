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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createDocumentDir()
        
        let newButton:UIButton = UIButton(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height / 5))
        newButton.backgroundColor = .white
        newButton.setTitle("New Map", for: .normal)
        newButton.setTitleColor(.black, for: .normal)
        newButton.addTarget(self, action: #selector(pushNewButton), for: .touchUpInside)

        self.view.addSubview(newButton)
    }
    
    @objc func pushNewButton(sender: UIButton){
        let mapVc = MapViewController()
        var newMapModel = MapModel(name: "New Map")
        
        let jsonUrl:URL = Bundle.main.url(forResource: "test", withExtension: "geojson")!
        print(jsonUrl)
        let geojson = GeoJsonSourceModel(filepath:jsonUrl)
        print(geojson.getType())
        let source = geojson.makeSource()
        let layer = geojson.makeLayer()
        
        newMapModel.appendSource(source: source)
        newMapModel.appendLayer(layer: layer)
        
        mapVc.mapModel = newMapModel
        
        
        present(mapVc, animated: true, completion: nil)
    }
    
    //ファイルアプリにvanillagisフォルダを作成する
    func createDocumentDir() {
        let fm = FileManager.default
        let documentsPath = NSHomeDirectory() + "/Documents"
        let stylesDir = "/styles"
        let geojsonsDir = "/geojsons"
        do {
            try fm.createDirectory(atPath: (documentsPath + stylesDir) , withIntermediateDirectories: false, attributes: [:])
            try fm.createDirectory(atPath: (documentsPath + geojsonsDir) , withIntermediateDirectories: false, attributes: [:])
        } catch {
        }
        
        //default.jsonを保存
        /*
         let filename = "/default.json"
         let filePath = documentsPath + stylesDir + filename
         if fm.fileExists(atPath: filePath) {return}
         
         var fileData:Data?
         do {
         let fileUrl = Bundle.main.url(forResource: "default", withExtension: "json")
         fileData = try Data(contentsOf: fileUrl!)
         } catch {
         fileData = nil
         }
         
         fm.createFile(atPath: filePath, contents: fileData, attributes: [:])
         */
    }
}
