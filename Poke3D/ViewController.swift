//
//  ViewController.swift
//  Poke3D
//
//  Created by Amerigo Mancino on 22/09/2019.
//  Copyright © 2019 Amerigo Mancino. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Enable lighting
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // Tell the app about the images it should track
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = imagesToTrack
            
            // which is the maximum number of images to track?
            configuration.maximumNumberOfTrackedImages = 2
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNVIEW DELEGATE SECTION
    
    // the anchor is the thing that was detected (in our case would be the image that was detected)
    // and the returning node is a 3D object that will be provided in response to detecting the anchor
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        DispatchQueue.main.async {
            // if the anchor that was detected was a image anchor...
            if let imageAnchor = anchor as? ARImageAnchor {
                
                
                
                // create a plane for the detected card and a node for it
                let plane = SCNPlane(
                    width: imageAnchor.referenceImage.physicalSize.width,
                    height: imageAnchor.referenceImage.physicalSize.height
                )
                
                // the object plane is transparent
                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
                
                let planeNode = SCNNode()
                planeNode.geometry = plane
                
                // planes are vertical by default: we have to rotate it by 90 degrees
                planeNode.eulerAngles.x = -Float.pi/2
                
                node.addChildNode(planeNode)
                
                // if the card detected is the one called eevee-card...
                if imageAnchor.referenceImage.name == "eevee-card" {
                    // create the pokemon on top of the plane
                    if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn") {
                        if let pokeNode = pokeScene.rootNode.childNodes.first {
                            pokeNode.eulerAngles.x = Float.pi/2
                            planeNode.addChildNode(pokeNode)
                        }
                    }
                }
                
            }
            
        }
        
        return node
    }
    
}
