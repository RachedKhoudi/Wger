//
//  ExerciseTableViewCell.swift
//  Wger
//
//  Created by Rached Khoudi on 14/11/2021.
//

import UIKit
import Reusable

class ExerciseTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
}
