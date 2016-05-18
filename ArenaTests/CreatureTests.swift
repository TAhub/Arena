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
	var otherCreature:Creature!
	var creatureArray:[Creature]!
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		creature = Creature(position: CGPointMake(100, 100), type: "testman")
		otherCreature = Creature(position: CGPointMake(105, 100), type: "testman")
		creatureArray = [creature, otherCreature]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testNoChangeAtRest()
	{
		creature.update(100)
		XCTAssertEqual(creature.position.x, 100)
		XCTAssertEqual(creature.position.y, 100)
		XCTAssertEqual(creature.health, 3)
	}
	
	//test misc things
	
	func testCollidePoint()
	{
		XCTAssertTrue(creature.collidePoint(CGPointMake(100, 100)))
		XCTAssertFalse(creature.collidePoint(CGPointMake(110, 100)))
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
	
	func testNoMoveIntoPerson()
	{
		creature.move(0)
		creature.update(1, creatureArray: creatureArray)
		XCTAssertEqual(creature.position.x, 100)
	}
	
	
	//take attack tests
	
	func testNoKnockbackIntoPerson()
	{
		creature.takeHit(0, direction: 0, knockback: 100, knockbackLength: 1, stun: 0)
		creature.update(1, creatureArray: creatureArray)
		XCTAssertEqual(creature.position.x, 100)
	}
	
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
	
	
	//attack tests
	
	func testAttackTimer()
	{
		//test to make sure that the attack timer starts at nil, is set to 0 when attacking, works its way up to 1, and then after a while returns to being nil
		XCTAssertNil(creature.attackTimer)
		creature.attack()
		XCTAssertNotNil(creature.attackTimer)
		XCTAssertEqual(creature.attackTimer ?? 999, 0)
		creature.update(0.1)
		XCTAssertNotNil(creature.attackTimer)
		XCTAssertGreaterThan(creature.attackTimer ?? 999, 0)
		XCTAssertLessThan(creature.attackTimer ?? 999, 1)
		creature.update(100)
		XCTAssertNil(creature.attackTimer)
	}
	
	func testAttackCooldown()
	{
		//test to make sure that attack cooldown starts at nil, is set to 0 when attack timer is over, works up to 1, and then returns to nil
		XCTAssertNil(creature.attackCooldown)
		creature.attack()
		XCTAssertNil(creature.attackCooldown)
		while creature.attackTimer != nil
		{
			creature.update(0.1)
		}
		XCTAssertNotNil(creature.attackCooldown)
		creature.update(100)
		XCTAssertNil(creature.attackCooldown)
	}
	
	func testAttackHitting()
	{
		creature.attack()
		creature.update(100, creatureArray: creatureArray)
		XCTAssertEqual(otherCreature.health, 2)
	}
	
	func testAttackOutOfRange()
	{
		otherCreature.move(0)
		otherCreature.update(10)
		creature.attack()
		creature.update(100, creatureArray: creatureArray)
		XCTAssertEqual(otherCreature.health, 3)
	}
	
	func testAttackOutOfArc()
	{
		otherCreature.move(CGFloat(M_PI))
		otherCreature.update(1.5)
		creature.attack()
		creature.update(100, creatureArray: creatureArray)
		XCTAssertEqual(otherCreature.health, 3)
	}
	
	func testNoAttackWhileStunned()
	{
		creature.takeHit(0, direction: 0, knockback: 0, knockbackLength: 0, stun: 1.0)
		creature.attack()
		XCTAssertNil(creature.attackTimer)
		creature.update(100)
		creature.attack()
		XCTAssertNotNil(creature.attackTimer)
	}
	
	func testNoAttackWhileAttacking()
	{
		creature.attack()
		creature.update(0.1)
		creature.attack()
		XCTAssertNotEqual(creature.attackTimer ?? 0, 0)
	}
	
	func testNoAttackWhileInCooldown()
	{
		creature.attack()
		while creature.attackCooldown == nil
		{
			creature.update(0.1)
		}
		creature.attack()
		XCTAssertNil(creature.attackTimer)
	}
	
	func testNoMovingWhileAttacking()
	{
		creature.attack()
		creature.move(0)
		creature.update(0.1)
		XCTAssertEqual(creature.position.x, 100)
	}
	
	func testNoMovingWhileCooldown()
	{
		creature.attack()
		while creature.attackCooldown == nil
		{
			creature.update(0.1)
		}
		creature.move(0)
		creature.update(0.1)
		XCTAssertEqual(creature.position.x, 100)
	}
}