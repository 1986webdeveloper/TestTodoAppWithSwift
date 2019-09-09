//
//  AddTodoViewController.swift
//  TestTodo
//
//  Created by AGC on 08/09/19.
//  Copyright © 2019 AGC. All rights reserved.
//

import UIKit
import Reachability
import BRYXBanner

/// Add Todo View Controller
class AddTodoViewController: UIViewController {

    /// Storyboard instance of the view controller
    static func storyboardInstance() -> AddTodoViewController? {
        return MainStoryBoard.instantiateViewController(withIdentifier: "AddTodoViewController") as? AddTodoViewController
    }
    
    /// Screen Title
    @IBOutlet weak var lblTitle: UILabel!
    /// Back Button
    @IBOutlet weak var btnBack: UIButton!
    /// Todo title text field
    @IBOutlet weak var txtTitle: UITextField!
    /// Title error view
    @IBOutlet weak var errorTitleView: ErrorView!
    /// Title error view height
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    /// Todo Description text view
    @IBOutlet weak var txtDescription: UITextView!
    /// Description error view
    @IBOutlet weak var errorDescriptionView: ErrorView!
    /// Description error view height
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    /// Save Button
    @IBOutlet weak var btnSave: UIButton!
    /// Description place holder text
    let descriptionPlaceHolder = "Enter description"
    /// Edit todo object
    var editTodo:Todo!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        // Do any additional setup after loading the view.
    }
    
    /// Set up the initial configuration
    func initialSetUp() {
        txtDescription.delegate = self
        txtTitle.delegate = self
        txtDescription.text = descriptionPlaceHolder
        txtDescription.textColor = UIColor.lightGray
        
        titleViewHeight.constant = 0
        errorTitleView.isHidden = true
        
        descriptionViewHeight.constant = 0
        errorDescriptionView.isHidden = true
        if editTodo != nil {
            setUpData()
        }
    }
    
    /// Set the edit todo data
    func setUpData() {
        lblTitle.text = "Edit Todo"
        txtTitle.text = editTodo.title
        txtDescription.text = editTodo.descriptionValue
        txtDescription.textColor = UIColor.black
    }
    
    /// Navigation back user to todo list view controller
    @IBAction func onClickBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    /// Save the todo if not found any issue while validation and navigate to the todo list screen.
    @IBAction func onClickSave(_ sender: UIButton) {
        if validation() {
            let reachability = Reachability()
            if reachability?.connection == .wifi || reachability?.connection == .cellular {
                self.ShowProgressHUD()
                let title = txtTitle.text?.TrimString()
                let description = txtDescription.text.TrimString()
                let todo = Todo.init(title!, description)
                if editTodo != nil {
                    todo.id = editTodo.id
                    ToDoViewModel.shared.editTodo(todo) { (success, error) in
                        self.HideProgressHUD()
                        if success == true {
                            DispatchQueue.main.async {
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                        } else {
                            let banner = Banner(title: "Todo", subtitle: error?.localizedDescription, image: nil, backgroundColor: UIColor.red)
                            banner.dismissesOnTap = true
                            banner.springiness = .none
                            banner.show(duration: 2.0)
                        }
                    }
                } else {
                    ToDoViewModel.shared.addTodo(todo) { (success, error) in
                        self.HideProgressHUD()
                        if success == true {
                            DispatchQueue.main.async {
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                        } else {
                            let banner = Banner(title: "Todo", subtitle: error?.localizedDescription, image: nil, backgroundColor: UIColor.red)
                            banner.dismissesOnTap = true
                            banner.springiness = .none
                            banner.show(duration: 2.0)
                        }
                    }
                }
            } else {
                if editTodo != nil {
                    let banner = Banner(title: "Todo", subtitle: "Please check your internet connection.", image: nil, backgroundColor: UIColor.red)
                    banner.dismissesOnTap = true
                    banner.springiness = .none
                    banner.show(duration: 2.0)
                } else {
                    let title = txtTitle.text?.TrimString()
                    let description = txtDescription.text.TrimString()
                    let todo = Todo.init(title!, description)
                    ToDoViewModel.shared.addTodo(todo) { (success, error) in
                        self.HideProgressHUD()
                        if success == true {
                            DispatchQueue.main.async {
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                        } else {
                            let banner = Banner(title: "Todo", subtitle: error?.localizedDescription, image: nil, backgroundColor: UIColor.red)
                            banner.dismissesOnTap = true
                            banner.springiness = .none
                            banner.show(duration: 2.0)
                        }
                    }
                }
            }
        }
    }
    
    /// Validate user input and show an error message if found any issue
    func validation() -> Bool {
        var checkValidation = true
        let title = txtTitle.text?.TrimString()
        let description = txtDescription.text.TrimString()
        if title == "" {
            checkValidation = false
            errorTitleView.isHidden = false
            txtTitle.superview?.layer.borderColor = UIColor.red.cgColor
            errorTitleView.message = "Please enter todo title"
        }
        
        if description == "" || description == descriptionPlaceHolder {
            checkValidation = false
            errorDescriptionView.isHidden = false
            txtDescription.superview?.layer.borderColor = UIColor.red.cgColor
            errorDescriptionView.message = "Please enter todo dectiption"
        }
        return checkValidation
    }
    
}

extension AddTodoViewController:UITextFieldDelegate {
    
    /// Hide the red border of the text field
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtTitle {
            txtTitle.superview?.layer.borderColor = UIColor.lightGray.cgColor
            if titleViewHeight.constant > 0 {
                titleViewHeight.constant = 0
                errorTitleView.isHidden = true
            }
        }
        return true
    }
    
    /// Don't allow the user to add emoji in the text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.textInputMode?.primaryLanguage == nil || textField.textInputMode?.primaryLanguage == "emoji" {
            return false;
        }
        return true
    }
}

extension AddTodoViewController:UITextViewDelegate {
    /// Don't allow the user to add emoji in text view
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.textInputMode?.primaryLanguage == nil || textView.textInputMode?.primaryLanguage == "emoji" {
            return false;
        }
        return true
    }
    
    /// Hide the red border of the text view
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == txtDescription {
            txtDescription.superview?.layer.borderColor = UIColor.lightGray.cgColor
            if descriptionViewHeight.constant > 0 {
                descriptionViewHeight.constant = 0
                errorDescriptionView.isHidden = true
            }
            if txtDescription.text == descriptionPlaceHolder {
                txtDescription.text = ""
                txtDescription.textColor = UIColor.black
            }
        }
        return true
    }
    
    /// Set the description view place holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtDescription {
            if txtDescription.text == "" {
                txtDescription.text = descriptionPlaceHolder
                txtDescription.textColor = UIColor.lightGray
            }
        }
    }
}
