//
//  CreatureTests.swift
//  Arena
//
//  Created by Theodore Abshire on 5/11/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import XCTest
@testable import Arena

class CreatureTests: XCTestCase {
	
	var creature:Creature!
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		creature = Creature(position: CGPointMake(100, 100), type: "testman")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	//test the movement system
	
	func testMoveParabolic()
	{
		//I don't know exactly WHAT the result will be, but I know you will be accelerating if you keep doing move overs
		creature.move(0)
		creature.update(0.5)
		let xSpeed1 = creature.position.x - 100
		let oldX = creature.position.x
		creature.move(0)
		creature.update(0.5)
		let xSpeed2 = creature.position.x - oldX
		XCTAssertGreaterThan(xSpeed2, xSpeed1)
	}
	
	func testMoveMaxSpeed()
	{
		//I don't know what the max speed will be, just that I want one, and that 100 seconds is probably way over any kind of reasonable max
		creature.move(0)
		creature.update(100.0)
		let oldX1 = creature.position.x
		creature.move(0)
		creature.update(1.0)
		let oldX2 = creature.position.x
		creature.move(0)
		creature.update(1.0)
		XCTAssertEqual(creature.position.x - oldX2, oldX2 - oldX1)
	}
	
	func testMoveDecel()
	{
		//again, I don't know how fast deceleration will be, just that I want it to happen
		creature.move(0)
		creature.update(100.0)
		let oldX1 = creature.position.x
		creature.move(0)
		creature.update(1.0)
		let oldX2 = creature.position.x
		creature.update(1.0)
		XCTAssertLessThan(creature.position.x - oldX2, oldX2 - oldX1)
	}
	
	func testMoveRight()
	{
		creature.move(0)
		creature.update(1)
		XCTAssertGreaterThan(creature.position.x, 100)
		XCTAssertEqual(creature.position.y, 100)
	}
	
	func testMoveUp()
	{
		creature.move(CGFloat(M_PI) / 2)
		creature.update(1)
		XCTAssertEqual(creature.position.x, 100)
		XCTAssertGreaterThan(creature.position.y, 100)
	}
	
	func testMoveLeft()
	{
		creature.move(CGFloat(M_PI))
		creature.update(1)
		XCTAssertLessThan(creature.position.x, 100)
		XCTAssertEqual(creature.position.y, 100)
	}
	
	func testMoveDown()
	{
		creature.move(3 * CGFloat(M_PI) / 2)
		creature.update(1)
		XCTAssertEqual(creature.position.x, 100)
		XCTAssertLessThan(creature.position.y, 100)
	}
	
	
	
	//take attack tests
	
	func testTakeDamage()
	{
		creature.takeHit(1, direction: 0, knockback: 0, knockbackLength: 0, stun: 0)
		XCTAssertEqual(creature.health, 2)
	}
	
	func testStun()
	{
		creature.takeHit(0, direction: 0, knockback: 0, knockbackLength: 0, stun: 1.0)
		creature.move(0)
		creature.update(1.0)
		XCTAssertEqual(creature.position.x, 100)
	}
	
	func testStunPartialMove()
	{
		creature.takeHit(0, direction: 0, knockback: 0, knockbackLength: 0, stun: 1.0)
		creature.move(0)
		creature.update(2.0)
		XCTAssertGreaterThan(creature.position.x, 100)
	}
	
	func testKnockback()
	{
		creature.takeHit(0, direction: 0, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		creature.update(1.0)
		XCTAssertGreaterThan(creature.position.x, 100)
	}
	
	func testKnockbackDuration()
	{
		creature.takeHit(0, direction: 0, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		creature.update(0.5)
		XCTAssertTrue(creature.position.x > 100)
		let oldX = creature.position.x
		creature.update(1.0)
		XCTAssertGreaterThan(creature.position.x, oldX)
	}
	
	func testKnockbackOverride()
	{
		creature.takeHit(0, direction: 0, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		creature.update(0.5)
		XCTAssertTrue(creature.position.x > 100)
		creature.takeHit(0, direction: CGFloat(M_PI) / 2, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		let oldX = creature.position.x
		creature.update(1.0)
		XCTAssertEqual(creature.position.x, oldX)
		XCTAssertGreaterThan(creature.position.y, 100)
	}
	
	func testKnockbackCancelsMove()
	{
		creature.move(0)
		creature.update(100)
		let oldX = creature.position.x
		creature.takeHit(0, direction: CGFloat(M_PI) / 2, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		creature.update(1.0)
		XCTAssertEqual(creature.position.x, oldX)
	}
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
}