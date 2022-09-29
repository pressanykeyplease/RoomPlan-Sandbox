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
        guard let wallsGroup = scene.rootNode.childNodes(passingTest: { node, _ in
            node.name!.hasPrefix("Walls_grp")
        }).first else {
            fatalError("Walls_grp not found")
        }
        let wallsGroupAngles = wallsGroup.eulerAngles
        let walls = scene.rootNode.childNodes { node, _ in
            node.name!.hasPrefix("Wall") && !node.name!.hasSuffix("_grp")
        }
        walls.forEach {
            let width = ($0.boundingBox.max.x - $0.boundingBox.min.x) * 15
            let wallView = UIView(frame: CGRect(x: 0, y: 0, width: Int(width), height: 3))
            wallView.backgroundColor = .black
            let positionX = $0.worldPosition.x * 15 + 120
            let positionY = $0.worldPosition.z * 15 + 120
            wallView.center = CGPoint(x: Int(positionX), y: Int(positionY))
            wallView.transform = CGAffineTransform(rotationAngle: getRotationAngle(groupAngle: wallsGroupAngles, nodeAngles: $0.eulerAngles, rootNode: scene.rootNode))
            
            
            view.addSubview(wallView)
        }
    }

    func getRotationAngle(groupAngle: SCNVector3, nodeAngles: SCNVector3, rootNode: SCNNode) -> CGFloat {
        var extraAngle: Float {
            nodeAngles.z == 0 ? 0 : .pi / 2
        }
        return CGFloat(-1 * groupAngle.y - nodeAngles.y + extraAngle)
    }
}
