//
//  SceneDelegate.swift
//  ClickTow
//
//  Created by M Hayat on 07/02/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        
        Helper.userId = UserDefaults.standard.string(forKey: "id") ?? ""
        print(Helper.userId,"id")
        let userType = UserDefaults.standard.string(forKey:"userType")
        print(userType as Any,"userType")
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true {
            
            if UserDefaults.standard.string(forKey: "status") == "0"{
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninNavigation") as? UIViewController else {
                    fatalError("Could not instantiate HomeVC!")
                }
                window.rootViewController = vc
            }else{
                if UserDefaults.standard.string(forKey: "userType") == "user"{
                    //MARK: - if not logged in with user
                    if UserDefaults.standard.string(forKey: "status") == "0"{
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninNavigation") as? UIViewController  else {
                            fatalError("Could not instantiate HomeVC!")
                        }
                        
                        window.rootViewController = vc
                    }else if UserDefaults.standard.string(forKey: "status") == "1"{
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileNavigation") as? UIViewController else {
                            fatalError("Could not instantiate HomeVC!")
                        }
                        window.rootViewController = vc
                    }else if UserDefaults.standard.string(forKey: "status") == "2"{
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserTabBar") as? UIViewController else {
                            fatalError("Could not instantiate HomeVC!")
                        }
                        window.rootViewController = vc
                    }
                } else {
                    if UserDefaults.standard.string(forKey: "status") == "0"{
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninNavigation") as? UIViewController else {
                            fatalError("Could not instantiate HomeVC!")
                        }
                        window.rootViewController = vc
                    } else if UserDefaults.standard.string(forKey: "status") == "1"{
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileNavigation") as? UIViewController else {
                            fatalError("Could not instantiate HomeVC!")
                        }
                        window.rootViewController = vc
                    } else if UserDefaults.standard.string(forKey: "status") == "3"{
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddProDetailsNavi") as? UIViewController else {
                            fatalError("Could not instantiate HomeVC!")
                        }
                        window.rootViewController = vc
                    }else if UserDefaults.standard.string(forKey: "status") == "4"{
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddVehicleNavigation") as? UIViewController else {
                            fatalError("Could not instantiate HomeVC!")
                        }
                        window.rootViewController = vc
                    }else {
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverTabBar") as? UIViewController else {
                            fatalError("Could not instantiate HomeVC!")
                        }
                        window.rootViewController = vc
                    }
                }
            }
        } else {
            //MARK: - if not logged in
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninNavigation") as? UIViewController else {
                fatalError("Could not instantiate HomeVC!")
            }
            window.rootViewController = vc
        }
                
        self.window = window
        window.makeKeyAndVisible()
        guard let _ = (scene as? UIWindowScene) else { return }
        
            
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

