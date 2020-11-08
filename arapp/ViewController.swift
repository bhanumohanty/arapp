//
//  ViewController.swift
//  arapp
//
//  Created by Bhanu Mohanty on 10/17/20.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
    }
    
    @IBAction func addModel(_ sender: Any) {
        
//        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node,_) in
            node.removeFromParentNode()
        }
//        self.sceneView.session.run(configuration)
        
//        let cubNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
//        let cc = getCameraCoordinate(sceneView: sceneView)
//        cubNode.position = SCNVector3(cc.x,cc.y,cc.z)
//        sceneView.scene.rootNode.addChildNode(cubNode)
        let modelNode = SCNNode()
        
        guard let virtualObjectScene = SCNScene(named: "vase.scn", inDirectory: "Models.scnassets/vase") else {
            return
        }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        modelNode.addChildNode(wrapperNode)
        let cc = getCameraCoordinate(sceneView: sceneView)
        modelNode.position = SCNVector3(cc.x,cc.y,cc.z)
        sceneView.scene.rootNode.addChildNode(modelNode)
    }
    struct myCameraCoordinates {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    func getCameraCoordinate(sceneView: ARSCNView) -> myCameraCoordinates{
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z - 0.1
        return cc
    }
}

