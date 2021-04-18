//
//  CustomCell.swift
//  WeatherApp
//
//  Created by Felipe Lobo on 05/04/21.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var newsImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 20
        backView.layer.shadowColor = UIColor(named: "blue")?.cgColor
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowOffset = CGSize(width: 10, height: 10)
        backView.layer.shadowRadius = 10
        
        newsImage.layer.cornerRadius = 20
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
