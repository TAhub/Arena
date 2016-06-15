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
	
	//save the last sprite name so you can know when to re-draw
	var lastSpriteName:String?
	var lastArmorSprite:String?
	var lastWeaponSprite:String?
	
	init(creature:Creature, game:Game, rootNode:SKNode)
	{
		self.game = game
		self.creature = creature
		
		myRootNode = SKNode()
		rootNode.addChild(myRootNode)
		
		update()
	}
	
	private func remakeSprite()
	{
		myRootNode.removeAllChildren()
		remakeOneSprite("body", color:UIColor.redColor(), hasGender: false)
		if let armorSprite = creature.stats.armorSprite
		{
			remakeOneSprite(armorSprite, color:UIColor.blueColor(), hasGender: true)
		}
		if let weaponSprite = creature.stats.weaponSprite
		{
			remakeOneSprite(weaponSprite, color:UIColor.whiteColor(), hasGender: false)
		}
	}
	
	private func remakeOneSprite(baseName:String, color:UIColor, hasGender:Bool)
	{
		let spriteName = "\(baseName)\(hasGender ? "_f" : "")\(lastSpriteName!).png"
		if let image = UIImage(named: spriteName)
		{
			let sprite = SKSpriteNode(texture: SKTexture(image: image))
			sprite.anchorPoint = CGPointMake(0.5, 1.0)
			sprite.color = color
			sprite.colorBlendFactor = 1.0
			sprite.zPosition = CGFloat(myRootNode.children.count)
			myRootNode.addChild(sprite)
		}
	}
	
	func update()
	{
		myRootNode.position = creature.drawPosition
		
		//set sprite appearance
		let angleSuffix = creature.angleSuffix
		var animSuffix = creature.animSuffix
		
		//apply space-saving aliases
		if angleSuffix != "_side" && animSuffix == "_shoot1"
		{
			animSuffix = "_slash3"
		}
		
		let spriteName:String = angleSuffix + animSuffix
		
		if lastSpriteName ?? "" != spriteName || lastArmorSprite ?? "" != creature.stats.armorSprite || lastWeaponSprite ?? "" != creature.stats.weaponSprite
		{
			lastSpriteName = spriteName
			lastArmorSprite = creature.stats.armorSprite ?? ""
			lastWeaponSprite = creature.stats.weaponSprite ?? ""
			remakeSprite()
		}
		
		//set sprite mirroring
		myRootNode.xScale = abs(myRootNode.xScale) * (creature.spriteMirrored ? -1 : 1)
	}
}
