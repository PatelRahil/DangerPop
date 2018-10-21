//
//  ProfileVC.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/20/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileVC: UIViewController {
    let nameFld = UITextField()
    let adFld = UITextField()
    let slideMenu = UIButton()
    let logoutBtn = UIButton()
    let my_view : UIView = {
        let v = UIView();
        v.backgroundColor = UIColor.black
        //v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        self.TwoColorAnimateBackground()
    }
    
    private func layoutUI() {
        guard let name = UserData.name else { return }
        let address = UserData.address
        let underline = CALayer()
        let underline2 = CALayer()
        let width = CGFloat(2.0)
        
        my_view.frame = CGRect(x: 10, y: 10, width: view.frame.size.width - 20, height: view.frame.size.height - 20)
        my_view.layer.cornerRadius = 30
        let size = my_view.frame.size

        view.backgroundColor = Colors.black
        
        slideMenu.setImage(UIImage(named: "SlideMenuIcon"), for: .normal)
        slideMenu.frame = CGRect(x: 10, y: 40, width: size.width / 12, height: size.width / 12)
        slideMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        nameFld.frame = CGRect(x: size.width / 6, y: 2 * size.height / 7, width: 2 * size.width / 3, height: 30)
        nameFld.attributedPlaceholder = NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: Colors.orange])
        nameFld.textAlignment = .center
        nameFld.textColor = Colors.orange
        nameFld.font = nameFld.font?.withSize(20)
        nameFld.delegate = self
        nameFld.tag = 1
        
        adFld.frame = CGRect(x: size.width / 6, y: 3 * size.height / 7, width: 2 * size.width / 3, height: 30)
        adFld.attributedPlaceholder = NSAttributedString(string: address, attributes: [NSAttributedString.Key.foregroundColor: Colors.orange])
        adFld.textAlignment = .center
        adFld.textColor = Colors.orange
        adFld.font = nameFld.font?.withSize(20)
        adFld.delegate = self
        adFld.tag = 2
        
        let height = CGFloat(50.0)
        let offset = CGFloat(100.0)
        logoutBtn.frame = CGRect(x: size.width / 12, y: size.height - height - offset , width: 5 * size.width / 6, height: height)
        logoutBtn.setTitleColor(UIColor.white, for: .normal)
        logoutBtn.backgroundColor = Colors.orange
        logoutBtn.setTitle("Logout", for: .normal)
        logoutBtn.layer.cornerRadius = 5
        logoutBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutBtn.addTarget(self, action: #selector(darkenButton(sender:)), for: .touchDown)
        logoutBtn.addTarget(self, action: #selector(lightenButton(sender:)), for: .touchUpOutside)
        
        // textfield underline
        underline.borderColor = Colors.orange.cgColor
        underline.frame = CGRect(x: 0, y: nameFld.frame.size.height - width, width: nameFld.frame.size.width, height: nameFld.frame.size.height)
        underline.borderWidth = width
        nameFld.layer.addSublayer(underline)
        nameFld.layer.masksToBounds = true
        
        underline2.borderColor = Colors.orange.cgColor
        underline2.frame = CGRect(x: 0, y: adFld.frame.size.height - width, width: adFld.frame.size.width, height: adFld.frame.size.height)
        underline2.borderWidth = width
        adFld.layer.addSublayer(underline2)
        adFld.layer.masksToBounds = true
        
        my_view.addSubview(slideMenu)
        my_view.addSubview(nameFld)
        my_view.addSubview(adFld)
        my_view.addSubview(logoutBtn)
        
        view.addSubview(my_view)
    }
    
    @objc func darkenButton(sender:Any) {
        if let btn = sender as? UIButton {
            btn.backgroundColor = btn.backgroundColor?.darker()
        }
    }
    
    @objc func lightenButton(sender:Any) {
        if let btn = sender as? UIButton {
            btn.backgroundColor = btn.backgroundColor?.lighter()
        }
    }
    
    @objc func logout() {
        do {
            try? FIRAuth.auth()?.signOut()
            guard let uid = UserData.uid else { return }
            if FIRAuth.auth()?.currentUser == nil {
                UserData.upload()
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(vc, animated: true, completion: nil)
                
            }
        }
    }
    
    func TwoColorAnimateBackground() {
        UIView.animate(withDuration: 1, animations: {
            self.view.backgroundColor = UIColor.init(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0)
        }, completion: {
            (completed : Bool) -> Void in
            UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {
                self.view.backgroundColor = UIColor.init(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
            }, completion: {
                (completed : Bool) -> Void in
                self.TwoColorAnimateBackground()
            })
        })
    }
}

extension ProfileVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\n\n\nTEXT FIELD ENDED EDITING\n\n\n")
        if textField.tag == 1 && textField.text != "" {
            UserData.name = textField.text
        }
        else if textField.tag == 1 {
            guard let name = UserData.name else { return }
            nameFld.attributedPlaceholder = NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: Colors.orange])
        }
        else if textField.tag == 2 {
            UserData.address = textField.text!
        } else { return }
        UserData.upload()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
