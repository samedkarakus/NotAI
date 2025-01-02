//
//  NotesTableViewCell.swift
//  NotAI
//
//  Created by Samed Karakuş on 1.01.2025.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var verticalLine: UIImageView!
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteDetails: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        editLine(to: verticalLine, color: .darkGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
