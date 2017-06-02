import Quick
import Nimble

class ObservableTests: QuickSpec {
    
    func operation(_ date: Date) -> String {
        return date.description
    }
    
    func asyncOperation(_ date: Date,_ asyncComplete:@escaping (String) -> (Void)  ) {
        let date = Date()
        
        DispatchQueue.main.async {
            let res = self.operation(date)
            asyncComplete(res)
        }
    }

    override func spec() {
        
        it("async test") {
            
            let observable = Observable<String>.createObserverable(action: { (res: OperationResult<String>) -> (Void) in
                
                let date = Date()
                self.asyncOperation(date, { (asyncResult) -> (Void) in
                    res.result(result: asyncResult)
                })
                
            }, result: { (data:String) in
                print("sucess")
            })
            
            observable.notify()
        }
        
        it("sync test") {
            
            let observable = Observable<String>.createObserverable(action: { (res: OperationResult<String>) -> (Void) in
                
                let date = Date()
                let strData = self.operation(date)
                res.result(result: strData)
                
            }, result: { (data:String) in
                print("success")
            })
            
            observable.notify()
        }
        
        it("sync 2 parameters test") {
            
            let observable = Observable<(Date, String)>.createObserverable(action: { (res: OperationResult<(Date, String)>) -> (Void) in
                
                let date = Date()
                let strData = self.operation(date)
                res.result(result: (date, strData))
                
            }, result: { (data:(value: Date, string: String)) in
                print("sucess " + data.value.description)
                print("sucess " + data.string.description)
            })
            
            observable.notify()
        }
    }
}
