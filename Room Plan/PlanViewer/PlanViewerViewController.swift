//
//  PlanViewerViewController.swift
//  Room Plan
//
//  Created by Eduard on 24.09.2022.
//

import SceneKit
import UIKit

// MARK: - PlanViewerViewController
class PlanViewerViewController: UIViewController {
    func configure(with url: URL) {
        let url = Bundle.main.url(forResource: "room_1", withExtension: "usdz")! // delete that
        guard let scene = try? SCNScene(url: url) else {
            fatalError("Can't make scene")
        }
        var walls = scene.rootNode.childNodes { node, _ in
            node.name!.hasPrefix("Wall") && !node.name!.hasSuffix("_grp")
        }
        walls.forEach {
            let wallView = UIView(frame: makeFrame(for: $0))
            wallView.backgroundColor = .red
            let positionX = $0.worldPosition.x * 10 + 100
            let positionY = $0.worldPosition.z * 10 + 100
            wallView.center = CGPoint(x: Int(positionX), y: Int(positionY))
            // wallView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            view.addSubview(wallView)
        }
    }

    func makeFrame(for node: SCNNode) -> CGRect {
        let width = node.boundingBox.max.x * 10
        return CGRect(x: 0, y: 0, width: Int(width), height: 1)
    }
}
