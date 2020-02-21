//
//  RecipeSearchViewController.swift
//  SoftExpert
//
//  Created by Mahmoud helmy on 2/19/20.
//

import UIKit

class RecipeSearchViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate {

    @IBOutlet weak var RecipeTable: UITableView!
    var startIndex = 0
    var endIndex = 10
    let search = UISearchController(searchResultsController: nil)
    var recipe : RecipeModel?

    
    func updateSearchResults(for searchController: UISearchController) {
           
           
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
       RecipeTable.delegate = self
        RecipeTable.dataSource = self
        sendRequest(from: 0, to: 10, searchText: "t")
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.RecipeTable.estimatedRowHeight = UITableView.automaticDimension
        self.RecipeTable.rowHeight = 150
    }
      func setupNavBar() {
          
          if #available(iOS 11.0, *) {
              navigationController?.navigationBar.prefersLargeTitles = true
          } else {
              // Fallback on earlier versions
          }
          
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        print(searchBar.searchTextField.text)
        sendRequest(from: 0, to: 10, searchText: searchBar.searchTextField.text ?? "")
        
    }

    func sendRequest(from:Int, to :Int, searchText:String) {
        
        UIViewHelper.shared.showActivityIndicator(uiView: self.view)
        RecipeRequest.instance.getRecipe(searchText: "chicken", from: startIndex, to: endIndex) { (data, error) in
            
            self.search.isActive = false
            
            UIViewHelper.shared.hideActivityIndicator(uiView: self.view)

            if data != nil {
                
                self.recipe = data
                self.RecipeTable.reloadData()
                
                if data?.count == 0 {
                    
                    
                } else {
                    
                }
                
            } else {
                
            }
        }
    }
}

extension RecipeSearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(self.recipe?.hits.count)
        return self.recipe?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipe") as! RecipeTableViewCell
        
        cell.configure(item: (recipe?.hits[indexPath.row])!)
        
     
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == ((recipe?.hits.count)! - 1) {
            if recipe!.more {
            let startindex = recipe?.hits.count
                endIndex = startindex! + 10
                if endIndex <= 100 {
                  sendRequest(from: startIndex, to: endIndex, searchText: "chicken")
                }
              }
    }
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GoToDetails") as! ReciepeDetails
        
        vc.hits = recipe?.hits[indexPath.row]
         self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
