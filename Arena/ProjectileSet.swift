//
//  ProjectileSet.swift
//  Arena
//
//  Created by Theodore Abshire on 6/23/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import SpriteKit

protocol ProjectileSetDelegate
{
	func projectileAdded(projectile:Projectile)
}

class ProjectileSet
{
	var delegate:ProjectileSetDelegate?
	private var projectiles = [Projectile]()
	
	func addProjectile(projectile:Projectile)
	{
		projectiles.append(projectile)
		delegate?.projectileAdded(projectile)
	}
	
	var numberOfProjectiles:Int
	{
		return projectiles.count
	}
	
	func update(elapsed:CGFloat, creatureArray:[Creature]? = nil)
	{
		for projectile in projectiles
		{
			projectile.update(elapsed, creatureArray: creatureArray)
		}
	}
	
	func collideWith(creature:Creature)
	{
		for projectile in projectiles
		{
			if creature.collideProjectile(projectile)
			{
				projectile.detonateOn(creature)
			}
		}
		
		//remove dead projectiles
		projectiles = projectiles.filter({!($0.dead)})
	}
}