//
//  ScanUIkitView.swift
//  AR-RealityKit-Demo
//
//  Created by Tri Dang on 11/05/2021.
//

import ARKit
import RealityKit
import SwiftUI

struct ScandDetectView: View {
    @State var name: String = ""
    var body: some View {
        ZStack(alignment: .top) {
            ARObjectDetectView(nameOPbject: $name)
        }
    }
}

struct ARObjectDetectView: UIViewRepresentable {
    @Binding var nameOPbject: String
    func makeUIView(context: Context) -> some ARSCNView {
        let arview = ARSCNView(frame: .zero)
        arview.delegate = context.coordinator
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        if let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "session",
                                                                     bundle: Bundle.main) {
            config.detectionObjects = referenceObjects
        }
        arview.session.run(config)
        return arview
    }

    func createObjectLabel() -> AnchorEntity {
        let dimentions: SIMD3<Float> = [0.5, 0.01, 0.5]
        let meshResource = MeshResource.generateBox(size: dimentions)
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let anchorEntity = ModelEntity(mesh: meshResource, materials: [material])
        let anchor = AnchorEntity(plane: .vertical)
        anchor.addChild(anchorEntity)
        return anchor
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }

    func makeCoordinator() -> ARSCNViewDelegate {
        return ARObjectDetectViewCodinator(self)
    }

    class ARObjectDetectViewCodinator: NSObject, ARSessionDelegate, ARSCNViewDelegate {
        var view: ARObjectDetectView
        init(_ view: ARObjectDetectView) {
            self.view = view
        }
        
        private func addObject( node: SCNNode, object: ARObjectAnchor, nameObject: String) {
            let plane = SCNPlane(width: CGFloat(object.referenceObject.extent.x * 0.8), height: CGFloat(object.referenceObject.extent.y * 0.5))
            plane.cornerRadius = plane.width / 8
            let spiteSceneKit = SKScene(fileNamed: nameObject)
            plane.firstMaterial?.diffuse.contents = spiteSceneKit
            plane.firstMaterial?.isDoubleSided = true
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make( object.referenceObject.center.x, object.referenceObject.center.y + 0.15 , object.referenceObject.center.z)
            planeNode.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
            node.addChildNode(planeNode)
        }
        
        enum NameObject: String {
            case lothuoc = "LoThuoc"
            case muoi = "Muoi"
            case xittoc = "XitToc"
            case macbook = "Macbook"
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if let object = anchor as? ARObjectAnchor {
                guard let name = object.name else {return}
                view.nameOPbject = name
                if let nameObject = NameObject.init(rawValue: name) {
                    addObject(node: node, object: object, nameObject: nameObject.rawValue)
                }
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            if let object = anchor as? ARObjectAnchor {
                guard let name = object.name else {return}
                print(name)
            }
        }
    }
}
