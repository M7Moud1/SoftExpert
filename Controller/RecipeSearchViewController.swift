//
//  RecipeSearchViewController.swift
//  SoftExpert
//
//  Created by Mahmoud helmy on 2/19/20.
//

import UIKit
import CoreData

let appdelegate = UIApplication.shared.delegate as? AppDelegate

class RecipeSearchViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate {

    @IBOutlet weak var RecipeTable: UITableView!
    @IBOutlet weak var SuggestTable: UITableView!
    
    var startIndex = 0
    var endIndex = 10
    let search = UISearchController(searchResultsController: nil)
    var recipe : RecipeModel?
    var words = [Latestsearchwords]()

    @IBOutlet weak var NoResult: UILabel!
    
    func updateSearchResults(for searchController: UISearchController) {
           
           
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
        RecipeTable.tableFooterView = UIView()
        SuggestTable.tableFooterView = UIView()
               
        
       RecipeTable.delegate = self
        RecipeTable.dataSource = self
        
        SuggestTable.delegate = self
        SuggestTable.dataSource = self
        
        
        RecipeTable.isHidden = true
        SuggestTable.isHidden = true
        
       
        NoResult.isHidden = false
        NoResult.text = "Welcome to recipe food App "

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
        
        save(word: searchBar.searchTextField.text!)
        for i in 0..<words.count {
            
            print((i) ," و ",  words.count)
            
            if ((words[i].word?.caseInsensitiveCompare(searchBar.searchTextField.text!)) == .orderedSame) {
                
                deleteWord(index: i)
                break
            }
        }
        sendRequest(from: 0, to: 10, searchText: searchBar.searchTextField.text ?? "")
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        print(words.count)
        self.NoResult.isHidden = true
        SuggestTable.isHidden = false
        RecipeTable.isHidden = true
        
        if fetchLatestWord() != 0 {

        SuggestTable.reloadData()
            
        }
    }

    func sendRequest(from:Int, to :Int, searchText:String) {
        
        UIViewHelper.shared.showActivityIndicator(uiView: self.view)
        RecipeRequest.instance.getRecipe(searchText: searchText, from: startIndex, to: endIndex) { (data, error) in
            
            self.search.isActive = false
            self.SuggestTable.isHidden = true

            UIViewHelper.shared.hideActivityIndicator(uiView: self.view)

            if data != nil {
                
                self.recipe = data
                self.RecipeTable.reloadData()
                self.RecipeTable.isHidden = false

                
                if data?.hits.count == 0 {
                    
                    self.NoResult.text = "No result for this search"
                    self.NoResult.isHidden = false
                    
                    
                } else {
                    
                    self.NoResult.isHidden = true

                }
                
            } else if error != nil{
                
                AlertBuilder(title: "Error", message: error?._message, preferredStyle: .alert)
                    .addAction(title: "ok", style: .default)
                    .build()
                    .show(animated: true, completionHandler: nil)
            }
        }
    }
    
    func save(word:String){
        
        if fetchLatestWord() == 10 {
            
            deleteWord(index: 0)
        }
        
        if #available(iOS 10.0, *) {
            guard let entity  = appdelegate?.persistentContainer.viewContext else {return}
            let latestWord = Latestsearchwords(context: entity)
            latestWord.word = word
            print(latestWord)
            do {
                try entity.save()
            } catch  {
                print(error)
            }
        } else {
             let context = NSEntityDescription.insertNewObject(forEntityName: "Latestsearschwords", into: appdelegate!.managedObjectContext)
            
            context.setValue(word, forKey: "word")
            
            do {
                try context.managedObjectContext!.save()
            } catch  {
                 print(error)
             }
        }
     
    }
    
    func fetchLatestWord() -> Int{
        
         let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Latestsearchwords")
        
        if #available(iOS 10.0, *) {
            guard let entity  = appdelegate?.persistentContainer.viewContext else { return Int()}

            
            do {
                words =  try entity.fetch(fetchrequest) as! [Latestsearchwords]
                print(words.count)
                print(words)
            } catch  {
                print(error)
            }
        } else {
            
            let context = appdelegate?.managedObjectContext
           
            
            do {
                words = try context!.fetch(fetchrequest) as! [Latestsearchwords]
            } catch  {
                print(error)
            }
            
        }
        return words.count
    }
    
    func deleteWord(index : Int){
        
        if  index < words.count {
        let note = words[index]


        if #available(iOS 10.0, *) {
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            

            managedContext.delete(note)
            words.remove(at: index)

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        } else {
            let context = appdelegate?.managedObjectContext
            context?.delete(words[index] as NSManagedObject)
            words.remove(at: index)
            do {
                try context?.save()
            } catch  {
                print(error)
            }

        }



        } else {
            AlertBuilder(title: "Error", message: "Index out of range", preferredStyle: .alert)
            .addAction(title: "ok", style: .default)
            .build()
            .show(animated: true, completionHandler: nil)
            
        }
        
}
    
}

extension RecipeSearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
        return self.recipe?.hits.count ?? 0
        } else if tableView.tag == 2 {
            
            return words.count
        }
        
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipe") as! RecipeTableViewCell
        
        cell.configure(item: (recipe?.hits[indexPath.row])!)
            
            return cell

        } else if tableView.tag == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Suggest", for: indexPath) as! SuggestCellTableViewCell
            
            cell.word.text = words[words.count - indexPath.row - 1].word
            
            return cell
        }
        
     return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

        UIView.animate(
            withDuration: 0.3,
            delay: 0.01 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        if tableView.tag == 1 {
        if indexPath.row == ((recipe?.hits.count)! - 1) {
            if recipe!.more {
            let startindex = recipe?.hits.count
                endIndex = startindex! + 10
                if endIndex <= 100 {
                    sendRequest(from: startIndex, to: endIndex, searchText: recipe?.q ?? "")
                }
              }
    }
        }
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 1 {
        
        return UITableView.automaticDimension
            
        } else if tableView.tag == 2 {
            
            return 50
        }
        
        return CGFloat()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GoToDetails") as! ReciepeDetails
        
        vc.hits = recipe?.hits[indexPath.row]
         self.navigationController?.pushViewController(vc, animated: true)
            
        } else if tableView.tag == 2 {
            
            let str = words[words.count - indexPath.row - 1].word!
            
             deleteWord(index: words.count - indexPath.row - 1)

            
            save(word: str )


            
            sendRequest(from: 0, to: 10, searchText: str)
            

        }
        
    }
}
