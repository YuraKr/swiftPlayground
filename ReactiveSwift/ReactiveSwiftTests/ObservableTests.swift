import Quick
import Nimble

class ObservableTests: QuickSpec {

    override func spec() {
        
      
        // Операция - это получение результата
        // Создание операции - это связывание данных с сообщением результата
        // Завершение операции - это событие для наблюдателей (если они есть)
        
        describe("Operation<T>") {
            it("should init and execute", closure: {
                
                // создание операции
                let _ = ObserverOperation<Void>.create(action: { (completed) -> (Void) in
                    completed()
                })
                
                let _ = ObserverOperation<String>.create(action: { (completed) -> (Void) in
                    completed("1")
                })
                
                let _ = ObserverOperation<(name: String, id:Int)>.create(action: { (completed) -> (Void) in
                    completed( (name: "1", id: 1) )
                })
                
                let _ = ObserverOperation<(name: String, id:Int, delete: Bool)>.create(action: { (completed) -> (Void) in
                    completed( (name: "1", id: 1, delete:true) )
                })
            })
            
            it("subscribe", closure: {
                
                var result = ""
                
                ObserverOperation<String>.create(action: { (completed) -> (Void) in
                    completed("1")
                    completed("2")
                }).subscribe(resultObserver: { (value) in
                    result += value
                })
                
                expect(result).to(equal("12"))
                
            })
            
            it("next", closure: {
                
                var result = ""
                
                ObserverOperation<String>.create(action: { (completed) -> (Void) in
                    completed("1")
                }).next(resultObserver: { (value) in
                    result += value
                }).subscribe(resultObserver: { (value) in
                    result += value
                })
                
                expect(result).to(equal("11"))
                
            })
            
        }
    }
}
