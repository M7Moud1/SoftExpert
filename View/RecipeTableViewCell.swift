//
//  RecipeTableViewCell.swift
//  SoftExpert
//
//  Created by Mahmoud helmy on 2/19/20.
//

import UIKit
import Kingfisher

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RecipeImage: UIImageView!
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var Source: UILabel!
    
    @IBOutlet weak var Health: UILabel!
    
    
    
    @IBOutlet weak var Content: UIView! {
        
        didSet {
            
            clipsToBounds = true
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 0, height: 1)
                layer.shadowRadius = 5
                layer.shadowOpacity = 0.2

            layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(item:Hit) {
        
        let url = URL(string: item.recipe.image)
        RecipeImage.kf.indicatorType = .activity
        RecipeImage.kf.setImage(with: url)
        Title.text = item.recipe.label
        Source.text = item.recipe.source
        var str : String?
        

        for comments in 0..<item.recipe.healthLabels.count {
            if comments == 0 {
            str = "(" + item.recipe.healthLabels[comments]
            } else if comments != item.recipe.healthLabels.count - 1 {
                
                str! += "," + item.recipe.healthLabels[comments]
            } else {
                
                str! +=   "," + item.recipe.healthLabels[comments] + ")"
            }
            Health.text = str
//          counter = comments as String
//
//
//
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 21))
//            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            label.center = CGPoint(x: 0 + spacer, y: 0 )
//            label.textAlignment = .center
//             label.text = counter
//            Content.addSubview(label)
//            spacer = spacer + 75
        }
    }

}
