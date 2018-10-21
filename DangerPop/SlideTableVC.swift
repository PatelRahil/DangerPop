//
//  SlideTableVC.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/20/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//

import Foundation
import UIKit

class SlideTableVC: UITableViewController {
    
    @IBOutlet var slideTableView: UITableView!
    var tableArray = ["", "Profile", "Map", "Donate"]
    //@IBOutlet var sideTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = UserData.name {
            tableArray[0] = name
        }
        slideTableView.backgroundColor = Colors.black
        //slideTableView.separatorStyle = .none
        slideTableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let name = UserData.name {
            tableArray[0] = name
        }
        slideTableView.reloadData()
    }
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTemplate") as! customTitleTableViewCell
            cell.lbl.text = tableArray[indexPath.row]
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTemplate") as! customTableViewCell
            cell.lbl.text = tableArray[indexPath.row]
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! customTableViewCell
            cell.lbl.text = tableArray[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonateCell") as! customTableViewCell
            cell.lbl.text = tableArray[indexPath.row]
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue activated")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell!.reuseIdentifier == "BasicTemplate" {
            performSegue(withIdentifier: "ProfileSegue", sender: nil)
        } else if cell!.reuseIdentifier == "MapCell" {
            performSegue(withIdentifier: "BackToMapSegue", sender: nil)
        } else if cell!.reuseIdentifier == "DonateCell" {
            print("Donate cell tapped")
            if let url = URL(string: "https://savetheirsouls.org") {
                UIApplication.shared.open(url, options: [:]) {_ in }
            } else {
                print("not a url")
            }
            tableView.reloadData()
        }
    }

}

class customTableViewCell: UITableViewCell {
    let lbl = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        let superview = super.contentView
        let viewSize = superview.frame.size
        lbl.frame = CGRect(x: 0, y: 0, width: 280, height: viewSize.height)
        lbl.textColor = Colors.orange
        lbl.textAlignment = .center
        self.backgroundColor = Colors.black
        self.addSubview(lbl)
    }
}

class customTitleTableViewCell: UITableViewCell {
    let lbl = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        let superview = super.contentView
        let viewSize = superview.frame.size
        lbl.frame = CGRect(x: 0, y: 0, width: 280, height: viewSize.height)
        lbl.font = UIFont.boldSystemFont(ofSize: 40)
        lbl.textColor = Colors.orange
        lbl.textAlignment = .center
        backgroundColor = Colors.black
        self.selectionStyle = .none
        self.addSubview(lbl)
    }
}
