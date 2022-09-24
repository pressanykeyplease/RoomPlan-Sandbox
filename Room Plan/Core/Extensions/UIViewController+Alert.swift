//
//  UIViewController+Alert.swift
//  Room Plan
//
//  Created by Eduard on 24.09.2022.
//

import UIKit

extension UIViewController {
    func alert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
