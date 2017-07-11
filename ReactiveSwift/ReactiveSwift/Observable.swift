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

public class Operation<T> {
    public typealias Closure = () throws ->()

//    public typealias Closure = (_ completed: @escaping Result<T>.ResultClosure) throws ->(Void)
    public typealias ThrowClosure = (_ completed: @escaping Result<T>.ResultThrowClosure) throws ->(Void)
}

public class Result<T> {
    //public typealias ResultClosure = (_ value: T) -> Void
    public typealias ResultThrowClosure = (_ value: T) throws -> Void
}

public class ConvertOperation<From, To> {
    public typealias Closure = (_ value: From) throws -> To
}

public class ErrorHandler<T> {
    public typealias Closure = (_ error:T)->()
}

public class ObserveOperation<T> {
    
    private let operationClosure  : Operation<T>.ThrowClosure
    
    
    public static func create(action: @escaping Operation<T>.ThrowClosure) -> ObserveOperation {
        return ObserveOperation(action:  action)
    }
    
    fileprivate init(action: @escaping Operation<T>.ThrowClosure){
        operationClosure = action
    }
    
    public func call(_ comp: @escaping Result<T>.ResultThrowClosure) throws {
        try operationClosure(comp)
    }
    
    public func after(_ comp: @escaping Result<T>.ResultThrowClosure) -> ObserveOperation<T>{
        let op = ObserveOperation<T>.create { (result) -> (Void) in
            
            try self.operationClosure(){ (value: T) in
                try comp(value)
                try result(value)
            }
        }
        
        return op
    }
    
    public func map<To>(_ conv: @escaping ConvertOperation<T,To>.Closure) -> ObserveOperation<To>{
        
        let op = ObserveOperation<To>.create { (result) -> (Void) in
            
            try self.call(){ (value: T) in
                let res:To = try conv(value)
                try result(res)
            }
        }
        
        return op
    }
    
    // Error handling
    
    public func CatchError<ErrorType>(_ errorHandler: @escaping ErrorHandler<ErrorType>.Closure) -> ObserveOperation<T>{
        
        let op = ObserveOperation<T>.create { (result) -> (Void)  in
            do {
                try self.operationClosure(result)
            } catch let error as ErrorType {
                errorHandler(error)
            }
        }
        
        return op
    }
    
    public func Catch(_ errorHandler: @escaping ErrorHandler<Error>.Closure) -> ObserveOperation<T>{
        let op = ObserveOperation<T>.create { (result) -> (Void)  in
            
            do{
                try self.operationClosure(result)
            } catch {
                errorHandler(error)
            }
        }
        
        return op
    }
}
