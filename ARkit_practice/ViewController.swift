import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
   @IBOutlet var sceneView: ARSCNView!

     override func viewDidLoad() {
       super.viewDidLoad()

       sceneView.delegate = self
       sceneView.scene = SCNScene()
   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

       let configuration = ARWorldTrackingConfiguration()
       sceneView.session.run(configuration)

       let gesture = UITapGestureRecognizer(target: self, action:#selector(onTap))
       self.sceneView.addGestureRecognizer(gesture)
   }

    @objc func onTap(sender: UITapGestureRecognizer) {

        let pos = sender.location(in: sceneView)
        let results = sceneView.hitTest(pos, types: .featurePoint)
        if !results.isEmpty {
            let anchor = ARAnchor(name:"shipAnchor",
                                  transform:results.first!.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }


   // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor.name == "shipAnchor" {
            guard let scene = SCNScene(named: "ship.scn",inDirectory: "art.scnassets") else { return }
            let shipNode = (scene.rootNode.childNode(withName: "ship", recursively: false))!
               node.addChildNode(shipNode)
        }
   }

}
