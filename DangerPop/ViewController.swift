//
//  ViewController.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/19/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    let emailFld = UITextField()
    let passFld = UITextField()
    let loginBtn = UIButton()
    let separator = UIView()
    let googleBtn = GIDSignInButton()
    let createAccountBtn = UIButton()
    let imgView = UIImageView(image: UIImage(named: "dangerpop"))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    
    // Convenience functions
    private func setupUI() {
        let viewSize = view.frame.size
        let underline = CALayer()
        let underline2 = CALayer()
        let width = CGFloat(2.0)
        let edgeInset:CGFloat = 1.0/12

        view.backgroundColor = Colors.black
        
        
        emailFld.frame = CGRect(origin: CGPoint(x: viewSize.width * edgeInset, y: viewSize.height / 4), size: CGSize(width: (viewSize.width - (2 * edgeInset) * viewSize.width), height: 25))
        emailFld.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailFld.textColor = UIColor.white
        emailFld.textAlignment = .center
        emailFld.tag = 0;
        
        imgView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: emailFld.frame.minY)

        
        passFld.frame = CGRect(origin: CGPoint(x: emailFld.frame.minX, y: emailFld.frame.maxY + 40), size: CGSize(width: emailFld.frame.size.width, height: 25))
        passFld.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passFld.isSecureTextEntry = true
        passFld.textColor = UIColor.white
        passFld.textAlignment = .center
        passFld.tag = 1
        
        // textfield underline
        underline.borderColor = Colors.orange.cgColor
        underline.frame = CGRect(x: 0, y: emailFld.frame.size.height - width, width: emailFld.frame.size.width, height: emailFld.frame.size.height)
        underline.borderWidth = width
        emailFld.layer.addSublayer(underline)
        emailFld.layer.masksToBounds = true
        
        underline2.borderColor = Colors.orange.cgColor
        underline2.frame = CGRect(x: 0, y: passFld.frame.size.height - width, width: passFld.frame.size.width, height: passFld.frame.size.height)
        underline2.borderWidth = width
        passFld.layer.addSublayer(underline2)
        passFld.layer.masksToBounds = true
        
        loginBtn.frame = CGRect(origin: CGPoint(x: passFld.frame.minX, y: passFld.frame.maxY + 40), size: CGSize(width: passFld.frame.size.width, height: 40))
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.backgroundColor = Colors.orange
        loginBtn.layer.cornerRadius = 4
        loginBtn.addTarget(self, action: #selector(loginPressed(sender:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(darkenButton(sender:)), for: .touchDown)
        
        //separator.borderColor = Colors.orange.cgColor
        separator.backgroundColor = Colors.orange
        separator.frame = CGRect(x: viewSize.width * edgeInset * 0.5, y: loginBtn.frame.maxY + 20, width: (viewSize.width - (edgeInset) * viewSize.width), height: 1)
        
        let btnWidth = CGFloat(170)
        googleBtn.frame = CGRect(x: (viewSize.width - btnWidth) / 2, y: separator.frame.maxY + 20, width: btnWidth, height: 40)
        //googleBtn.setImage(UIImage(named: "SignInWithGoogle"), for: .normal)
        /*
        if let imgView = googleBtn.imageView {
            imgView.layer.cornerRadius = 4
        }
 */
        //googleBtn.subviews.first?.contentMode = .scaleAspectFit
        googleBtn.backgroundColor = UIColor.white
        googleBtn.layer.cornerRadius = 4
        googleBtn.addTarget(self, action: #selector(googleSignInPressed(sender:)), for: .touchUpInside)
        googleBtn.addTarget(self, action: #selector(darkenButton(sender:)), for: .touchDown)
        
        createAccountBtn.frame = CGRect(x: (viewSize.width - btnWidth) / 2, y: googleBtn.frame.maxY + 20, width: btnWidth, height: 40)
        createAccountBtn.backgroundColor = Colors.orange
        createAccountBtn.setTitle("Create an account", for: .normal)
        createAccountBtn.setTitleColor(.white, for: .normal)
        createAccountBtn.layer.cornerRadius = 4
        createAccountBtn.addTarget(self, action: #selector(createAccountPressed(sender:)), for: .touchUpInside)
        createAccountBtn.addTarget(self, action: #selector(darkenButton(sender:)), for: .touchDown)
        
        view.addSubview(emailFld)
        view.addSubview(passFld)
        view.addSubview(loginBtn)
        view.addSubview(separator)
        view.addSubview(googleBtn)
        view.addSubview(createAccountBtn)
        view.addSubview(imgView)
    }
    
    private func presentAlert(alert: String, message: String) {
        let alertController = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func loadUser() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            print("\n\n\n\(uid)\n\n\n")
            let ref = FIRDatabase.database().reference(withPath: "Users/\(uid)")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    UserData.uid = uid
                    UserData.update(with: snapshot)
                } else {
                    self.presentAlert(alert: "This account doesn't exist", message: "Please contact support at support@savetheirsouls.org")
                }
            }
        } else {
            print("\n\n\nNo uid\n\n\n")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CreateAccountVC {
            // pass data to CreateAccountVC here
        } else if let dest = segue.destination as? MapVC {
            // pass data to MapVC here
        }
    }
    
    // button actions
    @objc func darkenButton(sender:Any) {
        if let btn = sender as? UIButton {
            btn.backgroundColor = btn.backgroundColor?.darker()
        }
    }
    
    @objc func loginPressed(sender:UIButton) {
        if let email = emailFld.text, let pass = passFld.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pass) { (user, error) in
                if error == nil {
                    //Valid Email and Password
                    self.loadUser()
                    self.performSegue(withIdentifier: "MapSegue", sender: sender)
                } else {
                    print(error!.localizedDescription)
                    self.presentAlert(alert: "Invalid Login Credentials", message: "")
                }
            }
        }
        
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 22)
    }
    
    @objc func googleSignInPressed(sender:UIButton) {
        //GIDSignIn.sharedInstance().signIn()
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 22)
        print("Google pressed")
        
    }
    
    @objc func createAccountPressed(sender:UIButton) {
        sender.backgroundColor = sender.backgroundColor?.lighter(by: 22)
        performSegue(withIdentifier: "CreateAccountSegue", sender: sender)
    }
    
    // textfield delegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 && textField.text == nil {
            textField.placeholder = "Email"
        }
        if textField.tag == 1 && textField.text == nil {
            textField.placeholder = "Password"
        }
    }
    
    // google sign in delegate functions
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("\n\n\nDISPATCHING\n\n\n")
        if let error = error {
            print(error)
        }
        else {
            print("Signed in successfully")
            //performSegue(withIdentifier: "MapSegue", sender: nil)
        }
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("\n\n\nPRESENTING\n\n\n")
        present(viewController, animated: true) {
            
        }
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("\n\n\nDISMISSING\n\n\n")
        dismiss(animated: true) {
            guard let user = signIn.currentUser else { return }
            guard let authentication = user.authentication else { return }
            let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                              accessToken: authentication.accessToken)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (result, error) in
                if let error = error {
                    print(error)
                } else {
                    print("Successfully signed in")
                    UserData.name = user.profile.name
                    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
                    UserData.uid = uid
                    UserData.upload()
                    print("UID: " + FIRAuth.auth()!.currentUser!.uid)
                    self.performSegue(withIdentifier: "MapSegue", sender: nil)
                }
                
            })
        }
    }
}

