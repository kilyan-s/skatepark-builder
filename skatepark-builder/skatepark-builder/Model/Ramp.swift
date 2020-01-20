//
//  Ramp.swift
//  skatepark-builder
//
//  Created by Kilyan SOCKALINGUM on 20/01/2020.
//  Copyright © 2020 Kilyan SOCKALINGUM. All rights reserved.
//

import Foundation
import SceneKit

class Ramp {
    
    class func getRamp(forName name: String) -> SCNNode {
        switch name {
        case "pipe":
            return Ramp.getPipe()
        case "pyramid":
            return Ramp.getPyramid()
        case "quarter":
            return Ramp.getQuarter()
        default:
            return Ramp.getPipe()
        }
    }
    
    class func getPipe() -> SCNNode {
        //Create pipe 3D object
        let pipeScene = SCNScene(named: "art.scnassets/pipe.dae")
        //Get the pipe object in pipeScene file
        let pipeNode = pipeScene?.rootNode.childNode(withName: "pipe", recursively: true)
        //Change the scale and position to fit in popover VC
        pipeNode?.scale = SCNVector3Make(0.0020, 0.0020, 0.0020)
        pipeNode?.position = SCNVector3Make(0.1, 0.7, 0)
        
        return pipeNode!
    }
    
    class func getPyramid() -> SCNNode {
        let pyramidScene = SCNScene(named: "art.scnassets/pyramid.dae")
        let pyramidNode = pyramidScene?.rootNode.childNode(withName: "pyramid", recursively: true)
        pyramidNode?.scale = SCNVector3Make(0.0050, 0.0050, 0.0050)
        pyramidNode?.position = SCNVector3Make(0.1, -0.2, 0)
        
        return pyramidNode!
    }
    
    class func getQuarter() -> SCNNode {
        let quarterScene = SCNScene(named: "art.scnassets/quarter.dae")
        let quarterNode = quarterScene?.rootNode.childNode(withName: "quarter", recursively: true)
        quarterNode?.scale = SCNVector3Make(0.0045, 0.0045, 0.0045)
        quarterNode?.position = SCNVector3Make(0.1, -1.5, 0)
        
        return quarterNode!
    }
    
    class func startRotation(node: SCNNode) {
        let rotate = SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(0.05 * Double.pi), around: SCNVector3(0, 1, 0), duration: 0.1))
        
        node.runAction(rotate)
    }
}
