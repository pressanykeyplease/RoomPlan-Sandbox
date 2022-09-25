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
        let walls = scene.rootNode.childNodes { node, _ in
            node.name!.hasPrefix("Wall") && !node.name!.hasSuffix("_grp")
        }
        walls.forEach {
            let angle = $0.eulerAngles.y
            let wallView = UIView(frame: makeFrame(for: $0))
            wallView.backgroundColor = .red
            wallView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            view.addSubview(wallView)
        }
    }

    func makeFrame(for node: SCNNode) -> CGRect {
        let positionX = node.worldPosition.x * 10
        let positionY = node.worldPosition.z * 10
        let width = node.boundingBox.max.x * 10
        let depth = 1
        print(node.name!, width, depth)
        return CGRect(x: Int(positionX) + 100, y: Int(positionY) + 100, width: Int(width), height: depth)
    }
}
