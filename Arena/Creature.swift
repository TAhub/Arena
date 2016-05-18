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
	
	//main variables
	var position:CGPoint
	var health:Int
	
	//attacking variables
	var attackTimer:CGFloat?
	var attackCooldown:CGFloat?
	var facingDirection:CGFloat
	
	//private variables
	
	//movement variables
	private var moveVector:CGPoint = CGPointMake(0, 0)
	private var accelDirection:CGFloat?
	
	//stun/knockback variables
	private var stun:CGFloat = 0
	private var knockbackDirection:CGFloat!
	private var knockbackLength:CGFloat!
	private var knockbackStrength:CGFloat = 0
	
	init(position:CGPoint, type:String)
	{
		self.position = position
		self.health = 3
		
		//set starting facing direction
		self.facingDirection = 0
	}
	
	private func collideAt(point:CGPoint, creatureArray:[Creature]) -> Bool
	{
		//get your size
		let size:CGFloat = 5
		
		for creature in creatureArray
		{
			if !(creature === self)
			{
				//get their size
				let theirSize:CGFloat = 5
				
				//how far away are you?
				let xDis:CGFloat = abs(point.x - creature.position.x)
				let yDis:CGFloat = abs(point.y - creature.position.y)
				let distance:CGFloat = sqrt(xDis * xDis + yDis * yDis)
				if (distance <= size + theirSize)
				{
					return true
				}
			}
		}
		return false
	}
	
	func collidePoint(point:CGPoint) -> Bool
	{
		let size:CGFloat = 5
		
		let xDis:CGFloat = abs(point.x - position.x)
		let yDis:CGFloat = abs(point.y - position.y)
		let distance:CGFloat = sqrt(xDis * xDis + yDis * yDis)
		return distance <= size
	}
	
	private func moveInner(vector:CGPoint, creatureArray:[Creature]?)
	{
		if let creatureArray = creatureArray
		{
			let length:CGFloat = abs(vector.x * vector.x + vector.y * vector.y)
			
			//don't go through the whole process when there is no movement necessary
			if length == 0
			{
				return
			}
			
			let moveInterval:CGFloat = 0.75
			let moves:Int = Int(ceil(length / moveInterval))
			for _ in 0..<moves
			{
				let newPosition = CGPointMake(self.position.x + vector.x / CGFloat(moves), self.position.y + vector.y / CGFloat(moves))
				if collideAt(newPosition, creatureArray: creatureArray)
				{
					return
				}
				self.position = newPosition
			}
		}
		else
		{
			self.position = CGPointMake(self.position.x + vector.x, self.position.y + vector.y)
		}
	}
	
	private func unleashAttack(creatureArray:[Creature]?)
	{
		if let creatureArray = creatureArray
		{
			//check to see if anyone is in the arc
			for creature in creatureArray
			{
				if !(creature === self)
				{
					let xDif = creature.position.x - position.x
					let yDif = creature.position.y - position.y
					
					//get
					let range:CGFloat = 10
					let angularRange:CGFloat = CGFloat(M_PI) / 2
					
					//are you in range?
					let size:CGFloat = 5
					let theirSize:CGFloat = 5
					let distance = sqrt(xDif*xDif + yDif*yDif)
					
					if distance <= range + size + theirSize
					{
						//find the angle difference, to see if they are in front of you
						let angle = atan2(yDif, xDif)
						
						var angleDif = angle - facingDirection
						if angleDif < -CGFloat(M_PI)
						{
							angleDif += CGFloat(M_PI) * 2
						}
						else if angleDif > CGFloat(M_PI)
						{
							angleDif -= CGFloat(M_PI) * 2
						}
						
						print("\(angleDif) vs \(angularRange)")
						
						if abs(angleDif) < angularRange
						{
							//they're in range and in angle, so they take a hit
							creature.takeHit(1, direction: facingDirection, knockback: 10.0, knockbackLength: 1.0, stun: 1.0)
						}
					}
				}
			}
		}
	}
	
	func update(elapsed:CGFloat, creatureArray:[Creature]? = nil)
	{
		//TODO: do all things that aren't affected by stun here
		if (knockbackLength > 0)
		{
			let knockbackLengthUse = min(elapsed, knockbackLength)
			moveInner(CGPointMake(cos(knockbackDirection) * knockbackLengthUse * knockbackStrength, sin(knockbackDirection) * knockbackLengthUse * knockbackStrength), creatureArray: creatureArray)
			
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
		
		//attack progress
		if let attackTimer = self.attackTimer
		{
			let attackSpeed:CGFloat = 0.5
			self.attackTimer = attackTimer + attackSpeed * elapsed
			if self.attackTimer! >= 1
			{
				unleashAttack(creatureArray)
				self.attackTimer = nil
				self.attackCooldown = 0
			}
		}
		if let attackCooldown = self.attackCooldown
		{
			let attackCooldownSpeed:CGFloat = 0.5
			self.attackCooldown = attackCooldown + attackCooldownSpeed * elapsed
			if self.attackCooldown! >= 1
			{
				self.attackCooldown = nil
			}
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
		moveInner(CGPointMake(moveVector.x * elapsed, moveVector.y * elapsed), creatureArray: creatureArray)
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
	
	func move(direction:CGFloat)
	{
		if self.attackTimer == nil && self.attackCooldown == nil
		{
			accelDirection = direction
			facingDirection = direction
		}
	}
	
	func attack()
	{
		if self.stun == 0 && self.attackTimer == nil && self.attackCooldown == nil
		{
			self.attackTimer = 0
		}
	}
}