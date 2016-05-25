//
//  gameScene.swift
//  Arena
//
//  Created by Theodore Abshire on 5/23/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	var game:Game!
	private var lastTime:NSTimeInterval?
	private var creatureDrawers = [CreatureDrawer]()
	
	private var thumbstick:PsuedoButton!
	private var attackButton:PsuedoButton!
	
	override func didMoveToView(view: SKView)
	{
		//add creature views to correspond to the game's creatures
		for creature in game.creatures
		{
			creatureDrawers.append(CreatureDrawer(creature: creature, game: game, rootNode: self))
		}
		
		//add the thumbstick
		thumbstick = PsuedoButton(size: 60, position: CGPointMake(80, 80), comparisonNode: self, touchClosure: { (angle) in
			self.game.setMove(angle)
			}, touchMoveClosure: { (angle) in
				self.game.setMove(angle)
			}, touchEndClosure: { () in
				self.game.setMove(nil)
		})
		let thumbstickNode:SKNode = SKShapeNode(circleOfRadius: thumbstick.size)
		thumbstickNode.position = thumbstick.position
		self.addChild(thumbstickNode)
		
		//add the attack button
		attackButton = PsuedoButton(size: 30, position: CGPointMake(view.bounds.width - 50, 50), comparisonNode: self, touchClosure: { (_) in
			//TODO: make the button depress
			self.game.attack()
			print("ATTACK")
			}, touchMoveClosure: nil, touchEndClosure: { () in
				//TODO: make the button pop back up
		})
		let attackButtonNode:SKNode = SKShapeNode(circleOfRadius: attackButton.size)
		attackButtonNode.position = attackButton.position
		self.addChild(attackButtonNode)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		thumbstick.touchesEnded(touches)
		attackButton.touchesEnded(touches)
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		thumbstick.touchesMoved(touches)
		attackButton.touchesMoved(touches)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		thumbstick.touchesBegan(touches)
		attackButton.touchesBegan(touches)
	}
	
	override func update(currentTime: NSTimeInterval)
	{
		if let lastTime = lastTime
		{
			let elapsed = currentTime - lastTime
			game.update(CGFloat(elapsed))
		}
		lastTime = currentTime
		
		for creatureDrawer in creatureDrawers
		{
			creatureDrawer.update()
		}
	}
}