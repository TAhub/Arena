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
		XCTAssertEqual(creature.realPosition.x, 100)
		XCTAssertEqual(creature.realPosition.y, 100)
		XCTAssertEqual(creature.health, 3)
	}
	
	//MARK: misc tests
	
	func testCollidePoint()
	{
		XCTAssertTrue(creature.collidePoint(CGPointMake(100, 100)))
		XCTAssertFalse(creature.collidePoint(CGPointMake(110, 100)))
	}
	
	//MARK: turn system tests
	
	func testTurn()
	{
		creature.turn(CGFloat(M_PI))
		XCTAssertTrue(creature.spriteMirrored)
	}
	
	func testCannotTurnWhileAttacking()
	{
		creature.attack()
		creature.turn(CGFloat(M_PI))
		XCTAssertFalse(creature.spriteMirrored)
	}
	
	//MARK: movement system tests
	
	func testMoveParabolic()
	{
		//I don't know exactly WHAT the result will be, but I know you will be accelerating if you keep doing move overs
		creature.move(0)
		creature.update(0.1)
		let xSpeed1 = creature.realPosition.x - 100
		let oldX = creature.realPosition.x
		creature.move(0)
		creature.update(0.1)
		let xSpeed2 = creature.realPosition.x - oldX
		XCTAssertGreaterThan(xSpeed2, xSpeed1)
	}
	
	func testMoveMaxSpeed()
	{
		//I don't know what the max speed will be, just that I want one, and that 100 seconds is probably way over any kind of reasonable max
		creature.move(0)
		creature.update(100.0)
		let oldX1 = creature.realPosition.x
		creature.move(0)
		creature.update(1.0)
		let oldX2 = creature.realPosition.x
		creature.move(0)
		creature.update(1.0)
		XCTAssertEqual(creature.realPosition.x - oldX2, oldX2 - oldX1)
	}
	
	func testMoveDecel()
	{
		//again, I don't know how fast deceleration will be, just that I want it to happen
		creature.move(0)
		creature.update(100.0)
		let oldX1 = creature.realPosition.x
		creature.move(0)
		creature.update(1.0)
		let oldX2 = creature.realPosition.x
		creature.update(1.0)
		XCTAssertLessThan(creature.realPosition.x - oldX2, oldX2 - oldX1)
	}
	
	func testMoveRight()
	{
		creature.move(0)
		creature.update(0.2)
		XCTAssertGreaterThan(creature.realPosition.x, 100)
		XCTAssertEqual(creature.realPosition.y, 100)
		XCTAssertEqual(creature.angleSuffix, "_side")
		XCTAssertFalse(creature.spriteMirrored)
	}
	
	func testMoveUp()
	{
		creature.move(CGFloat(M_PI) / 2)
		creature.update(0.2)
		XCTAssertEqual(creature.realPosition.x, 100)
		XCTAssertGreaterThan(creature.realPosition.y, 100)
		XCTAssertEqual(creature.angleSuffix, "_back")
		XCTAssertFalse(creature.spriteMirrored)
	}
	
	func testMoveLeft()
	{
		creature.move(CGFloat(M_PI))
		creature.update(0.2)
		XCTAssertLessThan(creature.realPosition.x, 100)
		XCTAssertEqual(creature.realPosition.y, 100)
		XCTAssertEqual(creature.angleSuffix, "_side")
		XCTAssertTrue(creature.spriteMirrored)
	}
	
	func testMoveDown()
	{
		creature.move(3 * CGFloat(M_PI) / 2)
		creature.update(0.2)
		XCTAssertEqual(creature.realPosition.x, 100)
		XCTAssertLessThan(creature.realPosition.y, 100)
		XCTAssertEqual(creature.angleSuffix, "_front")
		XCTAssertFalse(creature.spriteMirrored)
	}
	
	func testMoveUpRight()
	{
		creature.move(CGFloat(M_PI) / 4)
		creature.update(0.2)
		XCTAssertGreaterThan(creature.realPosition.x, 100)
		XCTAssertGreaterThan(creature.realPosition.y, 100)
		XCTAssertEqual(creature.angleSuffix, "_side")
		XCTAssertFalse(creature.spriteMirrored)
	}
	
	func testMoveUpLeft()
	{
		creature.move(CGFloat(M_PI) * 3 / 4)
		creature.update(0.2)
		XCTAssertLessThan(creature.realPosition.x, 100)
		XCTAssertGreaterThan(creature.realPosition.y, 100)
		XCTAssertEqual(creature.angleSuffix, "_side")
		XCTAssertTrue(creature.spriteMirrored)
	}
	
	func testMoveDownRight()
	{
		creature.move(CGFloat(M_PI) * 7 / 4)
		creature.update(0.2)
		XCTAssertGreaterThan(creature.realPosition.x, 100)
		XCTAssertLessThan(creature.realPosition.y, 100)
		XCTAssertEqual(creature.angleSuffix, "_side")
		XCTAssertFalse(creature.spriteMirrored)
	}
	
	func testMoveDownLeft()
	{
		creature.move(CGFloat(M_PI) * 5 / 4)
		creature.update(0.2)
		XCTAssertLessThan(creature.realPosition.x, 100)
		XCTAssertLessThan(creature.realPosition.y, 100)
		XCTAssertEqual(creature.angleSuffix, "_side")
		XCTAssertTrue(creature.spriteMirrored)
	}
	
	func testNoMoveIntoPerson()
	{
		creature.move(0)
		creature.update(1, creatureArray: creatureArray)
		XCTAssertEqual(creature.realPosition.x, 100)
	}
	
	func testMoveAnimationProgression()
	{
		//test the walking animation goes in the following order: walk1, neutral, walk2, neutral, *repeat*
		creature.move(0)
		XCTAssertTrue(creatureWalkingOne)
		creature.update(0.25 / Creature.moveTimerRate)
		XCTAssertTrue(creatureNeutral)
		creature.move(0)
		creature.update(0.25 / Creature.moveTimerRate)
		XCTAssertTrue(creatureWalkingTwo)
		creature.move(0)
		creature.update(0.25 / Creature.moveTimerRate)
		XCTAssertTrue(creatureNeutral)
		creature.move(0)
		creature.update(0.25 / Creature.moveTimerRate)
		XCTAssertTrue(creatureWalkingOne)
	}
	
	func testMoveAnimationEndsInstantly()
	{
		creature.move(0)
		creature.update(0.01)
		XCTAssertTrue(creatureWalkingOne)
		//purposefully DON'T order the creature to walk
		creature.update(0.01)
		XCTAssertTrue(creatureNeutral)
	}
	
	func testNoMoveAnimationWhileStunned()
	{
		creature.move(0)
		creature.takeHit(0, direction: 0, knockback: 0.0, knockbackLength: 0.0, stun: 1.0)
		creature.update(0.1)
		XCTAssertFalse(creatureWalkingOne)
	}
	
	func testNoMoveAnimationForKnockback()
	{
		creature.takeHit(0, direction: 0, knockback: 10.0, knockbackLength: 1.0, stun: 0.0)
		creature.update(0.1)
		XCTAssertFalse(creatureWalkingOne)
	}

	
	//MARK: take attack tests
	
	func testNoKnockbackIntoPerson()
	{
		creature.takeHit(0, direction: 0, knockback: 100, knockbackLength: 1, stun: 0)
		creature.update(1, creatureArray: creatureArray)
		XCTAssertEqual(creature.realPosition.x, 100)
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
		XCTAssertEqual(creature.realPosition.x, 100)
	}
	
	func testStunPartialMove()
	{
		creature.takeHit(0, direction: 0, knockback: 0, knockbackLength: 0, stun: 1.0)
		creature.move(0)
		creature.update(2.0)
		XCTAssertGreaterThan(creature.realPosition.x, 100)
	}
	
	func testKnockback()
	{
		creature.takeHit(0, direction: 0, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		creature.update(1.0)
		XCTAssertGreaterThan(creature.realPosition.x, 100)
	}
	
	func testKnockbackDuration()
	{
		creature.takeHit(0, direction: 0, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		creature.update(0.5)
		XCTAssertTrue(creature.realPosition.x > 100)
		let oldX = creature.realPosition.x
		creature.update(1.0)
		XCTAssertGreaterThan(creature.realPosition.x, oldX)
	}
	
	func testKnockbackOverride()
	{
		creature.takeHit(0, direction: 0, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		creature.update(0.5)
		XCTAssertTrue(creature.realPosition.x > 100)
		creature.takeHit(0, direction: CGFloat(M_PI) / 2, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		let oldX = creature.realPosition.x
		creature.update(1.0)
		XCTAssertEqual(creature.realPosition.x, oldX)
		XCTAssertGreaterThan(creature.realPosition.y, 100)
	}
	
	func testKnockbackCancelsMove()
	{
		creature.move(0)
		creature.update(100)
		let oldX = creature.realPosition.x
		creature.takeHit(0, direction: CGFloat(M_PI) / 2, knockback: 10.0, knockbackLength: 1.0, stun: 0)
		creature.update(1.0)
		XCTAssertEqual(creature.realPosition.x, oldX)
	}
	
	
	//MARK: attack tests
	
	func testAttackProgression()
	{
		//test to make sure you don't start out attacking, but you do end up attacking for a while after selecting attack
		XCTAssertFalse(creatureAttacking)
		XCTAssertFalse(creature.attacking)
		creature.attack()
		XCTAssertTrue(creatureAttacking)
		XCTAssertTrue(creature.attacking)
		creature.update(100)
		XCTAssertFalse(creatureAttacking)
		XCTAssertFalse(creature.attacking)
	}
	
	func testAttackCooldownProgression()
	{
		//test to make sure that attack cooldown happens after attacking ends
		XCTAssertFalse(creatureInCooldown)
		XCTAssertFalse(creature.attacking)
		creature.attack()
		XCTAssertFalse(creatureInCooldown)
		while creatureAttacking
		{
			creature.update(0.1)
		}
		XCTAssertTrue(creatureInCooldown)
		XCTAssertTrue(creature.attacking)
		creature.update(100)
		XCTAssertFalse(creatureInCooldown)
		XCTAssertFalse(creature.attacking)
	}
	
	func testAttackHitting()
	{
		XCTAssertTrue(creature.inRangeToHit(otherCreature))
		creature.attack()
		creature.update(100, creatureArray: creatureArray)
		XCTAssertEqual(otherCreature.health, 2)
	}
	
	func testAttackOutOfRange()
	{
		otherCreature.move(0)
		otherCreature.update(10)
		XCTAssertFalse(creature.inRangeToHit(otherCreature))
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
		XCTAssertFalse(creatureAttacking)
		creature.update(100)
		creature.attack()
		XCTAssertTrue(creatureAttacking)
	}
	
	func testStunDoesntStopAttack()
	{
		creature.attack()
		creature.takeHit(0, direction: 0, knockback: 0, knockbackLength: 0, stun: 100)
		creature.update(0.1)
		XCTAssertTrue(creatureAttacking)
	}
	
	func testNoAttackWhileInCooldown()
	{
		creature.attack()
		while creatureAttacking
		{
			creature.update(0.1)
		}
		creature.attack()
		XCTAssertFalse(creatureAttacking)
		
	}
	
	func testNoMovingWhileAttacking()
	{
		creature.attack()
		creature.move(0)
		creature.update(0.1)
		XCTAssertEqual(creature.realPosition.x, 100)
	}
	
	func testNoMovingWhileCooldown()
	{
		creature.attack()
		while creatureAttacking
		{
			creature.update(0.1)
		}
		creature.move(0)
		creature.update(0.1)
		XCTAssertEqual(creature.realPosition.x, 100)
	}
	
	//MARK: helper functions
	var creatureAttacking:Bool
	{
		return creature.animSuffix == "_slash1"
	}
	var creatureInCooldown:Bool
	{
		return creature.animSuffix == "_slash2"
	}
	var creatureWalkingOne:Bool
	{
		return creature.animSuffix == "_walk1"
	}
	var creatureWalkingTwo:Bool
	{
		return creature.animSuffix == "_walk2"
	}
	var creatureNeutral:Bool
	{
		return creature.animSuffix == "_neutral"
	}
}