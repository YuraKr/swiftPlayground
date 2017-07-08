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
            
            it("after oserver", closure: {
                
                let asyncResult = "1"
                
                var result = ""
                
                ObserveOperation<String>.create(action: { (completed) -> (Void) in
                    completed(asyncResult)
                }).after(comp: { (res) in
                    result += "after1 \(res);"
                }).after(comp: { (res) in
                    result += "after2 \(res);"
                }).call(comp: { (res:String) in
                    result += "call \(res);"
                })
                
                expect(result).to(equal("after1 1;after2 1;call 1;"))
            })
            
            it("simple oserver", closure: {
                
                let param: Int = 1
                var result = ""
                
                ObserveOperation<Int>.create(action: { (completed) -> (Void) in
                    completed(param)
                }).map(conv: { (val:Int) -> String in
                    return String(val)
                }).call(comp: { (res:String) in
                    result += res
                })
                
                expect(result).to(equal("1"))
                
                
            })
            
        }
    }
}
