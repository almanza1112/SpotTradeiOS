//
//  Sidebar.swift
//  spottrade
//
//  Created by Bryant Almanza on 6/21/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import Foundation
import UIKit

protocol SidebarViewDelegate: class {
    func sidebarDidSelectRow(row: Row)
}

enum Row: String {
    case Info
    case YourSpots
    case History
    case Feedback
    case Payment
    case Personal
    case About
    case LogOut
    case none
    
    init(row: Int) {
        switch row {
        case 0: self = .Info
        case 1: self = .YourSpots
        case 2: self = .History
        case 3: self = .Feedback
        case 4: self = .Payment
        case 5: self = .Personal
        case 6: self = .About
        case 7: self = .LogOut
        default: self = .none
        }
    }
}

class SidebarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var titleArr = [String]()
    
    weak var delegate: SidebarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor(red: 54/255, green: 55/255, blue: 56/255, alpha: 1.0)
        self.clipsToBounds = true
        
        titleArr = ["Bryant Almanza", "Your Spots", "History", "Feedback", "Payment", "Personal", "About", "Log Out"]
        
        setupViews()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.tableFooterView = UIView()
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        myTableView.allowsSelection = true
        myTableView.bounces = false
        myTableView.showsVerticalScrollIndicator = false
        myTableView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(named: "colorPrimary")
            let cellImg: UIImageView!
            cellImg = UIImageView(frame: CGRect(x: 15, y: 10, width: 80, height: 80))
            cellImg.layer.cornerRadius = 40
            cellImg.layer.masksToBounds = true
            cellImg.contentMode = .scaleAspectFill
            cellImg.layer.masksToBounds = true
            cellImg.image = #imageLiteral(resourceName: "icons8-menu-50")
            cell.addSubview(cellImg)
            let cellLb1 = UILabel(frame: CGRect(x: 110, y: cell.frame.height/2-15, width: 250, height: 30))
            cell.addSubview(cellLb1)
            cellLb1.text = titleArr[indexPath.row]
            cellLb1.font = UIFont.systemFont(ofSize: 17)
            cellLb1.textColor = UIColor.white
        } else {
            cell.textLabel?.text = titleArr[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkText
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.delegate?.sidebarDidSelectRow(row: Row(row: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 60
        }
    }
    
    func setupViews() {
        self.addSubview(myTableView)
        myTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    let myTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
}
