//
//  TableViewController.swift
//  StudentDetailsCoreData
//
//  Created by Canny on 09/05/17.
//  Copyright © 2017 Canny. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var tableview: UITableView!
    
    var getDataArray: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StudentDetails")
        do {
            getDataArray = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = getDataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentTableViewCell
        cell.nameLab.text = person.value(forKey: "name") as! String?
        cell.regNoLab.text = person.value(forKey: "regno") as! String?
        cell.emailLab.text = person.value(forKey: "emailid") as! String?
        cell.phoneLab.text = person.value(forKey: "phone") as! String?
        cell.dobLab.text = person.value(forKey: "dob") as! String?
        cell.genderLab.text = person.value(forKey: "gender") as! String?
        return cell
    }
}
