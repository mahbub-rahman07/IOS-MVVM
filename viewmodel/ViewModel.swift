//
//  ViewModel.swift
//  MVVM
//
//  Created by Mahbub on 17/6/22.
//

import Foundation

struct ViewModel {
    
    let BASE_URL = "https://jsonplaceholder.typicode.com/"
    
    
    private var delegate: ResponseDelegate?
    private let repo = Repository()
    var observer = Observable<ResponseHandler<User>>()
    
    init(_ delegate: ResponseDelegate) {
        self.delegate = delegate
    }
    
    func loadData(presenter: @escaping (ResponseHandler<User>)->())  {
        let endPoint = URL(string :"\(BASE_URL)posts")
        presenter(ResponseHandler<User>.loading)

    
        URLSession.shared.dataTask(with: endPoint!) { data, response, error in
        
            if(error != nil) {
                print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: error?.localizedDescription))")
                DispatchQueue.main.async {
                    presenter(ResponseHandler.error(message: "Failed to fetch data"))
                }
                return
            }
        
            do {
                let result = try JSONDecoder().decode(Users.self, from: data!)
                print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: result[0]))")
                DispatchQueue.main.async {
                    presenter(ResponseHandler.success(result[0]))
                }
                
            }catch {
                print(error)
            }
        }.resume()
        
    }
    
    func loadData()  {
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
    func loadDataWithRepo()  {
        repo.loadData(delegate: self.delegate)
    }
    
    func loadDataWithObserver()  {
        repo.loadData(observer: self.observer)
    }
}
