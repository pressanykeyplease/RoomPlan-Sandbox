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
        guard let wallsGroup = scene.rootNode.childNodes { node, _ in
            node.name!.hasPrefix("Walls_grp")
        }.first else {
            fatalError("Walls_grp not found")
        }
        let wallsGroupAngles = wallsGroup.eulerAngles
        var walls = scene.rootNode.childNodes { node, _ in
            node.name!.hasPrefix("Wall") && !node.name!.hasSuffix("_grp")
        }
        // walls.removeLast(5)
        walls.forEach {
            let width = ($0.boundingBox.max.x - $0.boundingBox.min.x) * 15
            let wallView = UIView(frame: CGRect(x: 0, y: 0, width: Int(width), height: 3))
            wallView.backgroundColor = .black
            let positionX = $0.worldPosition.x * 15 + 120
            let positionY = $0.worldPosition.z * 15 + 120
            wallView.center = CGPoint(x: Int(positionX), y: Int(positionY))
            wallView.transform = CGAffineTransform(rotationAngle: getRotationAngle(groupAngle: wallsGroupAngles, node: $0, rootNode: scene.rootNode))
            
            
            view.addSubview(wallView)
        }
    }

    func getRotationAngle(groupAngle: SCNVector3, node: SCNNode, rootNode: SCNNode) -> CGFloat {
        let nodeAngle = node.eulerAngles.y
        print(node.eulerAngles.x, node.eulerAngles.z)
        return CGFloat(-1 * groupAngle.y - nodeAngle)
    }
}

extension Int {
    func toRadians() -> CGFloat {
        CGFloat(self) * CGFloat.pi / 180
    }
}

extension Float {
    func toDegrees() -> Int {
        Int(CGFloat(self) * 180 / CGFloat.pi)
    }
}
