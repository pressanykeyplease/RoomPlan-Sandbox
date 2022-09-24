//
//  PlanViewerViewController.swift
//  Room Plan
//
//  Created by Eduard on 24.09.2022.
//

import RoomPlan
import UIKit

// MARK: - PlanViewerViewController
class PlanViewerViewController: UIViewController {
    func configure(with room: CapturedRoom?) {
        guard let room = room else {
            alert(title: "Invalid room model", message: "Please try again")
            return
        }
    }
}
