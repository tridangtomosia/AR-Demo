//
//  ARContainerView.swift
//  AR-RealityKit-Demo
//
//  Created by Tri Dang on 11/05/2021.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelSelected: String?
    @Binding var color: UIColor?
    @Binding var isChangedWall: Bool?
    @Binding var ischanged: Bool?
    @Binding var isChangeObject: Bool?
    @Binding var isSavePhoto: Bool?
    @Binding var image: UIImage?

    func makeUIView(context: Context) -> ARView {
        let arView = CustomeARView(frame: .zero) // ARView(frame: .zero)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if isSavePhoto == true {
            uiView.snapshot(saveToHDR: false) { image in
                DispatchQueue.main.async {
                    self.image = image
                    isSavePhoto = false
                }
            }
            return
        }

        if isChangedWall == false, ischanged == false {
            uiView.scene.anchors.remove(at: uiView.scene.anchors.count - 1)
            DispatchQueue.main.async {
                ischanged = nil
                modelSelected = nil
            }
            return
        }

        if isChangedWall == false, ischanged == true {
            DispatchQueue.main.async {
                modelSelected = nil
                color = nil
                ischanged = nil
            }

            if isChangeObject != true {
                return
            }
        }

        if isChangedWall == true, color != nil {
            if uiView.scene.anchors.count - 1 > 1 {
                uiView.scene.anchors.remove(at: uiView.scene.anchors.count - 1)
            }
        }

        if let modelName = modelSelected {
            if modelName == "wall" {
                changeColor(in: uiView, color: color ?? .white, type: .wall)
                return
            }

            if modelName == "background" {
                changeColor(in: uiView, color: color ?? .white, type: .background)
                return
            }

            let fileName = modelName + ".usdz"
            let modelEntity = try! ModelEntity.loadModel(named: fileName)
            modelEntity.generateCollisionShapes(recursive: true)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            uiView.installGestures([.scale, .rotation, .translation],
                                   for: modelEntity)
            uiView.scene.addAnchor(anchorEntity)
            DispatchQueue.main.async {
                isChangeObject = false
                modelSelected = nil
            }
        }
    }

    func updateBackground(in arView: ARView, dimentions: SIMD3<Float> = [0, 0, 0], color: UIColor = .white) -> AnchorEntity {
        let dimentions: SIMD3<Float> = [1.23, 0.0001, 0.7]
        let backgroundMesh = MeshResource.generateBox(size: dimentions)
        let backgroundMaterial = SimpleMaterial(color: color, isMetallic: false)
        let backgroundEntity = ModelEntity(mesh: backgroundMesh, materials: [backgroundMaterial])
        backgroundEntity.generateCollisionShapes(recursive: true)
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(backgroundEntity)
//        arView.scene.addAnchor(anchor)
        arView.installGestures([.scale, .rotation, .translation],
                               for: backgroundEntity)
        return anchor
    }

    func updateWall(in arView: ARView, dimentions: SIMD3<Float> = [0, 0, 0], color: UIColor = .white) -> AnchorEntity {
        let dimentions: SIMD3<Float> = [1.23, 0.0001, 0.7]
        let wallMesh = MeshResource.generateBox(size: dimentions)
        let wallMaterial = SimpleMaterial(color: color, isMetallic: false)

        let wallEntity = ModelEntity(mesh: wallMesh, materials: [wallMaterial])
        wallEntity.generateCollisionShapes(recursive: true)
        let anchor = AnchorEntity(plane: .vertical)
        anchor.addChild(wallEntity)
        arView.installGestures([.scale, .rotation, .translation],
                               for: wallEntity)
        return anchor
    }

    func changeColor(in arView: ARView, color: UIColor, type: TypeWork) {
        switch type {
        case .wall:
            arView.scene.anchors.append(updateWall(in: arView, color: color))
        case .background:
            arView.scene.anchors.append(updateBackground(in: arView, color: color))
        }
    }

    enum TypeWork {
        case wall
        case background
    }
}
