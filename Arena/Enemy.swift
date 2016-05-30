//
//  Enemy.swift
//  Arena
//
//  Created by Theodore Abshire on 5/28/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class Enemy:Creature
{
	//MARK: AI script names
	internal static let aiScriptWalkTowardsPlayer = "WALK TO"
	internal static let aiScriptWalkAwayFromPlayer = "WALK AWAY"
	internal static let aiScriptAttackTowardsPlayer = "ATTACK"
	
	
	//MARK: AI variables
	private var scriptRunning:String?
	private var scriptDuration:CGFloat = 0
	
	//MARK: initializers
	
	override init(position:CGPoint, type:String)
	{
		super.init(position: position, type: type)
		
		//TODO: run default AI script
	}
	
	//MARK: main logic
	
	func forceAIScript(scriptName: String, duration: CGFloat)
	{
		scriptRunning = scriptName
		scriptDuration = duration
	}
	
	override func update(elapsed: CGFloat, creatureArray: [Creature]? = nil)
	{
		if let creatureArray = creatureArray, let scriptRunning = scriptRunning
		{
			switch(scriptRunning)
			{
			case Enemy.aiScriptWalkTowardsPlayer:	walkTowardsPlayer(creatureArray)
			case Enemy.aiScriptWalkAwayFromPlayer:	walkAwayFromPlayer(creatureArray)
			case Enemy.aiScriptAttackTowardsPlayer:	attackTowardsPlayer(creatureArray)
			default: break;
			}
			
			scriptDuration -= elapsed
			if scriptDuration <= 0
			{
				self.scriptRunning = nil
			}
		}
		
		super.update(elapsed, creatureArray: creatureArray)
	}
	
	//MARK: AI subscripts
	private func walkTowardsPlayer(creatureArray: [Creature])
	{
		let angle = getAngleToPlayer(creatureArray)
		self.move(angle)
	}
	
	private func walkAwayFromPlayer(creatureArray: [Creature])
	{
		let angle = getAngleToPlayer(creatureArray)
		self.move(angle + CGFloat(M_PI))
	}
	
	private func attackTowardsPlayer(creatureArray: [Creature])
	{
		let angle = getAngleToPlayer(creatureArray)
		self.turn(angle)
		
		self.attack()
	}
	
	//MARK: AI helper functions
	
	private func getAngleToPlayer(creatureArray: [Creature]) -> CGFloat
	{
		let player = getPlayerFromCreatureArray(creatureArray)
		let xDis = player.realPosition.x - self.realPosition.x
		let yDis = player.realPosition.y - self.realPosition.y
		let angle = CGFloat(atan2f(Float(yDis), Float(xDis)))
		return angle;
	}
	
	private func getPlayerFromCreatureArray(creatureArray: [Creature]) -> Creature
	{
		return creatureArray[0]
	}
}