import Quick
import Nimble



class ObservableTests: QuickSpec {

    override func spec() {
        
      
        // Операция - это получение результата
        // Создание операции - это связывание данных с сообщением результата
        // Завершение операции - это событие для наблюдателей (если они есть)
        
        describe("Operation<T>") {
            it("create operation", closure: {
                // создание операции
                let _ = ObserveOperation<Void>.create(action: { (completed) -> (Void) in
                    completed()
                })
                
                let _ = ObserveOperation<String>.create(action: { (completed) -> (Void) in
                    completed("1")
                })
                
                let _ = ObserveOperation<(result: String?, error:NSError?)>.create(action: { (completed) -> (Void) in
                    completed( (result: "1", error: nil ) )
                    completed( (result: nil, error: NSError() ) )
                })
            })
            
            it("after, oserve operation value", closure: {
                
                let asyncResult = "1"
                
                var result = ""
                
                try! ObserveOperation<String>.create(action: { (completed) -> (Void) in
                    completed(asyncResult)
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
                        completed(param)
                    }).map(conv: { (val:Int) -> String in
                        return String(val)
                    }).call() { (res:String) in
                        result += res
                    }
                    
                    expect(result).to(equal("1"))
                })
                
                it("map, update value", closure: {
                    
                    let param: String = "test"
                    var result = ""
                    
                    try! ObserveOperation<String>.create(action: { (completed) -> (Void) in
                        completed(param)
                    }).map(conv: { (val:String) -> String in
                        return val.uppercased()
                    }).call() { (res:String) in
                        result += res
                    }
                    
                    expect(result).to(equal("TEST"))
                })
            })
            
            
            context("catch", {
                it("catch all", closure: {
                    
                    
                    
                    
                    var result = ""
                    
                    try! ObserveOperation<String>.create(action: { (completed) -> (Void) in
                        throw NSError()
                    }).withCatch({ (val: String) in
                       result += "val"
                    }, { 
                       result += "error"
                    }).call() { (res:String) in
                        result += res
                    }
                    
                    expect(result).to(equal("error"))
                })
            })
            
        }
    }
}
