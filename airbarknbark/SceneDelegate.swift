//
//  SceneDelegate.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 06/09/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = UINavigationController(rootViewController: SplashScreenViewController())

        window.backgroundColor = .background
        window.makeKeyAndVisible()
                
        self.window = window
    }
    
    public func performSignOutCleanUp(){
        SessionManager.shared.clearSession()
        window?.rootViewController = UINavigationController(rootViewController: SplashScreenViewController())
    }

}

