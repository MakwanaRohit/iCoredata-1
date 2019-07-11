//
//  PersonTableViewCell.swift
//  CoreData_Traning
//
//  Created by Rohit Makwana on 10/07/19.
//  Copyright © 2019 Rohit Makwana. All rights reserved.
//

import UIKit

enum PersonActions {
    
    case delete
    case edit
    case none
}

protocol PersonActionDelegate {
    
    func PersonActionType(_ type: PersonActions, AtIndex index: Int)
}


class PersonTableViewCell: UITableViewCell {
    
    //**********************************************************************
    // MARK:- IBOutlets
    //**********************************************************************

    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    //**********************************************************************
    // MARK:- Declared Variables
    //**********************************************************************
    
    var personDelgate : PersonActionDelegate?
    var person : Person? = nil {
        
        didSet {
            
            if self.person != nil {
                
                self.nameLabel.text  = "\(self.person?.firstname ?? "") \(self.person?.lastname ?? "")"
                self.phoneLabel.text = """
                Brand :    \(self.person?.phone?.brand ?? "")
                Model :    \(self.person?.phone?.model ?? "")
                OS :         \(self.person?.phone?.os ?? "")
                """
                
                self.friendsLabel.text = self.getFriends()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //**********************************************************************
    // MARK:- IBAction
    //**********************************************************************
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        
        self.personDelgate?.PersonActionType(.delete, AtIndex: sender.tag)
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        
        self.personDelgate?.PersonActionType(.edit, AtIndex: sender.tag)
    }

    
    // Get Friends list in `String`
    
    private func getFriends() -> String {
        
        var names : String = ""
        let allFriends : [Friends] = self.person?.friends?.allObjects as? [Friends] ?? []
        
        for i in 0..<allFriends.count  {
            
            if i == self.person!.friends!.count-1 {
                names = names + "\(allFriends[i].firstname ?? "") \(allFriends[i].lastname ?? "")"
            }
            else {
                names = names + "\(allFriends[i].firstname ?? "") \(allFriends[i].lastname ?? "")" + ", "
            }
        }
        
        return names
    }
}
