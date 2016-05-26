//
//  PsuedoButton.swift
//  Arena
//
//  Created by Theodore Abshire on 5/24/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class PsuedoButton
{
	let size:CGFloat
	let position:CGPoint
	let comparisonNode:SKNode
	let touchClosure:((CGFloat)->())?
	let touchMoveClosure:((CGFloat)->())?
	let touchEndClosure:(()->())?
	
	private var savedTouch:UITouch?
	
	init(size:CGFloat, position:CGPoint, comparisonNode:SKNode, touchClosure:((CGFloat)->())?, touchMoveClosure:((CGFloat)->())?, touchEndClosure:(()->())?)
	{
		self.size = size
		self.position = position
		self.comparisonNode = comparisonNode
		self.touchClosure = touchClosure
		self.touchMoveClosure = touchMoveClosure
		self.touchEndClosure = touchEndClosure
	}
	
	func touchesEnded(touches: Set<UITouch>)
	{
		for touch in touches
		{
			if savedTouch != nil && savedTouch! == touch
			{
				//the saved touch ended
				
				self.savedTouch = nil
				
				if let touchEndClosure = touchEndClosure
				{
					touchEndClosure()
				}
			}
		}
	}
	
	func touchesMoved(touches: Set<UITouch>)
	{
		for touch in touches
		{
			if savedTouch != nil && savedTouch! == touch
			{
				if let angle = findAngleIfInside(touch)
				{
					//the saved touch moved around inside the button
					
					if let touchMoveClosure = touchMoveClosure
					{
						touchMoveClosure(angle)
					}
				}
				else
				{
					//the saved touch moved outside the button
					
					self.savedTouch = nil
					
					if let touchEndClosure = touchEndClosure
					{
						touchEndClosure()
					}
				}
			}
		}
	}
	
	func touchesBegan(touches: Set<UITouch>)
	{
		for touch in touches
		{
			if savedTouch == nil
			{
				if let angle = findAngleIfInside(touch)
				{
					//the button was touched
					
					savedTouch = touch
					
					if let touchClosure = touchClosure
					{
						touchClosure(angle)
					}
				}
			}
		}
	}
	
	private func findAngleIfInside(touch:UITouch) -> CGFloat?
	{
		let touchPosition = touch.locationInNode(comparisonNode)
		
		//is it in the tumbstick?
		let xDis = touchPosition.x - position.x
		let yDis = touchPosition.y - position.y
		let distance = sqrt(xDis*xDis + yDis*yDis)
		if distance <= size
		{
			return CGFloat(atan2(yDis, xDis))
		}
		return nil
	}
}