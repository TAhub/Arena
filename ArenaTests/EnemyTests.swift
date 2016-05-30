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
	
	func testAIMoveTowardsPlayer()
	{
		enemy.forceAIScript(Enemy.aiScriptWalkTowardsPlayer, duration: 0.1)
		enemy.update(0.1, creatureArray: creatureArray)
		let oldX = enemy.realPosition.x
		XCTAssertGreaterThan(oldX, 100)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertEqual(oldX, enemy.realPosition.x)
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
		XCTAssertTrue(enemy.attacking)
		XCTAssertEqual(enemy.realPosition.x, 100)
		
		//make sure it only attacks ONCE
		enemy.update(99, creatureArray: creatureArray)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertFalse(enemy.attacking)
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
		enemy.update(10, creatureArray: creatureArray)
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 0.1, condition: Enemy.aiConditionInRange)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertFalse(enemy.attacking)
		enemy.update(10, creatureArray: creatureArray)
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 0.1)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.attacking)
	}
	
	func testIfInRange()
	{
		enemy.move(0)
		enemy.update(10, creatureArray: creatureArray)
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 0.1, condition: Enemy.aiConditionInRange)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertTrue(enemy.attacking)
		enemy.update(10, creatureArray: creatureArray)
		enemy.move(CGFloat(M_PI))
		enemy.update(10, creatureArray: creatureArray)
		enemy.forceAIScript(Enemy.aiScriptAttackTowardsPlayer, duration: 0.1, condition: Enemy.aiConditionInRange)
		enemy.update(0.1, creatureArray: creatureArray)
		XCTAssertFalse(enemy.attacking)
	}
	
	//MARK: test testman default AI script
}