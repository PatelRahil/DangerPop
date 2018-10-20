//
//  CreateAccountVC.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/19/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//
import UIKit
import Firebase

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    let nameFld = UITextField()
    let addressFld = UITextField()
    let emailFld = UITextField()
    let passFld = UITextField()
    let createBtn = UIButton()
    let separator = UIView()
    let back = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // Convenience functions
    private func setupUI() {
        let viewSize = view.frame.size
        let underline = CALayer()
        let underline2 = CALayer()
        let underline3 = CALayer()
        let underline4 = CALayer()
        let width = CGFloat(2.0)
        let edgeInset:CGFloat = 1.0/12
        
        view.backgroundColor = Colors.black
        
        nameFld.frame = CGRect(origin: CGPoint(x: viewSize.width * edgeInset, y: viewSize.height / 6), size: CGSize(width: (viewSize.width - (2 * edgeInset) * viewSize.width), height: 25))
        nameFld.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        nameFld.textColor = UIColor.white
        nameFld.textAlignment = .center
        nameFld.tag = 0;
        
        addressFld.frame = CGRect(origin: CGPoint(x: viewSize.width * edgeInset, y: nameFld.frame.maxY + 60), size: CGSize(width: (viewSize.width - (2 * edgeInset) * viewSize.width), height: 25))
        addressFld.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        addressFld.textColor = UIColor.white
        addressFld.textAlignment = .center
        addressFld.tag = 0;
        
        emailFld.frame = CGRect(origin: CGPoint(x: viewSize.width * edgeInset, y: addressFld.frame.maxY + 60), size: CGSize(width: (viewSize.width - (2 * edgeInset) * viewSize.width), height: 25))
        emailFld.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailFld.textColor = UIColor.white
        emailFld.textAlignment = .center
        emailFld.tag = 0;
        
        passFld.frame = CGRect(origin: CGPoint(x: emailFld.frame.minX, y: emailFld.frame.maxY + 60), size: CGSize(width: emailFld.frame.size.width, height: 25))
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
        
        underline3.borderColor = Colors.orange.cgColor
        underline3.frame = CGRect(x: 0, y: nameFld.frame.size.height - width, width: nameFld.frame.size.width, height: nameFld.frame.size.height)
        underline3.borderWidth = width
        nameFld.layer.addSublayer(underline3)
        nameFld.layer.masksToBounds = true
        
        underline4.borderColor = Colors.orange.cgColor
        underline4.frame = CGRect(x: 0, y: addressFld.frame.size.height - width, width: addressFld.frame.size.width, height: addressFld.frame.size.height)
        underline4.borderWidth = width
        addressFld.layer.addSublayer(underline4)
        addressFld.layer.masksToBounds = true
        
        createBtn.frame = CGRect(origin: CGPoint(x: passFld.frame.minX, y: passFld.frame.maxY + 60), size: CGSize(width: passFld.frame.size.width, height: 40))
        createBtn.setTitle("Create", for: .normal)
        createBtn.setTitleColor(.white, for: .normal)
        createBtn.backgroundColor = Colors.orange
        createBtn.layer.cornerRadius = 4
        createBtn.addTarget(self, action: #selector(createPressed(sender:)), for: .touchUpInside)
        createBtn.addTarget(self, action: #selector(darkenButton(sender:)), for: .touchDown)
        
        //separator.borderColor = Colors.orange.cgColor
        separator.backgroundColor = Colors.orange
        separator.frame = CGRect(x: viewSize.width * edgeInset * 0.5, y: createBtn.frame.maxY + 20, width: (viewSize.width - (edgeInset) * viewSize.width), height: 1)
        
        let btnWidth = CGFloat(170)
        back.frame = CGRect(x: (viewSize.width - btnWidth) / 2, y: separator.frame.maxY + 20, width: btnWidth, height: 40)
        back.setTitle("Go Back", for: .normal)
        back.backgroundColor = UIColor(displayP3Red: 240, green: 240, blue: 240, alpha: 1)
        back.setTitleColor(UIColor(displayP3Red: 5, green: 5, blue: 5, alpha: 1), for: .normal)
        
        view.addSubview(nameFld)
        view.addSubview(addressFld)
        view.addSubview(emailFld)
        view.addSubview(passFld)
        view.addSubview(createBtn)
        view.addSubview(separator)
        view.addSubview(back)
    }
    
    private func presentAlert(alert: String, message: String) {
        let alertController = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // button actions
    @objc func darkenButton(sender:Any) {
        if let btn = sender as? UIButton {
            btn.backgroundColor = btn.backgroundColor?.darker()
        }
    }
    
    @objc func createPressed(sender:UIButton) {
        
         if let _ = emailFld.text, let _ = passFld.text, let _ = nameFld.text, let _ = addressFld.text{
            FIRAuth.auth()!.createUser(withEmail: emailFld.text!, password: passFld.text!,
         completion: { (user: FIRUser?, error) in
         if error != nil {
            self.presentAlert(alert: "Invalid Password", message: "Try something a little shorter")
         return
         }
         guard (user?.uid) != nil else {
         return
         }
         let uid = user?.uid
         let values = ["name": self.nameFld.text!, "address": self.addressFld.text!]
         self.registerUserIntoDatabaseWithUID(uid: uid!, values: values as [String : AnyObject])
         })
         }
 
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
         //update database
         let ref = FIRDatabase.database().reference()
         let usersReference = ref.child("Users").child(uid)
         
         
         usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
             if err != nil {
                print("THERE WAS AN ERROR")
                return
             }
         })
        
        
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
}
