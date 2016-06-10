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
	private let type:String
	
	//MARK: caching data
	private let cachedMaxHealth:Int
	private let cachedMaxSpeed:CGFloat
	private let cachedDecelRate:CGFloat
	private let cachedAccelRate:CGFloat
	private let cachedSize:CGFloat
	
	//MARK: initializer
	init(type:String)
	{
		self.type = type;
		
		//pre-load values from the plists
		cachedMaxHealth = DataStore.getInt("Creatures", type, "max health")!
		cachedMaxSpeed = CGFloat(DataStore.getInt("Creatures", type, "max speed")!)
		cachedDecelRate = CGFloat(DataStore.getInt("Creatures", type, "decel rate")!)
		cachedAccelRate = CGFloat(DataStore.getInt("Creatures", type, "accel rate")!)
		cachedSize = CGFloat(DataStore.getInt("Creatures", type, "size")!)
	}
	
	//MARK: basic stat accessors
	var maxHealth:Int
	{
		return cachedMaxHealth
	}
	var maxSpeed:CGFloat
	{
		return cachedMaxSpeed
	}
	var decelRate:CGFloat
	{
		return cachedDecelRate
	}
	var accelRate:CGFloat
	{
		return cachedAccelRate
	}
	var size:CGFloat
	{
		return cachedSize
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