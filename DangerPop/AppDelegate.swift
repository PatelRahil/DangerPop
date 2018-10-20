//
//  AppDelegate.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/19/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.disconnect()
        configureAPIs()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as?String,annotation: [:])
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("Delegate google signing in error: \n\(error)")
            return
        }
        
        /*
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: { (result, error) in
            if let error = error {
                print(error)
            } else {
                print("Successfully signed in")
                self.loadUser()
                UserData.name = user.profile.name
                print("UID: " + FIRAuth.auth()!.currentUser!.uid)
            }
            
        })
         */
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        if let error = error {
            print("Delegate google signing out error: \n\(error)")
        }
    }
    
    // convenience function
    private func loadUser() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            let ref = FIRDatabase.database().reference(withPath: "Users/\(uid)")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    UserData.uid = uid
                    UserData.update(with: snapshot)
                } else {
                    //self.presentAlert(alert: "This account doesn't exist", message: "Please contact support at support@savetheirsouls.org")
                }
            }
        }
    }
    
    private func configureAPIs() {
        let url = Bundle.main.url(forResource: "keys", withExtension: "json")
        var data = Data()
        var keys = [String:String]()
        do { data = try Data(contentsOf: url!) }
        catch let error { print("File Error: \(error)") }
        do { keys = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]}
        catch let error { print("JSON Error: \(error)") }
        
        let googleAPIKey = keys["google"]!
        
        GMSServices.provideAPIKey(googleAPIKey)
    }
}

