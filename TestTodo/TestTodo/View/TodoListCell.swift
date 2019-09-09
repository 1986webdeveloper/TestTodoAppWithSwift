//
//  TodoListCell.swift
//  TestTodo
//
//  Created by AGC on 08/09/19.
//  Copyright © 2019 AGC. All rights reserved.
//

import UIKit

/// Tolo List Cell
class TodoListCell: UITableViewCell {

    /// title label
    @IBOutlet weak var lblTitle: UILabel!
    /// description label
    @IBOutlet weak var lblDecription: UILabel!
    
    /// todo object
    var data:Todo!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Set the data of todo in cell
    func configure() {
        if data != nil {
            lblTitle.text = data.title.capitalized
            lblDecription.text = data.descriptionValue
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
