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
            let positionX = $0.transform.m41 * 10
            let positionY = $0.transform.m43 * 10
            let width = $0.boundingBox.max.x * 10
            let depth = $0.boundingBox.max.y * 10
            let angle = $0.eulerAngles.y
            let wallView = UIView(frame: CGRect(x: Int(positionX) + 100, y: Int(positionY) + 100, width: Int(width), height: Int(depth)))
            wallView.backgroundColor = .red
            wallView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            view.addSubview(wallView)
            
            
            
            
            print($0.name!, positionX, positionY, width, depth, angle)
        }
    }
}
