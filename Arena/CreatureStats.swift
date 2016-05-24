//
//  CreatureStats.swift
//  Arena
//
//  Created by Theodore Abshire on 5/24/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

class CreatureStats
{
	//MARK: private variables
	
	//MARK: initializer
	init(type:String)
	{
		
	}
	
	//MARK: accessors
	let maxHealth:Int = 3
	let maxSpeed:CGFloat = 75
	let decelRate:CGFloat = 300
	let accelRate:CGFloat = 200
	let size:CGFloat = 5
}