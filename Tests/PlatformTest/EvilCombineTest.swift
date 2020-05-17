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
            wait1(a, for: 3, until: { m in m == 222 })
        }
    }
}

/// Returns all collected outputs until `check` returns `true`.
private func wait1<P:Publisher>(_ p:P, for d: TimeInterval, until check:@escaping(P.Output) -> Bool) {
    let fin = DispatchSemaphore(value: 0)
    let a = p.sink(receiveCompletion: { _ in },
    receiveValue: { _ in fin.signal() })
    noop(a)
    fin.wait()
    /// I don't know why, but without this, program is likely crash on many quick repetition.
    /// See `WaitTest.swift` to reproduce the crash without this sync.
    /// - It has to be `recvq`. Other queues doesn't work.
    /// - It seems this somehow prolongs the lifetime of pipeline and that avoided the crash.
//    Thread.sleep(forTimeInterval: 0.001)
}
