import XCTest
import Combine

final class EvilCombineTest: XCTestCase {
    func test1() {
        for i in 0..<1_000_000 {
            print(i)
            let a = PassthroughSubject<Int,Never>()
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)) {
                a.send(111)
                a.send(completion: .finished)
            }
            wait1(a)
        }
    }
}

private func wait1<P:Publisher>(_ p:P) {
    let fin = DispatchSemaphore(value: 0)
    let a = p.sink(receiveCompletion: { _ in },
    receiveValue: { _ in fin.signal() })
    noop(a)
    fin.wait()
    /// Just run above test case. It crashed within 1000 iterations on my machine. (macOS 10.15.4, MacBook Pro (Retina, 13-inch, Late 2013))
    /// Uncomment following line to give a quick fix.
    /// I don't know why, but without this, program is likely crash on many quick repetition. 
//    Thread.sleep(forTimeInterval: 0.001)
}
