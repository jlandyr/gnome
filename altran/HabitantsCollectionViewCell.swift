//
//  HabitantsCollectionViewCell.swift
//  altran
//
//  Created by Juan S. Landy on 10/7/17.
//
//

import UIKit

class HabitantsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainter: UIView!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    
    @IBOutlet weak var labelGender: UILabel!
    
    override func awakeFromNib() {
        self.labelName.adjustsFontSizeToFitWidth = true
        self.viewContainter.layer.cornerRadius = 5.0
        self.viewContainter.layer.masksToBounds = true
        self.labelAge.adjustsFontSizeToFitWidth = true
        self.labelWeight.adjustsFontSizeToFitWidth = true
        self.labelHeight.adjustsFontSizeToFitWidth = true
        self.labelGender.adjustsFontSizeToFitWidth = true
    }
    
}
