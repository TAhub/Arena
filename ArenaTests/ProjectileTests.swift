//
//  ProjectileTests.swift
//  Arena
//
//  Created by Theodore Abshire on 6/22/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import XCTest
@testable import Arena

class ProjectileTests: XCTestCase {
	
	var projectile:Projectile!
	
    override func setUp() {
        super.setUp()
		
		projectile = Projectile(position: CGPointMake(100, 100), angle: 0, speed: 100, size: 5, good: true)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testProjectileMove()
	{
		projectile.update(0.1)
		XCTAssertTrue(abs(projectile.realPosition.x - 110) < 1) //damn floating point errors
		XCTAssertEqual(projectile.realPosition.y, 100)
	}
	
	func testProjectileHitEnemy()
	{
		let enemyToHit = Creature(position: CGPointMake(110, 100), type: "testman bad")
		
		XCTAssertFalse(projectile.dead)
		projectile.update(0.5, creatureArray:[enemyToHit])
		XCTAssertEqual(enemyToHit.health, 2)
		XCTAssertTrue(projectile.dead)
	}
	
	func testDetonate()
	{
		let enemyToHit = Creature(position: CGPointMake(110, 100), type: "testman bad")
		
		XCTAssertFalse(projectile.dead)
		projectile.detonateOn(enemyToHit)
		XCTAssertEqual(enemyToHit.health, 2)
		XCTAssertTrue(projectile.dead)
	}
}
