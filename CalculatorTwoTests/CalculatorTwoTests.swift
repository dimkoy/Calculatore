//
//  CalculatorTwoTests.swift
//  CalculatorTwoTests
//
//  Created by Dmitriy on 06/10/2016.
//  Copyright © 2016 Dmitriy. All rights reserved.
//

import XCTest
@testable import CalculatorTwo

class CalculatorTwoTests: XCTestCase {
    
    func testDescription() {
        
        // a. touching 7 + would show "7 + ..." (with 7 still in the display)
        let brain = CalculatorBrain()
        brain.setOperand(operand: 7)
        brain.performOperand(symbol: "+")
        XCTAssertEqual(brain.description, "7 + ")
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.result, 7.0)
        
        // b. 7 + 9 would show "7 + ..." (9 in the display)
        //brain.setOperand(operand: 9) // entered but not pushed to model
        XCTAssertEqual(brain.description, "7 + ")
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.result, 7.0)
        
        // c. 7 + 9 = would show "7 + 9 =" (with 16 still in the display)
        brain.setOperand(operand: 9)
        brain.performOperand(symbol: "=")
        XCTAssertEqual(brain.description, "7 + 9")
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.result, 16.0)
        
        // d. 7 + 9 = √ would show "√(7 + 9) =" (with 4 still in the display)
        brain.performOperand(symbol: "√")
        XCTAssertEqual(brain.description, "√(7 + 9)")
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.result, 4.0)
        
        
    }
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
