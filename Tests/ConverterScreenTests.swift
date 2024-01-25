import XCTest
@testable import CurrencyConverter

final class ConverterScreenTests: XCTestCase {
    
    var sut: ConverterScreen!

    override func setUp() {
        super.setUp()
        sut = ConverterScreen()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func flagShouldBeString() {
        let sut = ConverterScreen()
        let bool = sut.flag(country: "aaa")
    }
}
