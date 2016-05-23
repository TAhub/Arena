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
	
	private let thumbstickPosition = CGPointMake(80, 80)
	private let thumbstickSize:CGFloat = 60
	
	override func didMoveToView(view: SKView)
	{
		//add creature views to correspond to the game's creatures
		for creature in game.creatures
		{
			creatureDrawers.append(CreatureDrawer(creature: creature, game: game, rootNode: self))
		}
		
		//add the thumbstick
		let thumbstick:SKNode = SKShapeNode(circleOfRadius: thumbstickSize)
		thumbstick.position = thumbstickPosition
		self.addChild(thumbstick)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		game.setMove(nil)
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		for touch in touches
		{
			thumbstickTouch(touch)
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches
		{
			thumbstickTouch(touch)
		}
	}
	
	private func thumbstickTouch(touch:UITouch)
	{
		let touchPosition = touch.locationInNode(self)
		
		//is it in the tumbstick?
		let xDis = touchPosition.x - thumbstickPosition.x
		let yDis = touchPosition.y - thumbstickPosition.y
		let distance = sqrt(xDis*xDis + yDis*yDis)
		if distance <= thumbstickSize
		{
			let angle = atan2(yDis, xDis)
			game.setMove(angle)
		}
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