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
                        try completed(param)
                    }).map(conv: { (val:String) -> String in
                        return val.uppercased()
                    }).call() { (res:String) in
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
                    }).Catch() {
                        result += "error1"
                    }.Catch() {
                        result += "error2"
                    }.call() { (res:String) in
                        result += res
                    }
                    
                    expect(result).to(equal("result"))
                })
                
                it("catch, error map", closure: {
                    
                    var result = ""
                    
                    let op = ObserveOperation<String>.create() { (completed) -> (Void) in
                        try completed("test")
                    }.Catch() {
                        result += "error2"
                    }.map() { (res:String) -> String in
                        return res
                    }.map() { (res:String) -> String in
                        return res
                    }.map() { (res:String) -> String in
                        expect(res).to(equal("test"))
                        throw NSError()
                    }.Catch() {
                        result += "error2"
                    }
                    
                    try? op.call() { (res:String) in
                        expect(res).to(equal("TEST"))
                        result += "result:\(res)"
                    }
                    
                    expect(result).to(equal("error2"))
                })
                
            })
            
        }
    }
}
