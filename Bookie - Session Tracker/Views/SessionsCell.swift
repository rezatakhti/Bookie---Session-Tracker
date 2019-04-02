//
//  TableViewCell.swift
//  
//
//  Created by Reza Takhti on 3/26/19.
//

import UIKit
import SwipeCellKit

class SessionsCell: SwipeTableViewCell {

    @IBOutlet weak var sessionLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
