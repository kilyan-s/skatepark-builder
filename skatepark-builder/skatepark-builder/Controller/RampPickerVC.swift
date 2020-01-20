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
    weak var rampPlacerVC: RampPlacerVC!
    
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
        
        //Add tap gesture recognizer to handle 3D model selection
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        tapGesture.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGesture)
        
        //Create the scene to add all 3D models
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        //Create a custom camera to remove depth, only x,y axis
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        
        //Create pipe 3D object
        let pipeNode = Ramp.getPipe()
        Ramp.startRotation(node: pipeNode)
        
        //Create pyramid 3D object
        let pyramidNode = Ramp.getPyramid()
        Ramp.startRotation(node: pyramidNode)
        
        //Create quarter 3D Object
        let quarterNode = Ramp.getQuarter()
        Ramp.startRotation(node: quarterNode)
        
        //Add objects to the main scene
        scene.rootNode.addChildNode(pipeNode)
        scene.rootNode.addChildNode(pyramidNode)
        scene.rootNode.addChildNode(quarterNode)
        
    }
    
    @objc func tapHandler(_ gesture: UIGestureRecognizer) {
        //Save point coordinates where user has click on sceneView
        let p = gesture.location(in: sceneView)
        //Check if there is an object at these coordinates
        let hitResults = sceneView.hitTest(p, options: [:])
        
        if hitResults.count > 0 {
            let node = hitResults[0].node
            
            rampPlacerVC.rampWasSelected(rampName: node.name!)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
