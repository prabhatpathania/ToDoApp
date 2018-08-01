//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Prabhat Singh Pathania on 25/07/18.
//  Copyright © 2018 Prabhat Singh Pathania. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var todoColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
