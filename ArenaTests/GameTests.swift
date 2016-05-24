//
//  GameTests.swift
//  Arena
//
//  Created by Theodore Abshire on 5/23/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import XCTest
@testable import Arena

class GameTests: XCTestCase {
	
	var game:Game!
	
    override func setUp() {
        super.setUp()
		
		game = Game()
		
		game.addPlayer(Creature(position: CGPointMake(100, 100), type: "testman"))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testControlStickHolds()
	{
		game.setMove(0)
		game.update(1.0)
		let oldX = game.player!.drawPosition.x
		XCTAssertNotEqual(oldX, 100)
		game.update(1.0)
		XCTAssertNotEqual(oldX, game.player!.drawPosition.x)
	}
	
	func testControlStickCanCancel()
	{
		game.setMove(0)
		game.update(1.0)
		let oldX = game.player!.drawPosition.x
		XCTAssertNotEqual(oldX, 100)
		game.setMove(nil)
		game.update(1.0)
		XCTAssertEqual(oldX, game.player!.drawPosition.x)
	}
	
	func testControlAttack()
	{
		game.attack()
		XCTAssertTrue(creatureAttacking)
	}
	
	//MARK: helper functions
	var creatureAttacking:Bool
	{
		return game.player!.animSuffix == "_swing1"
	}
}
