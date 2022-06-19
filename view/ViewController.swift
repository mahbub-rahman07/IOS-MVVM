//
//  ViewController.swift
//  MVVM
//
//  Created by Mahbub on 17/6/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userId: UILabel!

    private lazy var viewModel = ViewModel(self)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadDataWithDelegate()
        
       // viewModel.loadData()
//        viewModel.loadDataWithRepo()
        
       // self.setObservers()
        observeNow()
        viewModel.loadDataWithObserver()
    
    }

    func loadDataWithDelegate() {
                viewModel.loadData() {
                    data in
                    self.setView(response: data)
                }
    }
    func observeNow(){
        viewModel.observer.observe = { response in
            self.setView(response: response)
        }
    }
    
    func setView(response: ResponseHandler<User>)  {
        switch(response){
        case.loading:
            print("data is loading....")
            self.userId.text = "data is loading...."
            break
        case .error(let msg):
            print (msg)
            self.userId.text = msg
            break
        case .success(let user):
            print("in view \n \(user.id)")
            self.userId.text = "user id: \(user.id)"
            break
        case .empty:
            break
        }
    }
}

extension ViewController: ResponseDelegate {
    func onChange(response: ResponseHandler<Any>) {
        switch(response){
        case.loading:
            print("data is loading....")
            self.userId.text = "data is loading...."
            break
        case .error(let msg):
            print (msg)
            self.userId.text = msg
            break
        case .success(let user):
            if user is User {
                print("in view \n \((user as! User).id)")
                self.userId.text = "user id: \((user as! User).id)"
            }
            break
        case .empty:
            break
        }
    }
}

fileprivate extension ViewController {
   func setObservers() {
     viewModel.observer.observe = { response in
         self.setView(response: response)
     }
   }
}
