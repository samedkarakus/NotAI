//
//  ResultTableViewCell.swift
//  NotAI
//
//  Created by Samed Karakuş on 24.12.2024.
//

import UIKit

class ErrorTopicCell: UITableViewCell {

    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var errorDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
