//
//  ViewController.swift
//  StudentDetailsCoreData
//
//  Created by Canny on 09/05/17.
//  Copyright © 2017 Canny. All rights reserved.
//

import UIKit
import CoreData

var people: [NSManagedObject] = []

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var regNOtxt: UITextField!
    @IBOutlet weak var phoneNotxt: UITextField!
    @IBOutlet weak var emilIdTxt: UITextField!
    @IBOutlet weak var dobTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = .white
        toolBar.backgroundColor = .black
        let todatBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.tappedBarBtn))
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 17)
        label.backgroundColor = .clear
        label.textColor = .white
        label.text = "Selected a due data"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todatBtn, flexSpace, textBtn,okBarBtn], animated: true)
        dobTxt.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func donePressed(_ sender: UIBarButtonItem) {
        dobTxt.resignFirstResponder()
    }
    
    func tappedBarBtn(_ sender: UIBarButtonItem) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "MMM d, yyyy"
        dobTxt.text = dateFormatter.string(from: Date())
        dobTxt.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let datefomatter = DateFormatter()
        datefomatter.dateStyle = DateFormatter.Style.medium
        datefomatter.timeStyle = DateFormatter.Style.none
        datefomatter.dateFormat = "MMM d, yyyy"
        dobTxt.text = datefomatter.string(from: sender.date)
        
    }
    
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        if (nameTxt.text?.isEmpty)! || (regNOtxt.text?.isEmpty)! || (phoneNotxt.text?.isEmpty)! || (emilIdTxt.text?.isEmpty)! || (dobTxt.text?.isEmpty)! || (genderTxt.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Alert", message: "All Fields required", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "StudentDetails", in: managedContext)!
            
            let studentDetail = NSManagedObject(entity: entity, insertInto: managedContext)
            
            studentDetail.setValue(nameTxt.text, forKey: "name")
            studentDetail.setValue(regNOtxt.text, forKey: "regno")
            studentDetail.setValue(emilIdTxt.text, forKey: "emailid")
            studentDetail.setValue(phoneNotxt.text, forKey: "phone")
            studentDetail.setValue(dobTxt.text, forKey: "dob")
            studentDetail.setValue(genderTxt.text, forKey: "gender")
            do {
                try managedContext.save()
                people.append(studentDetail)
            } catch let error as NSError {
                print("Could Not Save. \(error), \(error.userInfo)")
            }
            
            nameTxt.text = ""
            regNOtxt.text = ""
            emilIdTxt.text = ""
            phoneNotxt.text = ""
            dobTxt.text = ""
            genderTxt.text = ""
            nameTxt.becomeFirstResponder()
        }
    }
    
    @IBAction func viewAction(_ sender: UIButton) {
    }
    
    func uniqueElementsFrom(array: [NSManagedObject]) -> [NSManagedObject] {
        
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains("\($0)") else {
                return false
            }
            set.insert("\($0)")
            return true
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let arr = uniqueElementsFrom(array: people)
        let viewcontroller = segue.destination as? TableViewController
        viewcontroller?.getDataArray = arr
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .gray
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = .white
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text == nameTxt.text || textField.text == emilIdTxt.text {
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.characters.count <= maxLength
        }
        
        if textField.text == phoneNotxt.text {
            
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.characters.count <= maxLength
        }
        return true
    }
}

