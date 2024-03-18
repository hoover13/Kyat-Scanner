import SwiftUI
import ARKit
import AVFoundation

struct ARViewContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ARViewController {
        let viewController = ARViewController()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = ARViewController
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
    
//    var previousDetectedImageName: String?
//
//    func renderer(_ renderer: SCNSceneRenderer,didAdd node: SCNNode, for anchor: ARAnchor) -> SCNNode? {
//
//        let node = SCNNode()
//        
//        if let imageAnchor = anchor as? ARImageAnchor {
////            let imageSize = imageAnchor.referenceImage.physicalSize
//            print(imageAnchor.referenceImage)
//            
//            if let imageName = imageAnchor.referenceImage.name {
//                // Compare with the previously detected image
//                if imageName != previousDetectedImageName {
//                    // If they do not match, update the content
//                    previousDetectedImageName = imageName
//                    
//                    // Clear previous content
//                    node.childNodes.forEach { $0.removeFromParentNode() }
//                    
//                    // Add new content based on the detected image
//                    if imageName == "1000 Kyat Front" || imageName == "1000 Kyat Back" {
//                        readBill(billSound: "1000")
//                        print("1000 detected")
//                    } else if imageName == "5000 Kyat Front" || imageName == "5000 Kyat Back" {
//                        readBill(billSound: "5000")
//                        print("5000 detected")
//                    }
//                }
//            }
//        }
//        
//        return node
//    }
    
    var lastImageAnchor: ARAnchor!
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        var referenceImage = imageAnchor.referenceImage
        let imageName = referenceImage.name
    
        
       
        if self.lastImageAnchor != imageAnchor {
            if self.lastImageAnchor != nil{
                self.sceneView.session.remove(anchor: self.lastImageAnchor)
            }
            if imageName == "1000 Kyat Front" || imageName == "1000 Kyat Back" {
                self.lastImageAnchor = imageAnchor
                readBill(billSound: "1000")
                
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.lastImageAnchor = nil
            }
        }

        
        if self.lastImageAnchor != imageAnchor {
            if self.lastImageAnchor != nil{
                self.sceneView.session.remove(anchor: self.lastImageAnchor)
            }
            if imageName == "5000 Kyat Front" || imageName == "5000 Kyat Back" {
                self.lastImageAnchor = imageAnchor
                readBill(billSound: "5000")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.2){
                self.lastImageAnchor = nil
            }
        }
        
        
        //        print(referenceImage)
        //        self.sceneView.session.remove(anchor: self.lastImageAnchor)
        
//        if self.lastImageAnchor != nil && self.lastImageAnchor != imageAnchor {
//            self.sceneView.session.remove(anchor: self.lastImageAnchor)
//            self.lastImageAnchor = imageAnchor
//        }
//        print(lastImageAnchor ?? "error")
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

struct AugmentedRealityView: View {
    var body: some View {
        ARViewContainer()
    }
}

