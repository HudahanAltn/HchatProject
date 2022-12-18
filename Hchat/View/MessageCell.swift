//
//  MessageCell.swift
//  Hchat
//
//  Created by Hüdahan Altun on 31.10.2022.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var leftImageView: UIImageView!
    override func awakeFromNib() {
        
        messageBubble.layer.cornerRadius = messageBubble.frame.height/5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
