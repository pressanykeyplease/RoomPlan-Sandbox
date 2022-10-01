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
    // MARK: - Public
    func configure(with url: URL) {
        // let url = Bundle.main.url(forResource: "room_4", withExtension: "usdz")!//  - example
        guard let scene = try? SCNScene(url: url) else {
            fatalError("Can't make scene")
        }
        guard let wallsGroup = scene.rootNode.childNodes(passingTest: { node, _ in
            node.name!.hasPrefix("Walls_grp")
        }).first else {
            fatalError("Walls_grp not found")
        }
        let walls = scene.rootNode.childNodes { node, _ in
            node.name!.hasPrefix("Wall") && !node.name!.hasSuffix("_grp")
        }
        let container = UIView(frame: CGRect(x: edgeSize, y: edgeSize, width: containerSize, height: containerSize))
        walls.forEach {
            placeWall(with: $0, wallsGroup: wallsGroup, on: container)
        }
        view.addSubview(container)
        container.center = view.center
        container.transform = CGAffineTransform(rotationAngle: CGFloat(walls.first!.eulerAngles.y - wallsGroup.eulerAngles.y))
    }

    // MARK: - Private constants
    private lazy var scaleFactor: Float = 20
    private lazy var viewOffset: Float = 0
    private lazy var wallDepth = 6
    private let edgePart: CGFloat = 0.2
    
    private lazy var containerSize = view.bounds.width * edgePart
    private lazy var edgeSize = view.bounds.width * (1 - edgePart) / 2
}

// MARK: - Private methods
private extension PlanViewerViewController {
    func placeWall(with node: SCNNode, wallsGroup: SCNNode, on view: UIView) {
        let width = (node.boundingBox.max.x - node.boundingBox.min.x) * scaleFactor
        let wallView = UIView(frame: CGRect(x: .zero, y: .zero, width: Int(width), height: wallDepth))
        wallView.backgroundColor = .black
        let positionX = node.worldPosition.x * scaleFactor + viewOffset
        let positionY = node.worldPosition.z * scaleFactor + viewOffset
        wallView.center = CGPoint(x: Int(positionX), y: Int(positionY))
        let angle = getRotationAngle(groupAngle: wallsGroup.eulerAngles, nodeAngles: node.eulerAngles)
        wallView.transform = CGAffineTransform(rotationAngle: angle)
        view.addSubview(wallView)
    }

    func getRotationAngle(groupAngle: SCNVector3, nodeAngles: SCNVector3) -> CGFloat {
        if nodeAngles.z == 0 {
            return CGFloat(-1 * groupAngle.y - nodeAngles.y)
        } else {
            var extraAngle: Float {
                if groupAngle.y == -0 {
                    return 0
                } else {
                    return .pi / 2
                }
            }
            return CGFloat(groupAngle.y + nodeAngles.y + extraAngle)
        }
    }
}
