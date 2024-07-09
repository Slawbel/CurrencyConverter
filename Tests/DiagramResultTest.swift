import XCTest
import SnapKit

final class TestDiagramResult: XCTestCase {
    var sut: DiagramResult!
    
    override func setUp() {
        super.setUp()
        sut = DiagramResult(nibName: nil, bundle: nil)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testChartViewIsNotNil() {
        XCTAssertNotNil(sut.chartView)
    }
    
    func testChartViewIsSubview() {
        XCTAssertTrue(sut.chartView.isDescendant(of: sut.view))
    }
    
    func testChartViewConstraints() {
        sut.view.layoutIfNeeded()
        let constraints = sut.chartView.constraints
        XCTAssertEqual(constraints.count, 4, "Shouldhave 4 constraints installed")
        XCTAssertTrue(constraints.count == 4)
        
        XCTAssertTrue(constraints.allSatisfy { $0.firstItem === sut.chartView && $0.secondItem === sut.diagramStackView})
        XCTAssertNotNil(constraints.first { $0.firstAttribute == .leading && $0.secondAttribute == .leading && $0.constant == 20})
        XCTAssertNotNil(constraints.first { $0.firstAttribute == .trailing && $0.secondAttribute == .trailing && $0.constant == 20})
        XCTAssertNotNil(constraints.first { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom && $0.constant == 45})
        XCTAssertNotNil(constraints.first { $0.firstAttribute == .height && $0.constant == 540})
    }
}
