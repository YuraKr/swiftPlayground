//
//  Observable.swift
//  ReactiveSwift
//
//  Created by Yury on 02.06.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit


public class Operation {
    public typealias Closure = () -> ()
}

public class Result<T> {
    public typealias ResultClosure = (_ value: T) -> Void
}

public class Converteroperation<From, To> {
    public typealias Closure = (_ value: From) -> To
}


public class ObserveOperation<T> {
    
    public typealias OperationClosure = (_ completed: @escaping Result<T>.ResultClosure)->(Void)
    
    private let operationClosure  : OperationClosure
    
    fileprivate init(action: @escaping OperationClosure){
        operationClosure = action
    }
    
    public static func create(action: @escaping OperationClosure) -> ObserveOperation {
        return ObserveOperation(action:  action)
    }
    
    public func call(comp: @escaping Result<T>.ResultClosure){
        operationClosure(comp)
    }
    
    public func after(comp: @escaping Result<T>.ResultClosure) -> ObserveOperation<T>{
        let op = ObserveOperation<T>.create { (result) -> (Void) in
            
            self.call(comp: { (value: T) in
                comp(value)
                result(value)
            })
        }
        
        return op
    }
    
    
    public func map<To>(conv: @escaping Converteroperation<T,To>.Closure) -> ObserveOperation<To>{
        
        let op = ObserveOperation<To>.create { (result) -> (Void) in
            
            self.call(comp: { (value) in
                
                let res:To = conv(value)
                result(res)
            })
        }
        
        return op
    }
}


public class Observer<T>
{
    public static func create<O>(operation: ObserveOperation<O>) -> Observer<O> {
        return Observer<O>(operation: operation)
    }
    
    let observableOperation:ObserveOperation<T>
    
    fileprivate init(operation: ObserveOperation<T>){
        observableOperation = operation
    }
    
    
    func observe(_ closure: @escaping Result<T>.ResultClosure) {
        observableOperation.call(comp: closure)
    }
    
//    func map<T, To>(converter: Converter<T, To>) -> Observer<T1>{
//        let op =
//        
//        Observer<To>.create(operation: <#T##ObserveOperation<O>#>)
//    }
    
}
