//
//  ProjectileSetTests.swift
//  Arena
//
//  Created by Theodore Abshire on 6/23/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import XCTest
@testable import Arena

class ProjectileSetTests: XCTestCase, ProjectileSetDelegate {
	
	var delegateProjectileAdded:Projectile?
	var projectileSet:ProjectileSet!
	
    override func setUp() {
        super.setUp()
		
		projectileSet = ProjectileSet()
		projectileSet.delegate = self
		delegateProjectileAdded = nil
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testAddProjectile()
	{
		XCTAssertEqual(projectileSet.numberOfProjectiles, 0)
		let projectile = Projectile(position: CGPointZero, angle: 0, range: 1000, good: false, type: "testprojectile", knockback: 0, knockbackLength: 0, stun: 0)
		projectileSet.addProjectile(projectile)
		XCTAssertEqual(projectileSet.numberOfProjectiles, 1)
		XCTAssertTrue(delegateProjectileAdded != nil && delegateProjectileAdded! === projectile)
	}
	
	func testProjectileSetUpdate()
	{
		let projectile = Projectile(position: CGPointZero, angle: 0, range: 1000, good: false, type: "testprojectile", knockback: 0, knockbackLength: 0, stun: 0)
		projectileSet.addProjectile(projectile)
		projectileSet.update(0.1)
		XCTAssertGreaterThan(projectile.realPosition.x, 0)
	}
	
	func testProjectileSetProjectilesHit()
	{
		let projectile = Projectile(position: CGPointZero, angle: 0, range: 1000, good: false, type: "testprojectile", knockback: 0, knockbackLength: 0, stun: 0)
		projectileSet.addProjectile(projectile)
		let creature = Creature(position: CGPointZero, type: "testman")
		projectileSet.collideWith(creature)
		XCTAssertEqual(projectileSet.numberOfProjectiles, 0)
	}
	
	//MARK: delegate methods
	func projectileAdded(projectile:Projectile)
	{
		delegateProjectileAdded = projectile
	}
}
