import Quick
import Nimble



class ObservableTests: QuickSpec {

    override func spec() {
        
      
        // Операция - это цепочка действий для получение результата
        // Создание операции - это связывание данных с сообщением результата
        // Завершение операции - это событие для наблюдателей (если они есть)
        
        describe("Operation<T>") {
            it("create observe operation", closure: {
                // создание операции
                let _ = ObserveOperation<Void>.create(action: { (completed) -> (Void) in
                    try completed()
                })
                
                let _ = ObserveOperation<String>.create(action: { (completed) -> (Void) in
                    try completed("1")
                })
                
                let _ = ObserveOperation<(result: String?, error:NSError?)>.create(action: { (completed) -> (Void) in
                    try completed( (result: "1", error: nil ) )
                    try completed( (result: nil, error: NSError() ) )
                })
            })
            
            it("full specification", closure: {
                
                var log = ""
                let op = ObserveOperation<Int>.create() { (completion) -> (Void) in
                    log+="operationresult;"
                    try completion(1)
                }.after(){ (res:Int) in
                    log+="after;"
                }.map() { (value:Int) -> String in
                    log+="convert;"
                    return String(value)
                }
                
                try! op.call() { (res:String) in
                    log += "res \(res);"
                }
                
                expect(log).to(equal("operationresult;after;convert;res 1;"))
            })
            
            
            it("after, oserve operation value", closure: {
                
                let asyncResult = "1"
                
                var result = ""
                
                try! ObserveOperation<String>.create(action: { (completed) -> (Void) in
                    try completed(asyncResult)
                }).after() { (res) in
                    result += "after1 \(res);"
                }.after() { (res) in
                    result += "after2 \(res);"
                }.call() { (res:String) in
                    result += "call \(res);"
                }
                
                expect(result).to(equal("after1 1;after2 1;call 1;"))
            })
            
            context("map", {
                it("convert from type to type", closure: {
                    
                    let param: Int = 1
                    var result = ""
                    
                    try! ObserveOperation<Int>.create(action: { (completed) -> (Void) in
                        try completed(param)
                    }).map(){ (val:Int) -> String in
                        return String(val)
                    }.call() { (res:String) in
                        result += res
                    }
                    
                    expect(result).to(equal("1"))
                })
                
                it("map, update value", closure: {
                    
                    let param: String = "test"
                    var result = ""
                    
                    try! ObserveOperation<String>.create(action: { (completed) -> (Void) in
                        try completed(param)
                    }).map() { (val:String) -> String in
                        return val.uppercased()
                    }.call() { (res:String) in
                        result += res
                    }
                    
                    expect(result).to(equal("TEST"))
                })
            })
            
            
            context("catch", {
                
                it("catch, no error", closure: {
                    
                    var result = ""
                    
                    try! ObserveOperation<String>.create(action: { (completed) -> (Void) in
                        try completed("result")
                    }).Catch() {(error) in
                        result += "error2"
                    }.call() { (res:String) in
                        result += res
                    }
                    
                    expect(result).to(equal("result"))
                })
                
                it("catch, operation error", closure: {
                    
                    var result = ""
                    
                    try! ObserveOperation<String>.create(action: { (completed) -> (Void) in
                        throw NSError()
                    }).Catch() { (error) in
                        result += "error"
                    }.call() { (res:String) in
                        result += res
                    }
                    
                    expect(result).to(equal("error"))
                })
                
                it("catch, handle all error", closure: {
                    
                    var result = ""
                    
                    try! ObserveOperation<String>.create() { (completed) -> (Void) in
                        try completed("test")
                    }.map() { (res:String) -> String in
                        throw NSError()
                    }.Catch {(error) in
                        result += "catch"
                    }.call() { (res:String) in
                        result += "result:\(res)"
                    }
                    
                    expect(result).to(equal("catch"))
                })
                
                context("CatchError", {
                    
                    enum MyError: Error {case MainError, OtherError}
                    enum OtherError: Error {case Fail}
                    
                    it("handle error", closure: {
                        
                        var result = ""
                        
                        try! ObserveOperation<String>.create() { (completed) -> (Void) in
                                try completed("test")
                        }.map() { (res:String) -> String in
                            throw MyError.MainError
                        }.CatchError(){ (error: MyError) in
                            result+="catch1"
                        }.call() { (res:String) in
                            result += "result:\(res)"
                        }
                        
                        expect(result).to(equal("catch1"))
                    })
                    
                    it("handle type error", closure: {
                        
                        var result = ""
                        
                        try! ObserveOperation<String>.create() { (completed) -> (Void) in
                            try completed("test")
                        }.map() { (res:String) -> String in
                            throw OtherError.Fail
                        }.CatchError(){ (error: MyError) in
                            result+="catch1"
                        }.CatchError(){ (error: OtherError) in
                            result+="catch2"
                        }.call() { (res:String) in
                            result += "result:\(res)"
                        }
                        
                        expect(result).to(equal("catch2"))
                    })
                    
                    it("handle all error", closure: {
                        
                        var result = ""
                        
                        try! ObserveOperation<String>.create() { (completed) -> (Void) in
                            try completed("test")
                        }.map() { (res:String) -> String in
                            throw NSError()
                        }.CatchError(){ (error: MyError) in
                            result+="catch1"
                        }.CatchError(){ (error: OtherError) in
                            result+="catch2"
                        }.Catch {(error) in
                            result+="catch"
                        }.call() { (res:String) in
                            result += "result:\(res)"
                        }
                        
                        expect(result).to(equal("catch"))
                    })

                })
                
                
                
            })
            
        }
    }
}
