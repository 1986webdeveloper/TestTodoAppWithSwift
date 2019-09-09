//
//  ErrorView.swift
//  TestTodo
//
//  Created by AGC on 08/09/19.
//  Copyright © 2019 AGC. All rights reserved.
//

import UIKit

///Error View
class ErrorView: UIView {

    /// Error message label
    private var lblMessage:UILabel!
    /// Error message image
    private var imgIcon:UIImageView!
    
    /// Set the custom font to message
    var labelFont:UIFont! {
        didSet {
            lblMessage.font = labelFont
        }
    }
    
    /// Set custom color to the message
    var labelColor:UIColor! {
        didSet {
            lblMessage.textColor = labelColor
        }
    }
    
    /// Set error view message
    var message:String = "" {
        didSet {
            lblMessage.text = message
            self.perform(#selector(setHightValue), with: nil, afterDelay: 0.01)
        }
    }
    
    /// Set the hight of the error view according to string
    @objc func setHightValue() {
        let size = CGSize.init(width: lblMessage.frame.width, height: .infinity)
        let estimatedSize = lblMessage.sizeThatFits(size)
        heightValue = estimatedSize.height
        if heightValue < errorViewFixHeight {
            heightValue = errorViewFixHeight
        }
        for item in self.constraints {
            if item.firstAttribute == .height {
                item.constant = heightValue
            }
        }
    }
    
    /// Set custom image to the error view
    var iconImage:UIImage? = nil {
        didSet {
            imgIcon.image = iconImage
        }
    }
    
    /// Height value
    var heightValue:CGFloat = 0
    
    /// Error view initialize method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    /// Error view decoder method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    /// Add the message and image in the Error view
    private func commonInit() {
        
        lblMessage = UILabel.init()
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        lblMessage.lineBreakMode = .byTruncatingTail
        lblMessage.numberOfLines = 0
        lblMessage.textColor = UIColor.red
        self.addSubview(lblMessage)
        
        imgIcon = UIImageView.init()
        imgIcon.image = #imageLiteral(resourceName: "ic_error")
        imgIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imgIcon)
        
        //self.clipsToBounds = true
        
        imgIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imgIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imgIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        lblMessage.leadingAnchor.constraint(equalTo: self.imgIcon.trailingAnchor, constant: 0).isActive = true
        lblMessage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        lblMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        lblMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
    }
}
