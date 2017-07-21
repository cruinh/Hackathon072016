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

class MeasurementCube2: VirtualObject {
    private let oneFoot = CGFloat(0.3048)
    
    var topNode : SCNNode?
    var frontNode : SCNNode?
    var backNode : SCNNode?
    var rightNode : SCNNode?
    var leftNode : SCNNode?
    
    var allPlanes : [SCNNode] {
        let all : [SCNNode?] = [topNode,frontNode,backNode,rightNode,leftNode]
        return all.flatMap({$0})
    }
    
    var topPlane : SCNPlane? { return topNode?.geometry as? SCNPlane }
    var frontPlane : SCNPlane? { return frontNode?.geometry as? SCNPlane }
    var backPlane : SCNPlane? { return backNode?.geometry as? SCNPlane }
    var rightPlane : SCNPlane? { return rightNode?.geometry as? SCNPlane }
    var leftPlane : SCNPlane? { return leftNode?.geometry as? SCNPlane }
    
    let unselectedColor = UIColor(displayP3Red: 7, green: 137, blue: 243, alpha: 1.0)
    let selectedColor = UIColor.yellow
    
    var selectedNode : SCNNode?
    
    private let distinctColors = false
    
    override init() {
        super.init(modelName: "measurementCube", fileExtension: "scn", thumbImageFilename: "measurementCube", title: "Measurement2")
    }
    
    func select(planeNode: SCNNode) {
        guard allPlanes.contains(planeNode),
            let geometry = planeNode.geometry,
            let material = geometry.materials.first else { return }
        
        if selectedNode == planeNode {
            material.diffuse.contents = unselectedColor
            selectedNode = nil
        } else {
            selectedNode?.geometry?.materials.first?.diffuse.contents = unselectedColor
            
            material.diffuse.contents = selectedColor
            selectedNode = planeNode
        }
    }
    
    func hitTestFoundPlaneNode(results: [SCNHitTestResult]) -> SCNNode? {
        for result in results {
            for plane in allPlanes {
                if plane.name == result.node.name {
                    return plane
                }
            }
        }
        return nil
    }
    
    override func loadModel() {
        super.loadModel()
        
        var topColor = unselectedColor
        var frontColor = unselectedColor
        var backColor = unselectedColor
        var rightColor = unselectedColor
        var leftColor = unselectedColor
        
        //DEBUGGING
        if distinctColors {
            topColor = UIColor.cyan
            frontColor = UIColor.green
            backColor = UIColor.red
            rightColor = UIColor.yellow
            leftColor = UIColor.blue
        }
        
        guard let wrapperNode = childNodes.first else { return }
        
        wrapperNode.childNodes.forEach { (node) in
            if let sceneFileGeometry = node.geometry, let sceneFileMaterial = sceneFileGeometry.materials.first
            {
                node.removeFromParentNode()
                
                let frontGeometry = SCNPlane(width: 1, height: 1)
                let frontMaterial = sceneFileMaterial.copy() as! SCNMaterial
                frontMaterial.diffuse.contents = frontColor
                frontGeometry.materials = [frontMaterial]
                frontNode = SCNNode(geometry: frontGeometry)
                frontNode!.name = "frontNode"
                frontNode!.position = SCNVector3(0.0, 0.5, 0.5)
                wrapperNode.addChildNode(frontNode!)
                
                let backGeometry = SCNPlane(width: 1, height: 1)
                let backMaterial = sceneFileMaterial.copy() as! SCNMaterial
                backMaterial.diffuse.contents = backColor
                backGeometry.materials = [backMaterial]
                backNode = SCNNode(geometry: backGeometry)
                backNode!.name = "backNode"
                backNode!.rotation = SCNVector4(0, 1, 0, -Float.pi)
                backNode!.position = SCNVector3(0.0, 0.5, -0.5)
                wrapperNode.addChildNode(backNode!)
                
                let rightGeometry = SCNPlane(width: 1, height: 1)
                let rightMaterial = sceneFileMaterial.copy() as! SCNMaterial
                rightMaterial.diffuse.contents = rightColor
                rightGeometry.materials = [rightMaterial]
                rightNode = SCNNode(geometry: rightGeometry)
                rightNode!.name = "rightNode"
                rightNode!.rotation = SCNVector4(0, 1, 0, Float.pi/2)
                rightNode!.position = SCNVector3(0.5, 0.5, 0.0)
                wrapperNode.addChildNode(rightNode!)
                
                let leftGeometry = SCNPlane(width: 1, height: 1)
                let leftMaterial = sceneFileMaterial.copy() as! SCNMaterial
                leftMaterial.diffuse.contents = leftColor
                leftGeometry.materials = [leftMaterial]
                leftNode = SCNNode(geometry: leftGeometry)
                leftNode!.name = "leftNode"
                leftNode!.rotation = SCNVector4(0, 1, 0, -Float.pi/2)
                leftNode!.position = SCNVector3(-0.5, 0.5, 0.0)
                wrapperNode.addChildNode(leftNode!)
                
                let topGeometry = SCNPlane(width: 1, height: 1)
                let topMaterial = sceneFileMaterial.copy() as! SCNMaterial
                topMaterial.diffuse.contents = topColor
                topGeometry.materials = [topMaterial]
                topNode = SCNNode(geometry: topGeometry)
                topNode!.name = "topNode"
                topNode!.rotation = SCNVector4(1, 0, 0, -Float.pi/2)
                topNode!.position = SCNVector3(0, 1.0, 0.0)
                wrapperNode.addChildNode(topNode!)
            }
        }
        
    }
    
    func highlightSelectedNode() {
        guard let selectedNode = selectedNode, let material = selectedNode.geometry?.materials.first else { return }
        
        material.diffuse.contents = [selectedColor]
    }
    
    func unhighlightSelectedNode() {
        guard let selectedNode = selectedNode, let material = selectedNode.geometry?.materials.first else { return }
        
        material.diffuse.contents = [unselectedColor]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
