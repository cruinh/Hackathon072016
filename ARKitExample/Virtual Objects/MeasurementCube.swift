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
    
    private var _initialSize : SCNVector3?
    private lazy var initialSize : SCNVector3 = {
        guard _initialSize == nil else { return _initialSize! }
        _initialSize = SCNVector3(oneFoot/10, oneFoot/10, 0)
        _initialSize = SCNVector3(1, 1, 1)
        return _initialSize!
    }()
    
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
    
    let unselectedColor = UIColor(displayP3Red: 7/255, green: 137/255, blue: 243/255, alpha: 0.5)
    let selectedColor = UIColor.yellow
    
    var selectedNode : SCNNode?
    
    private let distinctColors = false
    
    override init() {
        super.init(modelName: "measurementCube", fileExtension: "scn", thumbImageFilename: "measurementCube", title: "Measurement2")
    }
    
    func select(planeNode: SCNNode?) {
        guard let planeNode = planeNode else { return }
        guard allPlanes.contains(planeNode) else { return }
        
        if selectedNode == planeNode {
            _unselect(planeNode)
        } else {
            _unselect(selectedNode)
            _select(planeNode)
        }
    }
    
    private func _select(_ node: SCNNode?) {
        node?.geometry?.materials.first?.diffuse.contents = selectedColor
        selectedNode = node
    }
    
    private func _unselect(_ node: SCNNode?) {
        node?.geometry?.materials.first?.diffuse.contents = unselectedColor
        if node == selectedNode {
            selectedNode = nil
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
    
    override func scale2(_ amount: SCNVector3, basePosition: SCNVector3) {
        guard let selectedNode = selectedNode else {
            super.scale2(amount, basePosition:basePosition)
            return
        }
        
        if selectedNode == topNode {
            scale = SCNVector3Make(scale.x, Float(amount.y), scale.z)
        } else if selectedNode == frontNode || selectedNode == backNode {
            scale = SCNVector3Make(scale.x, scale.y, amount.z)
        } else if selectedNode == rightNode || selectedNode == leftNode {
            scale = SCNVector3Make(amount.x, scale.y, scale.z)
        }
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
                
                let frontGeometry = SCNPlane(width: CGFloat(initialSize.x), height: CGFloat(initialSize.y))
                let frontMaterial = sceneFileMaterial.copy() as! SCNMaterial
                frontMaterial.diffuse.contents = frontColor
                frontGeometry.materials = [frontMaterial]
                frontNode = SCNNode(geometry: frontGeometry)
                frontNode!.name = "frontNode"
                frontNode!.position = SCNVector3(0.0, 0.5, 0.5)
                self.addChildNode(frontNode!)
                
                let backGeometry = SCNPlane(width: CGFloat(initialSize.x), height: CGFloat(initialSize.y))
                let backMaterial = sceneFileMaterial.copy() as! SCNMaterial
                backMaterial.diffuse.contents = backColor
                backGeometry.materials = [backMaterial]
                backNode = SCNNode(geometry: backGeometry)
                backNode!.name = "backNode"
                backNode!.rotation = SCNVector4(0, 1, 0, -Float.pi)
                backNode!.position = SCNVector3(0.0, 0.5, -0.5)
                self.addChildNode(backNode!)
                
                let rightGeometry = SCNPlane(width: CGFloat(initialSize.z), height: CGFloat(initialSize.y))
                let rightMaterial = sceneFileMaterial.copy() as! SCNMaterial
                rightMaterial.diffuse.contents = rightColor
                rightGeometry.materials = [rightMaterial]
                rightNode = SCNNode(geometry: rightGeometry)
                rightNode!.name = "rightNode"
                rightNode!.rotation = SCNVector4(0, 1, 0, Float.pi/2)
                rightNode!.position = SCNVector3(0.5, 0.5, 0.0)
                self.addChildNode(rightNode!)
                
                let leftGeometry = SCNPlane(width: CGFloat(initialSize.z), height: CGFloat(initialSize.y))
                let leftMaterial = sceneFileMaterial.copy() as! SCNMaterial
                leftMaterial.diffuse.contents = leftColor
                leftGeometry.materials = [leftMaterial]
                leftNode = SCNNode(geometry: leftGeometry)
                leftNode!.name = "leftNode"
                leftNode!.rotation = SCNVector4(0, 1, 0, -Float.pi/2)
                leftNode!.position = SCNVector3(-0.5, 0.5, 0.0)
                self.addChildNode(leftNode!)
                
                let topGeometry = SCNPlane(width: CGFloat(initialSize.x), height: CGFloat(initialSize.z))
                let topMaterial = sceneFileMaterial.copy() as! SCNMaterial
                topMaterial.diffuse.contents = topColor
                topGeometry.materials = [topMaterial]
                topNode = SCNNode(geometry: topGeometry)
                topNode!.name = "topNode"
                topNode!.rotation = SCNVector4(1, 0, 0, -Float.pi/2)
                topNode!.position = SCNVector3(0, 1.0, 0.0)
                self.addChildNode(topNode!)
            }
        }
        wrapperNode.removeFromParentNode()
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
