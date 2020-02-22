//
//  ApiRequest.swift
//  SoftExpert
//
//  Created by Mahmoud helmy on 2/19/20.
//

import Foundation
import Alamofire

class RecipeRequest {
    
    let app_id = "d6a6b0f8"
    let app_key = "0eb203172669e0f273c5a441c6eb321c"
    
    var manager = SessionManager()
    
//    init(requestTimeout : Double = 30) {
//          manager = self.getAlamofireManager(timeout: requestTimeout)
//      }
//
//       func getAlamofireManager(timeout : Double) -> SessionManager  {
//
//          let serverTrustPolicies: [String: ServerTrustPolicy] = [
//              "Softexpert.app": .disableEvaluation
//          ]
//          let configuration = URLSessionConfiguration.default
//          configuration.timeoutIntervalForResource = timeout
//          configuration.timeoutIntervalForRequest = timeout
//          configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
//          let alamofireManager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
//          return alamofireManager
//      }
      

    var networkhandler = NetworkHandler()
  
       
    static let instance = RecipeRequest()
    
    

    func getRecipe(searchText:String, from:Int,to:Int, completionHandler: @escaping (RecipeModel?, ErrorModel?) -> ()) {
        
    
        
        let header = [
                    "Content-Type":"application/x-www-form-urlencoded"
                  

                ]
        
        let url = "https://api.edamam.com/search?q=\(searchText)&app_id=\(app_id)&app_key=\(app_key)&from=\(from)&to=\(to)"

        print(url)
        
        self.manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            self.networkhandler.getResponse(response: response, DataModel: "Re") { (data, error) in
                completionHandler(data, error)
            }
        }
    }
}
