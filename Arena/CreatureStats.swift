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
	private let type:String
	
	//MARK: initializer
	init(type:String)
	{
		self.type = type;
	}
	
	//MARK: basic stat accessors
	var maxHealth:Int
	{
		return DataStore.getInt("Creatures", type, "max health")!
	}
	var maxSpeed:CGFloat
	{
		return CGFloat(DataStore.getInt("Creatures", type, "max speed")!)
	}
	var decelRate:CGFloat
	{
		return CGFloat(DataStore.getInt("Creatures", type, "decel rate")!)
	}
	var accelRate:CGFloat
	{
		return CGFloat(DataStore.getInt("Creatures", type, "accel rate")!)
	}
	var size:CGFloat
	{
		return CGFloat(DataStore.getInt("Creatures", type, "size")!)
	}
	
	//MARK: weapon stat accessors
	let attackSpeed:CGFloat = 1.5
	let attackCooldownSpeed:CGFloat = 0.9
	let attackAngularRange:CGFloat = CGFloat(M_PI) / 2
	let attackRange:CGFloat = 10
	let attackKnockback:CGFloat = 70.0
	let attackKnockbackLength:CGFloat = 0.5
	let attackStunLength:CGFloat = 0.75
}