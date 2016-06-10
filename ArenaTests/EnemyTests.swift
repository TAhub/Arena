//
//  EnemyTests.swift
//  Arena
//
//  Created by Theodore Abshire on 5/28/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import XCTest
@testable import Arena

class EnemyTests: XCTestCase {
	
	var enemy:Enemy!
	var player:Creature!
	var creatureArray:[Creature]!
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		enemy = Enemy(position: CGPointMake(100, 100), type: "testman")
		player = Creature(position: CGPointMake(120, 100), type: "testman")
		creatureArray = [player, enemy]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	//MARK: use force-AI set to test AI subscripts
	
	func testAIScriptsPauseWhileAttacking()
	{
		enemy.attack()
		enemy.forceAIScript(Enemy.aiScriptWalkTowardsPlayer, duration: 0.25)
		enemy.update(0.5, creatureArray: creatureArray)
		XCTAssertEqual(enemy.realPosition.x, 100)
		enemy.update(0.5, creatureArray: creatureArray)
		enemy.update(0.5, creatureArray: creatureArray)
		enemy.update(0.5, creatureArray: creatureArray)
		enemy.update(0.5, creatureArray: creatureArray)
		XCTAssertGreaterThan(enemy.realPosition.x, 100)
	}
	
	func testAIMoveTowardsPlayer()
	{
		enemy.forceAIScript(Enemy.aiScriptWalkTowardsPlayer, duration: 0.1)
		enemy.update(0.1, creatureArray: creatureArray)
		let oldX = enemy.realPosition.x
		XCTAssertGreaterThan(oldX, 100)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertEqual(oldX, enemy.realPosition.x)
		
		//test to make sure it works at angles too
		player.move(CGFloat(M_PI) / 2)
		player.update(5.0)
		enemy.forceAIScript(Enemy.aiScriptWalkTowardsPlayer, duration: 0.1)
		let oldX2 = enemy.realPosition.x
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertGreaterThan(enemy.realPosition.x, oldX2)
		XCTAssertGreaterThan(enemy.realPosition.y, 100)
	}
	
	func testAIMoveAwayFromPlayer()
	{
		enemy.forceAIScript(Enemy.aiScriptWalkAwayFromPlayer, duration: 0.1)
		enemy.update(0.1, creatureArray: creatureArray)
		let oldX = enemy.realPosition.x
		XCTAssertLessThan(oldX, 100)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertEqual(oldX, enemy.realPosition.x)
	}
	
	func testAIAttack()
	{
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 999)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.isAttacking)
		XCTAssertEqual(enemy.realPosition.x, 100)
		
		//make sure it only attacks ONCE
		enemy.update(99, creatureArray: creatureArray)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertFalse(enemy.isAttacking)
	}
	
	func testAITurn()
	{
		//move the player to the left of the enemy, and then turn to them
		player.move(CGFloat(M_PI))
		player.update(5.0)
		enemy.forceAIScript(Enemy.aiScriptTurnTowardsPlayer, duration: 999)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.spriteMirrored)
		
		//the script should end instantly, so here's a test to make sure it doesn't turn again
		player.move(0)
		player.update(15.0)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.spriteMirrored)
	}
	
	//MARKL use force-AI to test AI conditions
	
	func testConditionsApplyOnce()
	{
		enemy.move(CGFloat(M_PI))
		enemy.update(1, creatureArray: creatureArray)
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 0.1, condition: Enemy.aiConditionInRange)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertFalse(enemy.isAttacking)
		enemy.update(1, creatureArray: creatureArray)
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 0.1)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.isAttacking)
	}
	
	func testIfInRange()
	{
		enemy.move(0)
		enemy.update(3, creatureArray: creatureArray)
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 0.1, condition: Enemy.aiConditionInRange)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.isAttacking)
		enemy.update(3, creatureArray: creatureArray)
		enemy.move(CGFloat(M_PI))
		enemy.update(1, creatureArray: creatureArray)
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 0.1, condition: Enemy.aiConditionInRange)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertFalse(enemy.isAttacking)
	}
	
	//MARK: test testman default AI script
	
	func testAIScriptProgression()
	{
		//the testman's AI script is, in order: attack, move towards player (2s), move away from player (2s), wait (5s)
		
		enemy.startAIProgression()
		
		//test to see if it attacks
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.isAttacking)
		
		while enemy.isAttacking || enemy.isInCooldown
		{
			enemy.update(0.5, creatureArray: creatureArray)
		}
		
		//test to see if it moves towards the player
		enemy.update(0.5, creatureArray: creatureArray)
		XCTAssertGreaterThan(enemy.realPosition.x, 100)
		XCTAssertFalse(enemy.spriteMirrored)
		
		enemy.update(1.5, creatureArray: creatureArray)
		
		//test to see if it moves away from the player
		enemy.update(2, creatureArray: creatureArray)
		XCTAssertLessThanOrEqual(enemy.realPosition.x, 100)
		let oldX = enemy.realPosition.x
		XCTAssertTrue(enemy.spriteMirrored)
		
		//test to see if it waits
		enemy.update(5, creatureArray: creatureArray)
		XCTAssertEqual(enemy.realPosition.x, oldX)
		
		//test to see if it repeats
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.isAttacking)
	}
}