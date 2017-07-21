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
                boxNode.position = node.position
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
