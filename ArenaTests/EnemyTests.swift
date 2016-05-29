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
		creatureArray = [enemy, player]
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
	
	//MARK: test testman default AI script
	
	//TODO: test the default AI progression for testman
}
