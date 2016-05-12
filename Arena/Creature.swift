//
//  Creature.swift
//  Arena
//
//  Created by Theodore Abshire on 5/11/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class Creature
{
	//public variables
	var position:CGPoint
	var health:Int
	
	//private variables
	private var moveVector:CGPoint = CGPointMake(0, 0)
	private var accelDirection:CGFloat?
	private var stun:CGFloat = 0
	private var knockbackDirection:CGFloat!
	private var knockbackLength:CGFloat!
	private var knockbackStrength:CGFloat = 0
	
	init(position:CGPoint, type:String)
	{
		self.position = position
		self.health = 3
	}
	
	func move(direction:CGFloat)
	{
		accelDirection = direction
	}
	
	func update(elapsed:CGFloat)
	{
		//TODO: do all things that aren't affected by stun here
		if (knockbackLength > 0)
		{
			let knockbackLengthUse = min(elapsed, knockbackLength)
			position = CGPointMake(position.x + cos(knockbackDirection) * knockbackLengthUse * knockbackStrength, position.y + sin(knockbackDirection) * knockbackLengthUse * knockbackStrength)
			
			knockbackLength = max(0, knockbackLength - elapsed)
		}
		
		//remove stun from elapsed
		var elapsed = elapsed
		if (stun > elapsed)
		{
			stun -= elapsed
			elapsed = 0
		}
		else
		{
			elapsed -= stun
			stun = 0
		}
		
		//TODO: do all things that are affected by stun here
		
		//accelerate
		if let accelDirection = accelDirection
		{
			let accel:CGFloat = 10
			moveVector = CGPointMake(moveVector.x + cos(accelDirection) * elapsed * accel, moveVector.y + sin(accelDirection) * elapsed * accel)
			
			//apply the max speed
			let maxSpeed:CGFloat = 20
			let totalSpeed = CGFloat(sqrtf(Float(moveVector.x * moveVector.x + moveVector.y * moveVector.y)))
			if (totalSpeed > maxSpeed)
			{
				moveVector = CGPointMake(moveVector.x * maxSpeed / totalSpeed, moveVector.y * maxSpeed / totalSpeed)
			}
		}
		else //decelerate
		{
			let decel:CGFloat = 15
			let totalSpeed = CGFloat(sqrtf(Float(moveVector.x * moveVector.x + moveVector.y * moveVector.y)))
			if (totalSpeed <= decel * elapsed)
			{
				moveVector = CGPointMake(0, 0)
			}
			else
			{
				moveVector = CGPointMake(moveVector.x - moveVector.x * decel * elapsed / totalSpeed, moveVector.y - moveVector.y * decel * elapsed / totalSpeed)
			}
		}
		accelDirection = nil
		
		//move based on your movement acceleration
		position = CGPointMake(position.x + moveVector.x * elapsed, position.y + moveVector.y * elapsed)
	}
	
	func takeHit(damage:Int, direction:CGFloat, knockback:CGFloat, knockbackLength:CGFloat, stun:CGFloat)
	{
		self.health -= damage
		self.stun += stun
		
		self.knockbackLength = knockbackLength
		self.knockbackStrength = knockback
		self.knockbackDirection = direction
		
		if (knockbackLength > 0)
		{
			self.moveVector = CGPointMake(0, 0)
		}
	}
}