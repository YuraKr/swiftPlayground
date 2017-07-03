//
//  Observable.swift
//  ReactiveSwift
//
//  Created by Yury on 02.06.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit



public class ObserverOperation<T> {
    
    public typealias OperationClosure = (_ completed: @escaping CompletionClosure)->(Void)
    public typealias CompletionClosure = (_ value: T) -> Void
    
    private var operationClosure  : OperationClosure
    
    public static func create(action: @escaping OperationClosure) -> ObserverOperation {
        return ObserverOperation(action:  action)
    }
    
    fileprivate init(action: @escaping OperationClosure){
        operationClosure = action
    }

    public func next(resultObserver: @escaping CompletionClosure) -> ObserverOperation{
        
        
        let baseoperation = operationClosure
        
        let operation = ObserverOperation<T>.create { (completed) -> (Void) in
            
            let newCompletion  = { (value: T) -> Void in
                resultObserver(value)
                completed(value)
            }
            
            baseoperation(newCompletion)
        }
        
        return operation
    }
    
    public func subscribe(resultObserver: @escaping CompletionClosure){
        operationClosure(resultObserver)
    }
}
