//
//  ToDoViewController.swift
//  TestTodo
//
//  Created by AGC on 08/09/19.
//  Copyright © 2019 AGC. All rights reserved.
//

import UIKit
import Reachability
import BRYXBanner

/// Todo View Controller
class ToDoViewController: UIViewController {

    /// Storyboard instance of the view controller
    static func storyboardInstance() -> ToDoViewController? {
        return MainStoryBoard.instantiateViewController(withIdentifier: "ToDoViewController") as? ToDoViewController
    }
    
    /// Navigation view
    @IBOutlet weak var vwNavigation: UIView!
    /// Screen Title
    @IBOutlet weak var lblTitle: UILabel!
    /// Add Todo Button
    @IBOutlet weak var btnAdd: UIButton!
    /// Todo tableview
    @IBOutlet weak var tlbTodo: UITableView!
    /// No data found a label
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    /// List of all todo
    var arrTodo = [Todo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitial()
        fetchTodoData()
        // Do any additional setup after loading the view.
    }
    
    /// Set up the initial configuration
    func setUpInitial() {
        self.navigationController?.navigationBar.isHidden = true
        self.lblNoDataFound.isHidden = true
        tlbTodo.delegate = self
        tlbTodo.dataSource = self
        tlbTodo.tableFooterView = UIView.init(frame: .zero)
    }
    
    /// Fetch all the todo and reload into the table view
    func fetchTodoData() {
        self.ShowProgressHUD()
        ToDoViewModel.shared.getAllTodo { (arrTodo, error) in
            self.HideProgressHUD()
            if error == nil {
                DispatchQueue.main.async {
                    self.arrTodo = arrTodo
                    self.tlbTodo.reloadData()
                }
            }
            DispatchQueue.main.async {
                if arrTodo.count == 0 {
                    self.lblNoDataFound.isHidden = false
                } else {
                    self.lblNoDataFound.isHidden = true
                }
            }
        }
    }

    /// Navigate user to the add todo screen
    @IBAction func onClickAddTodo(_ sender: UIButton) {
        let addTodo = AddTodoViewController.storyboardInstance()!
        self.navigationController?.pushViewController(addTodo, animated: false)
    }
    
}

extension ToDoViewController:UITableViewDelegate,UITableViewDataSource {
    
    /// No of todo available count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTodo.count
    }
    
    /// Render data of the todo in table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tlbTodo.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TodoListCell
        cell.selectionStyle = .none
        if indexPath.row < arrTodo.count {
            cell.data = arrTodo[indexPath.row]
            cell.configure()
        }
        return cell
    }
    
    /// Allow edit and delete todo with swiping option
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            DispatchQueue.main.async {
                let reachable = Reachability()
                if reachable?.connection == .wifi || reachable?.connection == .cellular {
                    self.removeTodo(self.arrTodo[indexPath.row])
                } else {
                    let banner = Banner(title: "Todo", subtitle: "Please check your internet connection.", image: nil, backgroundColor: UIColor.red)
                    banner.dismissesOnTap = true
                    banner.springiness = .none
                    banner.show(duration: 2.0)
                }
            }
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            DispatchQueue.main.async {
                let addTodo = AddTodoViewController.storyboardInstance()!
                addTodo.editTodo = self.arrTodo[indexPath.row]
                self.navigationController?.pushViewController(addTodo, animated: false)
            }
        }
        edit.backgroundColor = UIColor.init(red: 2/255.0, green: 100/255.0, blue: 64/255.0, alpha: 1.0)
        return [delete, edit]
    }
    
    /// Show user to alert for delete todo and if select yes then remove todo and reload the table view
    func removeTodo(_ item:Todo) {
        let alertController = UIAlertController(title: "Todo", message: "Are you sure you want to delete this todo ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            ToDoViewModel.shared.removeTodo(item, completion: { (sucess, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.tlbTodo.reloadData()
                    }
                }
            })
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

