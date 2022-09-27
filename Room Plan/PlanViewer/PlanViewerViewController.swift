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
        let wallsGroupAngle = wallsGroup.eulerAngles.y
        var walls = scene.rootNode.childNodes { node, _ in
            node.name!.hasPrefix("Wall") && !node.name!.hasSuffix("_grp")
        }
        walls.forEach {
            let width = ($0.boundingBox.max.x - $0.boundingBox.min.x) * 10
            let wallView = UIView(frame: CGRect(x: 0, y: 0, width: Int(width), height: 1))
            wallView.backgroundColor = .black
            let positionX = $0.worldPosition.x * 10 + 100
            let positionY = $0.worldPosition.z * 10 + 100
            wallView.center = CGPoint(x: Int(positionX), y: Int(positionY))
            wallView.transform = CGAffineTransform(rotationAngle: getRotationAngle(groupAngle: wallsGroupAngle, node: $0))
            view.addSubview(wallView)
        }
    }

    func getRotationAngle(groupAngle: Float, node: SCNNode) -> CGFloat {
        return CGFloat(-1 * groupAngle - node.eulerAngles.y)
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
