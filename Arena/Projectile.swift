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
	let size:CGFloat
	let good:Bool
	private var position:CGPoint
	var dead:Bool = false
	
	init(position:CGPoint, angle:CGFloat, speed:CGFloat, size:CGFloat, good:Bool)
	{
		self.position = position
		self.angle = angle
		self.good = good
		self.speed = speed
		self.size = size
	}
	
	convenience init(position:CGPoint, angle:CGFloat, good:Bool, type:String)
	{
		let size = CGFloat(DataStore.getFloat("Projectiles", type, "size")!)
		let speed = CGFloat(DataStore.getFloat("Projectiles", type, "speed")!)
		self.init(position: position, angle: angle, speed: speed, size: size, good: good)
//		self.position = position
//		self.angle = angle
//		self.good = good
//		self.speed = CGFloat(DataStore.getFloat("Projectiles", type, "speed")!)
//		self.size = CGFloat(DataStore.getFloat("Projectiles", type, "size")!)
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
	}
	
	func detonateOn(creature:Creature)
	{
		self.dead = true
		
		//TODO: real knockback data
		creature.takeHit(1, direction: angle, knockback: 0, knockbackLength: 0, stun: 0)
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