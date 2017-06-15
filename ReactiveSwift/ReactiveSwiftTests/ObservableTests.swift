import Quick
import Nimble

class ObservableTests: QuickSpec {

    override func spec() {
        
//        describe("Operation<T>") {
//            it("should init and execute ", closure: {
//                
//                var result = ""
//                var sequence = ""
//                
//                let _ = Operation<String>.create(action: { (completed) -> (Void) in
//                    sequence += "1"
//                    completed("complete")
//                    sequence += "3"
//                }).observe({ (val) in
//                    sequence += "2"
//                    result = val
//                }).exec()
//                
//                expect(result).to(equal("complete"))
//                expect(sequence).to(equal("123"))
//               
//            })
//        }
        
        describe("Operation<T>") {
            it("should init and execute ", closure: {
                
                var result = ""
                var sequence = ""
                
                let _ = Operation<String>.create(action: { (completed) -> (Void) in
                    sequence += "1"
                    completed("complete")
                    sequence += "4"
                }).observe({ (val) in
                    sequence += "2"
                }).observe({ (val) in
                    sequence += "3"
                    result = val
                }).exec()
                
                expect(result).to(equal("complete"))
                expect(sequence).to(equal("1234"))
                
            })
        }
    }
}
