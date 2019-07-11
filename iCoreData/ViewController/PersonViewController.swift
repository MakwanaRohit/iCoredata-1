//
//  PersonViewController.swift
//  CoreData_Traning
//
//  Created by Rohit Makwana on 10/07/19.
//  Copyright © 2019 Rohit Makwana. All rights reserved.
//


import UIKit
import CoreData

enum EntityName: String {
    
    case person   = "Person"
    case phone    = "Phone"
    case friends  = "friends"
}

class PersonViewController: UIViewController {    
    
    //**********************************************************************
    // MARK:- IBOutlets
    //**********************************************************************

    @IBOutlet private weak var personTableView: UITableView! {
        didSet {
            personTableView.tableFooterView = UIView()
        }
    }
    
    //**********************************************************************
    // MARK:- Declared Variables
    //**********************************************************************

    private var persons : [Person] = []
    private var firstNames : [String] = ["Rohit", "Paresh", "Vikash", "Mohit", "Sanjay", "Ankit"]
    private var lastNames : [String] = ["Makwana", "Kanani", "Prajapati", "Dholakiya", "Patel", "Rathod"]
    private var iPhones = ["iPhone 5","iPhone 5s","iPhone 6","iPhone 6 plus","iPhone 7","iPhone 7 plus","iPhone 8","iPhone 8 plus","iPhone X","iPhone XR","iPhone XS","iPhone XS Max"]
    private var iOS = ["iOS 10","iOS 10.1", "iOS 11", "iOS 11.1", "iOS 12", "iOS 12.1", "iOS 12.2", "iOS 13", "iOS 13.1"]
    private let reuseIdentifier = "PersonTableViewCell"
    
    private var managedContext : NSManagedObjectContext?

    //**********************************************************************
    // MARK:- View LifeCycle
    //**********************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Persons"
        self.managedContext = appDelegate?.getManagedObjectContext()
        self.setDesignLayout()
        self.getPersons()
    }

    
    //**********************************************************************
    // MARK:- IBAction
    //**********************************************************************

    @IBAction func addPersonButtonAction(_ sender: Any) {
        
        self.createPerson()
    }
    
    //**********************************************************************
    // MARK:- Public Methods
    //**********************************************************************
    
    //**********************************************************************
    // Set Design Layout
    //**********************************************************************
    
    private func setDesignLayout() {
        
        self.personTableView.register(UINib(nibName: self.reuseIdentifier, bundle: nil), forCellReuseIdentifier: self.reuseIdentifier)
        self.personTableView.delegate   = self
        self.personTableView.dataSource = self
        self.personTableView.separatorStyle = .none
    }
}

// MARK:-
extension PersonViewController: UITableViewDelegate, UITableViewDataSource {
    
    //**********************************************************************
    // MARK:- UITableView Delegate &  DataSource
    //**********************************************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as! PersonTableViewCell
        
        cell.person           = self.persons[indexPath.row]
        cell.personDelgate    = self
        cell.deleteButton.tag = indexPath.row
        cell.editButton.tag   = indexPath.row

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}


// MARK:-
extension PersonViewController :PersonActionDelegate {
    
    //**********************************************************************
    // MARK:- Person Action Delegate
    //**********************************************************************

    func PersonActionType(_ type: PersonActions, AtIndex index: Int) {

        switch type {
        case .delete:
            
            AlertView.showAlert(WithTitle: "Delete", AndMessage: "Are you sure, you want to delete ?", actions: ["OK"], isShowCancel: true, completion: { (action) in
                
                self.deletePerson(atIndex: index)
            })
            break
        case .edit:
            
            let alert = UIAlertController(title: nil, message: "Enter first name", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = self.persons[index].firstname ?? ""
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                
                if textField!.text!.isBlank {
                    
                    DispatchQueue.main.async {
                        AlertView.showAlert(WithTitle: "Failed to save", AndMessage: "Invalid firstname", action: "OK")
                    }
                }
                else {
                    
                    //Update Person value

                    self.persons[index].firstname = textField!.text!
                    do {
                        try self.managedContext?.save()
                    } catch let err as NSError {
                        print("Could not save.\(err) \(err.description)")
                    }
                    
                    self.personTableView.reloadData()
                }
                print("Text field: \(textField!.text!)")
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            break
        default: break
        }
    }
}

// MARK:-
extension PersonViewController {
    
    //**********************************************************************
    // MARK:- CoreData stuff
    //**********************************************************************
    
    //Create new `Person` with `Phone` and `Friends` entity
    private func createPerson() {

        /*
        let managedContext = appDelegate!.getManagedObjectContext()
        let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: personEntity, insertInto: managedContext)
        person.setValue("Rohit", forKey: "firstname")
        person.setValue("Makwana", forKey: "lastname")
         */

        let person = Person(context: self.managedContext!)
        person.firstname = firstNames.randomElement()
        person.lastname = lastNames.randomElement()

        let phone = Phone(context: self.managedContext!)
        phone.brand  = "Apple"
        phone.model  = self.iPhones.randomElement()
        phone.os     = iOS.randomElement()
        person.phone = phone

        var arr : [Friends] = []
        let random = [1,2,3,4,5].randomElement()
        for i in 0..<random! {

            let friends = Friends(context: self.managedContext!)
            friends.firstname = firstNames.randomElement()
            friends.lastname = lastNames.randomElement()
            
            if i < self.persons.count {
                friends.person?.adding(persons[i])
            }
            
            arr.append(friends)
        }
        
        person.friends = NSSet(array: arr)
        
        do {
            try self.managedContext?.save()
            self.getPersons()

        } catch let err as NSError {
            print("Could not save.\(err) \(err.description)")
        }
    }
    
    //Get all `Person` list from database
    private func getPersons() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.person.rawValue)
        request.sortDescriptors = [NSSortDescriptor.init(key: "firstname", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try self.managedContext?.fetch(request)
            self.persons = result as! [Person]
            self.personTableView.reloadData()
        } catch {
            print("Failed")
        }
    }
    
    //=======================================================================
    // Delete User
    //=======================================================================
    
    func deletePerson(atIndex index: Int) {
        
        self.managedContext?.delete(self.persons[index])
        
        do {
            
            try self.managedContext?.save()
            self.persons.remove(at: index)
            self.personTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } catch {
            print(error)
        }
    }
}




