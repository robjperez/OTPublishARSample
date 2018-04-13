//
//  ViewController.swift
//  OTPublishARSample
//
//  Created by Roberto Perez Cubero on 13/04/2018.
//  Copyright © 2018 tokbox. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import OpenTok

let kApiKey = ""
let kToken = ""
let kSessionId = ""

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
        
    var sessionDelegate: ViewControllerSessionDelegate?
    var otSession: OTSession?
    var otPublisher: OTPublisher?
    var scnViewCapturer: SCNViewVideoCapture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene                  
        
        sessionDelegate = ViewControllerSessionDelegate(self)
        otSession = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: sessionDelegate)
        scnViewCapturer = SCNViewVideoCapture(sceneView: sceneView)
    }        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        otSession?.connect(withToken: kToken, error: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func sessionConnected() {
        let pubSettings = OTPublisherSettings()
        pubSettings.videoCapture = scnViewCapturer
        otPublisher = OTPublisher(delegate: self, settings: pubSettings)
        otSession!.publish(otPublisher!, error: nil)
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
}

extension ViewController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher error: \(error)")
    }
}

class ViewControllerSessionDelegate : NSObject, OTSessionDelegate {
    let parent: ViewController
    
    init(_ parent: ViewController) {
        self.parent = parent
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("Session Fail")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Stream Created")
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Stream Destroyed")
    }
    
    func sessionDidConnect(_ session: OTSession) {
        print("SessionConnected")
        parent.sessionConnected()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Disconnect")
    }
}
