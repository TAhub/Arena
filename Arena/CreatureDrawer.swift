//
//  CreatureDrawer.swift
//  Arena
//
//  Created by Theodore Abshire on 5/23/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class CreatureDrawer
{
	let creature:Creature
	let game:Game
	let myRootNode:SKNode
	
	init(creature:Creature, game:Game, rootNode:SKNode)
	{
		self.game = game
		self.creature = creature
		
		myRootNode = SKNode()
		rootNode.addChild(myRootNode)
		
		//TODO: real appearance
		let shape = SKShapeNode.init(rect: CGRectMake(-5, -10, 10, 10))
		myRootNode.addChild(shape)
		
		update()
	}
	
	func update()
	{
		myRootNode.position = creature.drawPosition
	}
}
