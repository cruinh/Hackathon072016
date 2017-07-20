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
        
        let material = SCNMaterial()
        material.lightingModel = .blinn
        
//        let boxTexture = UIImage(named: "boxTexture.png")
        let blueTexture = UIColor(colorLiteralRed: 2, green: 170, blue: 243, alpha: 0.3)
        material.diffuse.contents = [blueTexture]
        
        let geometry = SCNBox(width: oneFoot, height:oneFoot, length:oneFoot, chamferRadius:0.0)
        geometry.materials = [material]
        
        let cubeNode = SCNNode(geometry: geometry)
        cubeNode.position = SCNVector3(0, oneFoot/2, 0)
        
        super.init(childNodes: [cubeNode], thumbImageFilename: "measurementCube", title: "Measurement Cube")
        
        self.position = SCNVector3(0, oneFoot/2, 0)
        
    }
    
    
    override func loadModel() {
        super.loadModel()
        
        for node in self.childNodes {
            print("\(type(of:node))")
            
            if let box = node.geometry as? SCNBox {
                print("box with height:\(box.height) width:\(box.width)")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
