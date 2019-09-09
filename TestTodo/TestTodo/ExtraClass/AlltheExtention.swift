//
//  String+Validation.swift
//  WeatherMonitor
//
//  Created by sanjeet on 11/16/16.
//  Copyright © 2016 sanjeet. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD


extension String {
    /// Remove the while space and a new line from string
    public func TrimString() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIViewController : MBProgressHUDDelegate {

    /// Add tap gesture to view controller for end editing
    func hideKeyboardWhenTappedAround(){
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    /// Stop editing in the view controller
    @objc func dismissKeyboard(){
         view.endEditing(true)
    }
    
    /// Show the progress hud.
    func ShowProgressHUD() {
        DispatchQueue.main.async{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
        }
    }
    
    /// Hide the progress hud
    func HideProgressHUD() {
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view,animated:true)
        }
    }

    /******************** custom  Pop up method ***********************************/
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
