//
//  Observable.swift
//  ReactiveSwift
//
//  Created by Yury on 02.06.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit


enum ReactiveResult {
    case Success
    case Error(error: Error)
}

public class Operation {
    public typealias Closure = () -> ()
}

public class Result<T> {
    public typealias ResultClosure = (_ value: T) -> Void
}

public class Converteroperation<From, To> {
    public typealias Closure = (_ value: From) -> To
}

public class Error {
    public typealias Closure = ()->()
}


public class ObserveOperation<T> {
    
    public typealias OperationClosure = (_ completed: @escaping Result<T>.ResultClosure) throws ->(Void)
    
    private let operationClosure  : OperationClosure
    
    
    
    public static func create(action: @escaping OperationClosure) -> ObserveOperation {
        return ObserveOperation(action:  action)
    }
    
    fileprivate init(action: @escaping OperationClosure){
        operationClosure = action
    }
    
    public func call(_ comp: @escaping Result<T>.ResultClosure) throws {
        callWithCatch(comp) { 
            print("Unhandled error")
        }
    }
    
    public func callWithCatch(_ comp: @escaping Result<T>.ResultClosure, _ errorHandler: @escaping Error.Closure) {
        do{
        try operationClosure(comp)
        } catch {
            errorHandler()
        }
    }
    
    public func after(_ comp: @escaping Result<T>.ResultClosure) -> ObserveOperation<T>{
        let op = ObserveOperation<T>.create { (result) -> (Void) in
            
            try self.call(){ (value: T) in
                comp(value)
                result(value)
            }
        }
        
        return op
    }
    
    public func withCatch(_ comp: @escaping Result<T>.ResultClosure, _ errorHandler: @escaping Error.Closure) -> ObserveOperation<T>{
        let op = ObserveOperation<T>.create { (result) -> (Void)  in
                
                self.callWithCatch({ (value: T) in
                    comp(value)
                    result(value)
                }, errorHandler)
            
        }
        
        return op
    }
    
    public func map<To>(conv: @escaping Converteroperation<T,To>.Closure) -> ObserveOperation<To>{
        
        let op = ObserveOperation<To>.create { (result) -> (Void) in
            
            try self.call(){ (value) in
                
                let res:To = conv(value)
                result(res)
            }
        }
        
        return op
    }
}
