//
//  ExerciseCollectionViewCell.swift
//  Wger
//
//  Created by Rached Khoudi on 14/11/2021.
//

import UIKit
import Reusable
import Kingfisher

class ExerciseCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
        self.backgroundColor = .white
        self.nameLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    func setUpView(name: String?, image: String?) {
        if let name = name {
            self.nameLabel.text = name
            self.nameView.isHidden = false
        } else {
            self.nameView.isHidden = true
        }
        
        self.mainImageView.kf.setImage(with: URL(string: image ?? ""), placeholder: UIImage(named: "placeholder"))
    }

    override func prepareForReuse() {
        mainImageView.image = nil
        nameLabel.text = ""
    }
}
