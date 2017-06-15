//
//  Observable.swift
//  ReactiveSwift
//
//  Created by Yury on 02.06.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit

public class Operation<T> {
    
    public typealias OperationClosure = (_ resultClosure: ResultClosure)->(Void)
    public typealias ResultClosure = (_ value: T) -> Void
    
    private let operationClosure : OperationClosure
    
    public static func create(action: @escaping OperationClosure) -> Operation {
        return Operation(action:  action)
    }
    
    
    fileprivate init(action: @escaping OperationClosure){
        self.operationClosure = action
    }
    
    public func observe(_ closure: @escaping Operation<T>.ResultClosure ) ->Observable<T> {
        return Observable<T>.create(action: self, result: closure);
    }
    
    public func exec(res: ResultClosure){
        self.operationClosure(res)
    }
}

public class Observable<T> {
    
    private var operation         : Operation<T>
    private var operationObserverClosure : Operation<T>.ResultClosure
    
    fileprivate init(action: Operation<T>, result: @escaping Operation<T>.ResultClosure){
        self.operation = action
        self.operationObserverClosure = result
    }
    
    public static func create(action: Operation<T>, result: @escaping Operation<T>.ResultClosure) -> Observable<T> {
        return Observable(action:  action, result: result)
    }
    
    public func observe(_ closure: @escaping Operation<T>.ResultClosure ) ->Observable<T> {
        
        let oper = Operation<T>.create { (resultClosure) -> (Void) in
            self.operation.exec(res: { (value) in
                self.operationObserverClosure(value)
            })
        }
        
        return Observable<T>.create(action: oper, result: closure);
    }
    
    public func exec(){
        self.operation.exec(res: self.operationObserverClosure)
    }
}
