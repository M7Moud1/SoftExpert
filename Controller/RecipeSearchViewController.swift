//
//  RecipeSearchViewController.swift
//  SoftExpert
//
//  Created by Mahmoud helmy on 2/19/20.
//

import UIKit

class RecipeSearchViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate {

    
    func updateSearchResults(for searchController: UISearchController) {
           
           
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }
    
    
      func setupNavBar() {
          
          if #available(iOS 11.0, *) {
              navigationController?.navigationBar.prefersLargeTitles = true
          } else {
              // Fallback on earlier versions
          }
          
          let search = UISearchController(searchResultsController: nil)
          search.searchBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
          search.searchBar.tintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
          search.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
          search.searchBar.searchTextField.textColor = #colorLiteral(red: 0.3064939678, green: 0.7174537778, blue: 0.3662595153, alpha: 1)
          
          if #available(iOS 11.0, *) {
              navigationItem.searchController = search
              navigationItem.hidesSearchBarWhenScrolling = false
          } else {
              present(search, animated: true, completion: nil)
          }
          
          search.searchBar.delegate = self
      }
      
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
