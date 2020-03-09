//
//  UIViewController+Navigation.swift
//  Firebase-Project
//
//  Created by Lilia Yudina on 3/6/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private static func resetWindow(with rootViewController: UIViewController) {
        guard  let scene = UIApplication.shared.connectedScenes.first,
            let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window else {
                fatalError("could not reset window rootViewController")
        }
        window.rootViewController = rootViewController
    }
    
    public static func showViewController(storyboardName: String, viewControllerId: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: viewControllerId)
        resetWindow(with: newVC)
    }
    
}
