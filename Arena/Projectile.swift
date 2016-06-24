//
//  Projectile.swift
//  Arena
//
//  Created by Theodore Abshire on 6/22/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class Projectile
{
	private let angle:CGFloat
	private let speed:CGFloat
	private var range:CGFloat
	private let knockback:CGFloat
	private let knockbackLength:CGFloat
	private let stun:CGFloat
	let size:CGFloat
	let good:Bool
	private var position:CGPoint
	var dead:Bool = false
	
	init(position:CGPoint, angle:CGFloat, speed:CGFloat, size:CGFloat, range:CGFloat, good:Bool, knockback: CGFloat, knockbackLength: CGFloat, stun: CGFloat)
	{
		self.position = position
		self.angle = angle
		self.good = good
		self.speed = speed
		self.size = size
		self.range = range
		self.knockbackLength = knockbackLength
		self.knockback = knockback
		self.stun = stun
	}
	
	convenience init(position:CGPoint, angle:CGFloat, range:CGFloat, good:Bool, type:String, knockback: CGFloat, knockbackLength: CGFloat, stun: CGFloat)
	{
		let size = CGFloat(DataStore.getFloat("Projectiles", type, "size")!)
		let speed = CGFloat(DataStore.getFloat("Projectiles", type, "speed")!)
		self.init(position: position, angle: angle, speed: speed, size: size, range: range, good: good, knockback: knockback, knockbackLength: knockbackLength, stun: stun)
	}
	
	//MARK: logic
	
	func update(elapsed:CGFloat, creatureArray:[Creature]? = nil)
	{
		let length = speed * elapsed
		
		//TODO: make moveInterval into a constant
		let moveInterval:CGFloat = 0.75
		let moves:Int = Int(ceil(length / moveInterval))
		for _ in 0..<moves
		{
			position = CGPointMake(position.x + length * cos(angle) / CGFloat(moves), position.y + length * sin(angle) / CGFloat(moves))
			if let creatureArray = creatureArray
			{
				for creature in creatureArray
				{
					if creature.collideProjectile(self)
					{
						self.detonateOn(creature)
					}
				}
			}
		}
		
		//account for maximum range
		range -= length
		if range <= 0
		{
			dead = true
		}
	}
	
	func detonateOn(creature:Creature)
	{
		self.dead = true
		
		creature.takeHit(1, direction: angle, knockback: knockback, knockbackLength: knockbackLength, stun: stun)
	}
	
	//MARK: accessors
	var realPosition:CGPoint
	{
		return position
	}
	var drawPosition:CGPoint
	{
		//TODO: account for hovering, falling, and other things that change z without changing y here
		return position
	}
}