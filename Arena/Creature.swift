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
	//MARK: public variables
	
	//main variables
	internal var health:Int
	
	//MARK: private variables
	
	//main variables
	internal var stats:CreatureStats
	
	//movement variables
	private var position:CGPoint
	private var moveVector:CGPoint = CGPointMake(0, 0)
	private var accelDirection:CGFloat?
	private var moveTimer:CGFloat?
	internal static let moveTimerRate:CGFloat = 1.5
	
	//attacking variables
	private var attackTimer:CGFloat?
	private var attackCooldown:CGFloat?
	private var facingDirection:CGFloat
	
	//stun/knockback variables
	private var stun:CGFloat = 0
	private var knockbackDirection:CGFloat!
	private var knockbackLength:CGFloat!
	private var knockbackStrength:CGFloat = 0
	
	//MARK: initializers
	
	init(position:CGPoint, type:String)
	{
		self.stats = CreatureStats(type: type)
		self.position = position
		self.health = stats.maxHealth
		
		//set starting facing direction
		self.facingDirection = 0
	}
	
	//MARK: accessors
	
	var drawPosition:CGPoint
	{
		//TODO: account for hovering, falling, and other things that change z without changing y here
		return position;
	}
	
	var realPosition:CGPoint
	{
		return position;
	}
	
	var angleSuffix:String
	{
		if facingDirection > CGFloat(M_PI) / 4 && facingDirection < CGFloat(M_PI) * 3 / 4
		{
			return "_back"
		}
		else if facingDirection > CGFloat(M_PI) * 5 / 4 && facingDirection < CGFloat(M_PI) * 7 / 4
		{
			return "_front"
		}
		return "_side"
	}
	
	var spriteMirrored:Bool
	{
		return facingDirection > CGFloat(M_PI) / 2 && facingDirection < CGFloat(M_PI) * 3 / 2
	}
	
	var animSuffix:String
	{
		if let moveTimer = moveTimer
		{
			if moveTimer < 0.25
			{
				return "_walk1"
			}
			else if moveTimer >= 0.5 && moveTimer < 0.75
			{
				return "_walk2"
			}
		}
		else if isAttacking || isInCooldown
		{
			switch (stats.weaponAnimSet)
			{
			case "slash":
				//TODO: once I get the new sprites out, change all references of slash2 to slash3 and neutral to slash2
				if let _ = attackTimer
				{
					return attackTimer < 0.7 ? "_slash1" : "_slash2"
				}
				else if attackCooldown != nil
				{
					return "_slash3"
				}
			case "thrust":
				if attackTimer != nil
				{
					return "_shoot2"
				}
				else if attackCooldown != nil
				{
					return "_shoot1"
				}
			case "shoot":
				if attackTimer != nil
				{
					return "_shoot1"
				}
				else if attackCooldown != nil
				{
					return "_shoot2"
				}
			default: break
			}
		}
		return "_neutral"
	}
	
	var isAttacking:Bool
	{
		return attackTimer != nil
	}
	
	var isInCooldown:Bool
	{
		return attackCooldown != nil
	}
	
	//MARK: command code
	
	func turn(direction:CGFloat)
	{
		if !self.isAttacking && !self.isInCooldown
		{
			facingDirection = correctDirection(direction)
		}
	}
	
	func move(direction:CGFloat)
	{
		if !self.isAttacking && !self.isInCooldown
		{
			let direction = correctDirection(direction)
			accelDirection = direction
			facingDirection = direction
			moveTimer = moveTimer ?? 0
		}
	}
	
	private func correctDirection(direction:CGFloat) -> CGFloat
	{
		var direction = direction
		while direction < 0
		{
			direction += CGFloat(M_PI) * 2
		}
		while (direction > CGFloat(M_PI) * 2)
		{
			direction -= CGFloat(M_PI) * 2
		}
		return direction
	}
	
	func attack()
	{
		if self.stun == 0 && self.attackTimer == nil && self.attackCooldown == nil
		{
			self.attackTimer = 0
		}
	}
	
	//MARK: interaction code
	
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
	
	func collideProjectile(projectile:Projectile) -> Bool
	{
		if projectile.good != self.stats.good && !projectile.dead && self.health > 0
		{
			let xDis:CGFloat = abs(projectile.realPosition.x - position.x)
			let yDis:CGFloat = abs(projectile.realPosition.y - position.y)
			let distance:CGFloat = sqrt(xDis * xDis + yDis * yDis)
			return distance <= stats.size + projectile.size
		}
		return false
	}
	
	func collidePoint(point:CGPoint) -> Bool
	{
		let xDis:CGFloat = abs(point.x - position.x)
		let yDis:CGFloat = abs(point.y - position.y)
		let distance:CGFloat = sqrt(xDis * xDis + yDis * yDis)
		return distance <= stats.size
	}
	
	private func collideAt(point:CGPoint, creatureArray:[Creature]) -> Bool
	{
		for creature in creatureArray
		{
			if !(creature === self)
			{
				//how far away are you?
				let xDis:CGFloat = abs(point.x - creature.position.x)
				let yDis:CGFloat = abs(point.y - creature.position.y)
				let distance:CGFloat = sqrt(xDis * xDis + yDis * yDis)
				if (distance <= stats.size + creature.stats.size)
				{
					return true
				}
			}
		}
		return false
	}
	
	//MARK: update code
	
	func update(elapsed:CGFloat, creatureArray:[Creature]? = nil, projectileArray:[Projectile]? = nil)
	{
		preStunUpdate(elapsed, creatureArray: creatureArray, projectileArray: projectileArray)
		
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
		
		postStunUpdate(elapsed, creatureArray: creatureArray, projectileArray: projectileArray)
	}
	
	private func preStunUpdate(elapsed:CGFloat, creatureArray:[Creature]?, projectileArray:[Projectile]?)
	{
		//apply knockback
		if (knockbackLength > 0)
		{
			let knockbackLengthUse = min(elapsed, knockbackLength)
			moveInner(CGPointMake(cos(knockbackDirection) * knockbackLengthUse * knockbackStrength, sin(knockbackDirection) * knockbackLengthUse * knockbackStrength), creatureArray: creatureArray, projectileArray: projectileArray)
			
			knockbackLength = max(0, knockbackLength - elapsed)
		}
		
		//attack progress
		if let attackTimer = self.attackTimer
		{
			self.attackTimer = attackTimer + stats.attackSpeed * elapsed
			if self.attackTimer! >= 1
			{
				unleashAttack(creatureArray)
				self.attackTimer = nil
				self.attackCooldown = 0
			}
		}
		if let attackCooldown = self.attackCooldown
		{
			self.attackCooldown = attackCooldown + stats.attackCooldownSpeed * elapsed
			if self.attackCooldown! >= 1
			{
				self.attackCooldown = nil
			}
		}
	}
	
	private func unleashAttack(creatureArray:[Creature]?)
	{
		if let creatureArray = creatureArray
		{
			//check to see if anyone is in the arc
			for creature in creatureArray
			{
				if inRangeToHit(creature)
				{
					//they're in range and in angle, so they take a hit
					creature.takeHit(1, direction: facingDirection, knockback: stats.attackKnockback, knockbackLength: stats.attackKnockbackLength, stun: stats.attackStunLength)
				}
			}
		}
	}
	
	func inRangeToHit(creature:Creature) -> Bool
	{
		if creature.stats.good != stats.good
		{
			let xDif = creature.position.x - position.x
			let yDif = creature.position.y - position.y
			
			//are you in range?
			let distance = sqrt(xDif*xDif + yDif*yDif)
			
			if distance <= stats.attackRange + stats.size + creature.stats.size
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
				
				if abs(angleDif) < stats.attackAngularRange
				{
					return true
				}
			}
		}
		return false
	}
	
	private func postStunUpdate(elapsed:CGFloat, creatureArray:[Creature]?, projectileArray:[Projectile]?)
	{
		if elapsed == 0
		{
			accelDirection = nil
		}
		
		//accelerate
		if let accelDirection = accelDirection
		{
			moveVector = CGPointMake(moveVector.x + cos(accelDirection) * elapsed * stats.accelRate, moveVector.y + sin(accelDirection) * elapsed * stats.accelRate)
			
			//cap the speed to the max speed
			let totalSpeed = CGFloat(sqrtf(Float(moveVector.x * moveVector.x + moveVector.y * moveVector.y)))
			if (totalSpeed > stats.maxSpeed)
			{
				moveVector = CGPointMake(moveVector.x * stats.maxSpeed / totalSpeed, moveVector.y * stats.maxSpeed / totalSpeed)
			}
			
			if var moveTimer = moveTimer
			{
				moveTimer += elapsed * Creature.moveTimerRate
				while moveTimer >= 1
				{
					moveTimer -= 1
				}
				self.moveTimer = moveTimer
			}
		}
		else //decelerate
		{
			let totalSpeed = CGFloat(sqrtf(Float(moveVector.x * moveVector.x + moveVector.y * moveVector.y)))
			if (totalSpeed <= stats.decelRate * elapsed)
			{
				moveVector = CGPointMake(0, 0)
			}
			else
			{
				moveVector = CGPointMake(moveVector.x - moveVector.x * stats.decelRate * elapsed / totalSpeed, moveVector.y - moveVector.y * stats.decelRate * elapsed / totalSpeed)
			}
			
			moveTimer = nil
		}
		accelDirection = nil
		
		//move based on your movement acceleration
		moveInner(CGPointMake(moveVector.x * elapsed, moveVector.y * elapsed), creatureArray: creatureArray, projectileArray: projectileArray)
	}
	
	private func moveInner(vector:CGPoint, creatureArray:[Creature]?, projectileArray:[Projectile]?)
	{
		if let creatureArray = creatureArray
		{
			let projectileArray = projectileArray ?? []
			
			let length:CGFloat = abs(vector.x * vector.x + vector.y * vector.y)
			
			//don't go through the whole process when there is no movement necessary
			if length == 0
			{
				return
			}
			
			//TODO: make moveInterval into a constant
			let moveInterval:CGFloat = 0.75
			let moves:Int = Int(ceil(length / moveInterval))
			for _ in 0..<moves
			{
				let newPosition = CGPointMake(self.position.x + vector.x / CGFloat(moves), self.position.y + vector.y / CGFloat(moves))
				if collideAt(newPosition, creatureArray: creatureArray)
				{
					return
				}
				for projectile in projectileArray
				{
					if self.collideProjectile(projectile)
					{
						projectile.detonateOn(self)
					}
				}
				self.position = newPosition
			}
		}
		else
		{
			self.position = CGPointMake(self.position.x + vector.x, self.position.y + vector.y)
		}
	}
}