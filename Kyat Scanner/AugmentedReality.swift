//
//  AugmentedReality.swift
//  Kyat Scanner
//
//  Created by Min Thu Khine on 3/15/24.
//

import SwiftUI
import ARKit
import AVFoundation

struct ARViewContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = ARViewController()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        typealias UIViewControllerType = ARViewController
    }
}


class ARViewController: UIViewController, ARSCNViewDelegate {
    var audioPlayer: AVAudioPlayer?
    var sceneView: ARSCNView!
    
    override func loadView() {
        sceneView = ARSCNView(frame: .zero)
        self.view = sceneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let configuration = ARWorldTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Money List", bundle: Bundle.main) {
            configuration.detectionImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
            print("Image Scanned Successfully")
            
        }
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            if imageAnchor.referenceImage.name == "1000 Kyat Front" || imageAnchor.referenceImage.name == "1000 Kyat Back" {
                readBill(billSound: "1000")
                print("5000 detected")
            }
            
            if imageAnchor.referenceImage.name == "5000 Kyat Front" || imageAnchor.referenceImage.name == "5000 Kyat Back" {
                readBill(billSound: "5000")
                print("5000 detected")
            }
        }
        
        return node
    }
    
    func readBill(billSound: String) {
        if let soundURL = Bundle.main.url(forResource: billSound, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
}

enum Bill {
    
    case oneThousand, fiveThousand
    
    var billSound: String {
        switch self {
        case .oneThousand:
            "1000"
        case .fiveThousand:
            "5000"
        }
    }
}

struct AugmentedRealityView: View {
    var body: some View {
        ARViewContainer()
    }
}


