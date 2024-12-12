//
//  LearnerCell.swift
//  NotAI
//
//  Created by Samed Karakuş on 12.12.2024.
//

import UIKit

class LearnerCell: UITableViewCell {

    @IBOutlet weak var LearnerView: UIView!
    @IBOutlet weak var learnerBubbleView: UIView!
    @IBOutlet weak var learnerEmoji: UIImageView!
    @IBOutlet weak var learnerUserName: UILabel!
    @IBOutlet weak var leernerTopic: UILabel!
    @IBOutlet weak var similarityPercentage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeButtonCircular(view: learnerBubbleView)
        learnerBubbleView.layer.cornerRadius = 10
        addBlurredBackground(learnerBubbleView)
        LearnerView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
