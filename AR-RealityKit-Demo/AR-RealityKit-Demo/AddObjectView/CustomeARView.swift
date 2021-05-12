//
//  CustomeARView.swift
//  AR-RealityKit-Demo
//
//  Created by Tri Dang on 11/05/2021.
//

import RealityKit
import ARKit
import FocusEntity

class CustomeARView: ARView {
    var focusSquare = FESquare()
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        focusSquare.viewDelegate = self
        focusSquare.setAutoUpdate(to: true)
    }

    @objc dynamic required init? (coder decoder: NSCoder) {
        fatalError("EROOOROROROROROR")
    }

    func setupAR() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        session.run(config)
    }
}
