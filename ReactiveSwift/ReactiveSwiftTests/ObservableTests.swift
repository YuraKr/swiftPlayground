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
                let _ = Operation<Void>.create(action: { (completed) -> (Void) in
                    completed()
                })
                
                let _ = Operation<String>.create(action: { (completed) -> (Void) in
                    completed("1")
                })
                
                let _ = Operation<(name: String, id:Int)>.create(action: { (completed) -> (Void) in
                    completed( (name: "1", id: 1) )
                })
                
                let _ = Operation<(name: String, id:Int, delete: Bool)>.create(action: { (completed) -> (Void) in
                    completed( (name: "1", id: 1, delete:true) )
                })
            })
            
            it("should init operation and execute", closure: {
                
                let signalCreator = Operation<String>.create(action: { (completed) -> (Void) in
                    completed("1")
                });
                
                
                var result = ""
                signalCreator.exec(result: { (value) in
                    result += value
                })
                
                expect(result).to(equal("1"))
                
            })
        }
    }
}
