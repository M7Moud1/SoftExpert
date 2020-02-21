



import Foundation
import Alamofire

public final class NetworkHandler {

    
  //  private var manager: SessionManager!
    
  
    
    private func verifyRequest(response : DataResponse<Any>) -> ErrorModel? {
        let errorModel = ErrorModel()
        if let _ = response.error , (response.error as NSError?)?.code == -999 {
            errorModel._code = -999
            errorModel._message = "cancelled"
            return errorModel
        }
        
        if let _ = response.error, (response.error as NSError?)?.code == -1009 {
            errorModel._code = -1009
            errorModel._message = "No internet connection"
            return errorModel
        }
        
        if let _ = response.error, (response.error as NSError?)?.code == -1001 {
            
            errorModel._code = -1001
            errorModel._message = "Request time out"
            return errorModel
        }
        
        guard let _ = response.response, let _ = response.value else {
            errorModel._code = 0
            errorModel._message = "Unknown server error"
            return errorModel
        }
        
        guard let _ = response.data else {
            errorModel._code = 0
            errorModel._message = "Unknown server error"
            return errorModel
        }
        
        if case 500...511 = response.response!.statusCode {
            errorModel._code = 0
            errorModel._message = "Unknown server error"
            return errorModel
        }
        
        return nil
    }
    
    
    
    
    func getResponse<T : Codable>(response: DataResponse<Any> ,DataModel : String, completionHandler: @escaping (T?, ErrorModel?) -> ()) {
        
      
        var data : T?
      
            if response.result.isSuccess {
        
        do {
                data = try JSONDecoder().decode(T.self, from: response.data!)

        } catch  {
            
            print(error)
            completionHandler(data, nil)
        }
        
    } else {
   
        if let error = self.verifyRequest(response: response) {
                    
            print(response.error.debugDescription)
            completionHandler(nil , error)
            return
        }
    }
                
                //MARK :- Parse all headers
                guard let _ = response.response?.allHeaderFields as? [String:String] else {
                    let errorModel = ErrorModel()
                    errorModel._code = 0
                    errorModel._message = "Unknown server error"
                    completionHandler(nil , errorModel)
                    return
                }
                
                //MARK :- No Content request (I.E : Delete request)
                if response.response?.statusCode == 204 {
                   let errorModel = ErrorModel()
                    errorModel._code = 0
                    errorModel._message = "Unknown server error"
                        completionHandler(nil , errorModel)
                }
                
                
                
                
                //MARK:- Error Handler
                
                //MARK :- Safety Checks
                if response.response?.statusCode == 401 {
                    let errorModel = ErrorModel()
                    errorModel._code = 401
                    errorModel._message = "Unauthorized"
                   print(errorModel)
                    completionHandler(nil  , errorModel)

                    return
                }
                //MARK :- Handel Status = 0
                if response.response?.statusCode == 200 {
                    
                    let errorModel = ErrorModel()
                    errorModel._code = 401
                    completionHandler(data  , nil)
                    return
                }
                
                
                //MARK :- Automatic parsing mechanisim
                switch response.result {
                case .success :
                    
                    completionHandler(data , nil)
                
                case .failure(_):
                    break
        }
    }
}
