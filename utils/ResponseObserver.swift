//
//  ResponseObserver.swift
//  MVVM
//
//  Created by Mahbub on 18/6/22.
//

import Foundation

protocol ResponseDelegate{
    func onChange(response: ResponseHandler<Any>)
}


enum ResponseHandler<Model> :Equatable{
    static func == (lhs: ResponseHandler<Model>, rhs: ResponseHandler<Model>) -> Bool {
        switch (lhs, rhs) {
           case (let .success(lhsString), let .success(rhsString)):
            return String(describing: lhsString.self) == String(describing: rhsString.self)

           case (let .error(msg1),let .error(msg2)):
               return msg1 == msg2
           default:
               return false
           }
    }
   
    case error(message: String)
    case loading
    case success(Model)
    case empty

}


class Observable<T: Equatable> {
  private let thread : DispatchQueue
  var property : T? {
    willSet(newValue) {
      if let newValue = newValue,  property != newValue {
          thread.async {
            self.observe?(newValue)
          }
      }
   }
  }
 var observe : ((T) -> ())?
 init(_ value: T? = nil, thread dispatcherThread: DispatchQueue = DispatchQueue.main) {
    self.thread = dispatcherThread
    self.property = value
 }
}
