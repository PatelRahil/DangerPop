//
//  ReportVC.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/19/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//
import UIKit
import Firebase
import CoreLocation

class ReportVC: UIViewController, UITextFieldDelegate {
    let descriptionFld = UITextField()
    let reportBtn = UIButton()
    let separator = UIView()
    let back = UIButton()
    var button = dropDownBtn()
    var coords = CLLocationCoordinate2D()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // Convenience functions
    private func setupUI() {
        let viewSize = view.frame.size
        let underline2 = CALayer()
        let width = CGFloat(2.0)
        let edgeInset:CGFloat = 1.0/12
        
        view.backgroundColor = Colors.black
        
        
        descriptionFld.frame = CGRect(origin: CGPoint(x: viewSize.width * edgeInset, y: viewSize.height / 4), size: CGSize(width: (viewSize.width - (2 * edgeInset) * viewSize.width), height: 25))
        descriptionFld.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        descriptionFld.textColor = UIColor.white
        descriptionFld.textAlignment = .center
        descriptionFld.tag = 0;
        
        underline2.borderColor = Colors.orange.cgColor
        underline2.frame = CGRect(x: 0, y: descriptionFld.frame.size.height - width, width: descriptionFld.frame.size.width, height: descriptionFld.frame.size.height)
        underline2.borderWidth = width
        descriptionFld.layer.addSublayer(underline2)
        descriptionFld.layer.masksToBounds = true
        
        reportBtn.frame = CGRect(origin: CGPoint(x: descriptionFld.frame.minX, y: descriptionFld.frame.maxY + 60), size: CGSize(width: descriptionFld.frame.size.width, height: 40))
        reportBtn.setTitle("Report", for: .normal)
        reportBtn.setTitleColor(.white, for: .normal)
        reportBtn.backgroundColor = Colors.orange
        reportBtn.layer.cornerRadius = 4
        reportBtn.addTarget(self, action: #selector(reportPressed(sender:)), for: .touchUpInside)
        reportBtn.addTarget(self, action: #selector(darkenButton(sender:)), for: .touchDown)
        
        //separator.borderColor = Colors.orange.cgColor
        separator.backgroundColor = Colors.orange
        separator.frame = CGRect(x: viewSize.width * edgeInset * 0.5, y: reportBtn.frame.maxY + 20, width: (viewSize.width - (edgeInset) * viewSize.width), height: 1)
        
        let btnWidth = CGFloat(170)
        back.frame = CGRect(x: (viewSize.width - btnWidth) / 2, y: separator.frame.maxY + 20, width: btnWidth, height: 40)
        back.setTitle("Go Back", for: .normal)
        back.backgroundColor = UIColor(displayP3Red: 240, green: 240, blue: 240, alpha: 1)
        back.setTitleColor(UIColor(displayP3Red: 5, green: 5, blue: 5, alpha: 1), for: .normal)
        
        view.addSubview(descriptionFld)
        view.addSubview(reportBtn)
        view.addSubview(separator)
        view.addSubview(back)
        
        //Configure the button
        button = dropDownBtn.init(frame: CGRect(x: 0, y: viewSize.height / 6, width: 0, height: 0))
        button.setTitle("Danger Type", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //Add Button to the View Controller
        self.view.addSubview(button)
        
        //button Constraints
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        button.widthAnchor.constraint(equalToConstant: 170).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Set the drop down menu's options
        button.dropView.dropDownOptions = ["Robbery", "Fire", "Ghost"]
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
    
    @objc func reportPressed(sender:UIButton) {
        /*
         if descriptionFld.text != nil {
         let id = // Generate Threat ID
         let ref = Database.database().reference(fromURL: "Input database reference Here")
         let usersReference = ref.child("Threats").child(id)
         
         let current_date_time = Date()
         
         let lat_value = // Get Lat
         let long_value = // Get Long
         let location_dictionary = [lat: lat_value, long: long_value]
         
         let values = [type: button.getText(), location: location_dictionary, descriptionFld.text!, time: current_date_time]
         usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
         if err != nil {
         print("THERE WAS AN ERROR")
         return
         }
         
         self.dismiss(animated: true, completion: nil)
         })
         }
         */
        let latBound = Int(coords.latitude)
        let longBound = Int(coords.longitude)
        let loc = "\(latBound),\(longBound)"
        
        let ref = FIRDatabase.database().reference(withPath: "/Threats/\(loc)").childByAutoId()
        let eid = ref.key
        
        guard let desc = descriptionFld.text else {
            presentAlert(alert: "No description", message: "Please fill out a description.")
            return
        }
        guard let uid = UserData.uid else {
            presentAlert(alert: "There has been an error", message: "Sign out, and sign back in.")
            return
        }
        let locData:[String:String] = ["lat":"\(coords.latitude)", "long":"\(coords.longitude)"]
        let data:[String:String] = ["type":button.getText(), "description": desc, "creator": uid]
        ref.setValue(data)
        ref.child("location").setValue(locData)
        performSegue(withIdentifier: "BackFromReportSegue", sender: nil)
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
//Drop down menu
protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    
    var text = ""
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.text = string
        self.dismissDropDown()
    }
    
    func getText() -> String{
        return self.text
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.darkGray
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
