//
//  Game.swift
//  Arena
//
//  Created by Theodore Abshire on 5/23/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class Game
{
	//MARK: variables
	internal var player:Creature?
	internal var enemies = [Creature]()
	private func makeCreatures()
	{
		_creatures = enemies + (player != nil ? [player!] : []);
	}
	private var _creatures = [Creature]()
	private var moveDirection:CGFloat?
	
	
	//MARK: accessors
	var creatures:[Creature]
	{
		get
		{
			return _creatures
		}
	}
	
	//MARK: mutators
	
	func addPlayer(player:Creature)
	{
		self.player = player
		makeCreatures()
	}
	
	func addEnemy(enemy:Creature)
	{
		enemies.append(enemy)
		makeCreatures()
	}
	
	func setMove(direction:CGFloat?)
	{
		moveDirection = direction
	}
	
	func attack()
	{
		if let player = player
		{
			player.attack()
		}
	}
	
	func update(elapsed:CGFloat)
	{
		if let player = player
		{
			if let moveDirection = moveDirection
			{
				player.move(moveDirection)
			}
			
			player.update(elapsed, creatureArray: creatures)
		}
		for enemy in enemies
		{
			enemy.update(elapsed, creatureArray: creatures)
		}
	}
}