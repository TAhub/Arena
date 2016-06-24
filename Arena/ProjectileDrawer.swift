//
//  ProjectileDrawer.swift
//  Arena
//
//  Created by Theodore Abshire on 6/23/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class ProjectileDrawer
{
	let projectile:Projectile
	let myRootNode:SKNode
	
	init(projectile:Projectile, rootNode:SKNode)
	{
		self.projectile = projectile
		
		myRootNode = SKNode()
		rootNode.addChild(myRootNode)
		
		let circle = SKShapeNode(circleOfRadius: projectile.size)
		myRootNode.addChild(circle)
		
		update()
	}
	
	var dead:Bool
	{
		return projectile.dead
	}
	
	func update()
	{
		if projectile.dead
		{
			myRootNode.removeFromParent()
		}
		else
		{
			myRootNode.position = projectile.drawPosition
		}
	}
}