//
//  ContactsTableViewCell.swift
//  Nthuse
//
//  Created by Muhammad Imran on 20/10/2020.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var numberCell: UILabel!
    @IBOutlet weak var nameCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
