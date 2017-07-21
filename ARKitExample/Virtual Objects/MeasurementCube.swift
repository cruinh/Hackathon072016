//
//  MeasurementCube.swift
//  ARKitExample
//
//  Created by Matthew Hayes on 7/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import SceneKit

class MeasurementCube: VirtualObject {
    private let oneFoot = CGFloat(0.3048)
    
    
    override init() {
        
        super.init(modelName: "measurementCube", fileExtension: "scn", thumbImageFilename: "measurementCube", title: "Measurement")
        
//        let material = SCNMaterial()
//        material.lightingModel = .blinn
//        
////        let boxTexture = UIImage(named: "boxTexture.png")
//        let blueTexture = UIColor(colorLiteralRed: 2, green: 170, blue: 243, alpha: 0.3)
//        material.diffuse.contents = [blueTexture]
//        
//        let geometry = SCNBox(width: oneFoot, height:oneFoot, length:oneFoot, chamferRadius:0.0)
//        geometry.materials = [material]
//        
//        super.init(geometry: geometry, thumbImageFilename: "measurementCube", title: "Measurement Cube")
//        
//        self.position = SCNVector3(0, oneFoot/2, 0)
    }
    
    override func loadModel() {
        super.loadModel()
        
        guard let wrapperNode = childNodes.first else { return }
        
        wrapperNode.childNodes.forEach { (node) in
            if let fakeBoxGeometry = node.geometry
            {
                let boxGeometry = SCNBox(width: 1, height:1, length:1, chamferRadius:0.0)
                boxGeometry.materials = fakeBoxGeometry.materials
                let boxNode = SCNNode(geometry: boxGeometry)
                boxNode.scale = node.scale
                boxNode.rotation = node.rotation
                boxNode.position = node.position //SCNVector3(node.position.x, Float(oneFoot/2.0), node.position.y)
                boxNode.transform = node.transform
                boxNode.eulerAngles = node.eulerAngles
                boxNode.orientation = node.orientation
                boxNode.pivot = node.pivot
                
                node.removeFromParentNode()
                wrapperNode.addChildNode(boxNode)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
