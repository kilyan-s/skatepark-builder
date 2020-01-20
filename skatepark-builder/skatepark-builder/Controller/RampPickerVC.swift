//
//  RampPickerVC.swift
//  skatepark-builder
//
//  Created by Kilyan SOCKALINGUM on 20/01/2020.
//  Copyright © 2020 Kilyan SOCKALINGUM. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {
    var sceneView: SCNView!
    var size: CGSize!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        preferredContentSize = size
        
        //Create the scene to add all 3D models
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        //Create a custom camera to remove depth, only x,y axis
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let rotate = SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(0.05 * Double.pi), around: SCNVector3(0, 1, 0), duration: 0.1))
        
        //Create pipe 3D object
        let pipeScene = SCNScene(named: "art.scnassets/pipe.dae")
        //Get the pipe object in pipeScene file
        let pipeNode = pipeScene?.rootNode.childNode(withName: "pipe", recursively: true)
        //Change the scale and position to fit in popover VC
        pipeNode?.scale = SCNVector3Make(0.0020, 0.0020, 0.0020)
        pipeNode?.position = SCNVector3Make(0.1, 0.7, 0)
        //Start rotation of the object
        pipeNode?.runAction(rotate)
        
        //Create pyramid 3D object
        let pyramidScene = SCNScene(named: "art.scnassets/pyramid.dae")
        let pyramidNode = pyramidScene?.rootNode.childNode(withName: "pyramid", recursively: true)
        pyramidNode?.scale = SCNVector3Make(0.0050, 0.0050, 0.0050)
        pyramidNode?.position = SCNVector3Make(0.1, -0.2, 0)
        pyramidNode?.runAction(rotate)
        
        //Create quarter 3D Object
        let quarterScene = SCNScene(named: "art.scnassets/quarter.dae")
        let quarterNode = quarterScene?.rootNode.childNode(withName: "quarter", recursively: true)
        quarterNode?.scale = SCNVector3Make(0.0045, 0.0045, 0.0045)
        quarterNode?.position = SCNVector3Make(0.1, -1.5, 0)
        quarterNode?.runAction(rotate)
        
        //Add objects to the main scene
        scene.rootNode.addChildNode(pipeNode!)
        scene.rootNode.addChildNode(pyramidNode!)
        scene.rootNode.addChildNode(quarterNode!)
        
    }
    
}
