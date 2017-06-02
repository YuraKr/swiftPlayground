//
//  Observable.swift
//  ReactiveSwift
//
//  Created by Yury on 02.06.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit


public class OperationResult<T>{
    public typealias ResultClosure = (_ result: T) -> Void
    
    let resultAction:ResultClosure
    
    
    init(_ resultClosure:@escaping ResultClosure) {
        resultAction = resultClosure
    }
    
    func result(result: T){
        resultAction(result);
    }
}

public class Observable<T> {
    public typealias Action = (_ result: OperationResult<T>)->(Void)
    let observableAction :Action
    let observableResult :OperationResult<T>
    
    
    public init(action: @escaping Action, result: OperationResult<T>) {
        observableAction = action
        observableResult = result
    }
    
    func notify(){
        observableAction(observableResult)
    }
    
    static func createObserverable<T>(action: @escaping Observable<T>.Action, result: @escaping OperationResult<T>.ResultClosure) -> Observable<T> {
        
        let resultObserver = OperationResult<T>(result)
        
        let oserver = Observable<T>(action: action, result: resultObserver)
        return oserver
    }
}
