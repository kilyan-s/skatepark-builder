//
//  RampPlacerVC.swift
//  skatepark-builder
//
//  Created by Kilyan SOCKALINGUM on 20/01/2020.
//  Copyright © 2020 Kilyan SOCKALINGUM. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controls: UIStackView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var moveUpBtn: UIButton!
    @IBOutlet weak var moveDownBtn: UIButton!
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        // Set the scene to the view
        sceneView.scene = scene
        
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        
        rotateBtn.addGestureRecognizer(gesture1)
        moveUpBtn.addGestureRecognizer(gesture2)
        moveDownBtn.addGestureRecognizer(gesture3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    //to prevent VC to display fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return  }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        
        guard let hit = results.last else { return }
        let hitTransform = SCNMatrix4(hit.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43 )
        placeRamp(position: hitPosition)
    }
    
    func rampWasSelected(rampName: String) {
        selectedRampName = rampName
    }
    
    func placeRamp(position: SCNVector3) {
        guard let selectedRampName = selectedRampName else { return }
        let ramp = Ramp.getRamp(forName: selectedRampName)
        selectedRamp = ramp
        ramp.position = position
        ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(ramp)
        controls.isHidden = false
    }
    
     @objc func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let ramp = selectedRamp else { return }
        if gesture.state == .ended {
            ramp.removeAllActions()
        } else if gesture.state == .began {
            var action: SCNAction
            
            switch gesture.view {
                case rotateBtn:
                    action = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                case moveUpBtn:
                    action = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                case moveDownBtn:
                    action = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                default:
                    action = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
            }
            ramp.runAction(action)
        }
    }
    
    @IBAction func rampBtnWasPressed(_ sender: UIButton) {
        let rampPickerVC = RampPickerVC(size: CGSize(width: 250, height: 500))
        rampPickerVC.rampPlacerVC = self
        
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.popoverPresentationController?.delegate = self
        
        present(rampPickerVC, animated: true, completion: nil)
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    @IBAction func removeBtnWasPressed(_ sender: Any) {
        guard let ramp = selectedRamp else { return }
        ramp.removeFromParentNode()
        selectedRamp = nil
    }
    
    
}
