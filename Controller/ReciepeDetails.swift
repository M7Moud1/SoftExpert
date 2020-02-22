//
//  ReciepeDetails.swift
//  SoftExpert
//
//  Created by Mahmoud helmy on 2/21/20.
//

import UIKit
import Kingfisher

class ReciepeDetails: UIViewController {

    var hits : Hit?
    var str = ""
    
    @IBOutlet weak var RecipeImg: UIImageView!
    
    
    @IBOutlet weak var Recipe_Ingredient: UILabel!
    
    @IBOutlet weak var titleNav: UINavigationItem!
    
    
    @IBOutlet weak var Publisher: UIButton!{
        
        didSet {
         
            Publisher.layer.cornerRadius = Publisher.frame.height / 2
            Publisher.layer.borderWidth = 2
            Publisher.layer.borderColor = #colorLiteral(red: 0.4472229481, green: 0.7856707573, blue: 0.5028735399, alpha: 1)
            Publisher.backgroundColor = #colorLiteral(red: 0.3064939678, green: 0.7174537778, blue: 0.3662595153, alpha: 1)
            Publisher.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction func PublishersWebsite(_ sender: Any) {
       
        guard let url = URL(string: hits?.recipe.url ?? "") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    
    func setupView(){
        
        
        titleNav.title = hits?.recipe.label
        
        RecipeImg.kf.indicatorType = .activity
        let url = URL(string: hits?.recipe.image ?? "")
        RecipeImg.kf.setImage(with: url)
        
        for i in (hits?.recipe.ingredientLines)! {
            
            str += "- " + i + "\n"
        }
        
        Recipe_Ingredient.text = str
        
        if hits?.recipe.url != "" || hits?.recipe.url != nil {
            
            Publisher.isHidden = false
        } else {
            
            Publisher.isHidden = true

        }
    }


}
