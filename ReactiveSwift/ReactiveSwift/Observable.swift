//
//  Observable.swift
//  ReactiveSwift
//
//  Created by Yury on 02.06.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit



public class Operation<T> {
    
    public typealias OperationClosure = (_ completed: @escaping CompletionClosure)->(Void)
    public typealias CompletionClosure = (_ value: T) -> Void
    
    private var operationClosure  : OperationClosure
    
    public static func create(action: @escaping OperationClosure) -> Operation {
        return Operation(action:  action)
    }
    
    fileprivate init(action: @escaping OperationClosure){
        operationClosure = action
    }
    
    public func exec(result: @escaping CompletionClosure){
        operationClosure(result)
    }
    
    func after(action: @escaping CompletionClosure) -> Operation<T> {
        return self
    }
}
