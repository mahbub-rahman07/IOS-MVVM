//
//  Repository.swift
//  MVVM
//
//  Created by Mahbub on 18/6/22.
//

import Foundation


let BASE_URL = "https://jsonplaceholder.typicode.com/"

struct Repository{

    func loadData(delegate: ResponseDelegate?)  {
        let endPoint = URL(string :"\(BASE_URL)posts")
      
        delegate?.onChange(response: ResponseHandler.loading)

        URLSession.shared.dataTask(with: endPoint!) { data, response, error in
        
            if(error != nil) {
                print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: error?.localizedDescription))")
                
                DispatchQueue.main.async {
                    delegate?.onChange(response: ResponseHandler.error(message: String(describing:error?.localizedDescription)))
                }
               
                return
            }
        
            do {
                let result = try JSONDecoder().decode(Users.self, from: data!)
                print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: result[0]))")
                DispatchQueue.main.async {
                    delegate?.onChange(response: ResponseHandler.success(result[0]))
                }
                
            }catch {
                print(error)
            }
        }.resume()
    }
    func loadData(observer: Observable<ResponseHandler<User>>?)  {
        let endPoint = URL(string :"\(BASE_URL)posts")
      
        observer?.property =  ResponseHandler.loading

        URLSession.shared.dataTask(with: endPoint!) { data, response, error in
        
            if(error != nil) {
                print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: error?.localizedDescription))")
            
                observer?.property =  ResponseHandler.error(message: String(describing:error?.localizedDescription))
            
               
                return
            }
        
            do {
                let result = try JSONDecoder().decode(Users.self, from: data!)
                print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: result[0]))")
                
                observer?.property =  ResponseHandler.success(result[0])
                
                
            }catch {
                print(error)
            }
        }.resume()
        
    }
    
}
