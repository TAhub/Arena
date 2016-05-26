//
//  CreatureStats.swift
//  Arena
//
//  Created by Theodore Abshire on 5/24/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class CreatureStats
{
	//MARK: private variables
	
	//MARK: initializer
	init(type:String)
	{
		
	}
	
	//MARK: basic stat accessors
	let maxHealth:Int = 3
	let maxSpeed:CGFloat = 75
	let decelRate:CGFloat = 400
	let accelRate:CGFloat = 200
	let size:CGFloat = 5
	
	//MARK: weapon stat accessors
	let attackSpeed:CGFloat = 1.5
	let attackCooldownSpeed:CGFloat = 0.9
	let attackAngularRange:CGFloat = CGFloat(M_PI) / 2
	let attackRange:CGFloat = 10
	let attackKnockback:CGFloat = 70.0
	let attackKnockbackLength:CGFloat = 0.5
	let attackStunLength:CGFloat = 0.75
}