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
	private let type:String
	var armor:String
	{
		didSet
		{
			setArmorSprite()
		}
	}
	private func setArmorSprite()
	{
		cachedArmorSprite = DataStore.getString("Armors", armor, "sprite")
	}
	var weapon:String
	{
		didSet
		{
			setWeaponSprite()
		}
	}
	private func setWeaponSprite()
	{
		cachedWeaponSprite = DataStore.getString("Weapons", weapon, "sprite")
		cachedWeaponAnimSet = DataStore.getString("Weapons", weapon, "attack anim set")
	}
	
	//MARK: caching data
	private let cachedMaxHealth:Int
	private let cachedMaxSpeed:CGFloat
	private let cachedDecelRate:CGFloat
	private let cachedAccelRate:CGFloat
	private let cachedSize:CGFloat
	private let cachedGood:Bool
	private let cachedUseArmorStats:Bool
	private var cachedWeaponSprite:String?
	private var cachedArmorSprite:String?
	private var cachedWeaponAnimSet:String!
	
	//MARK: initializer
	init(type:String, armor:String? = nil, weapon:String? = nil)
	{
		self.type = type
		self.armor = (armor ?? DataStore.getString("Creatures", type, "armor")) ?? "nude"
		self.weapon = (weapon ?? DataStore.getString("Creatures", type, "weapon")) ?? "unarmed"
		
		//pre-load values from the plists
		cachedMaxHealth = DataStore.getInt("Creatures", type, "max health")!
		cachedMaxSpeed = CGFloat(DataStore.getInt("Creatures", type, "max speed")!)
		cachedDecelRate = CGFloat(DataStore.getInt("Creatures", type, "decel rate")!)
		cachedAccelRate = CGFloat(DataStore.getInt("Creatures", type, "accel rate")!)
		cachedSize = CGFloat(DataStore.getInt("Creatures", type, "size")!)
		cachedUseArmorStats = DataStore.getBool("Creatures", type, "use armor stats")
		cachedGood = DataStore.getBool("Creatures", type, "good")
		
		//pre-load some values for your equipment too
		setWeaponSprite()
		setArmorSprite()
	}
	
	//MARK: basic stat accessors
	var maxHealth:Int
	{
		return cachedMaxHealth + (cachedUseArmorStats ? (DataStore.getInt("Armors", armor, "max health") ?? 0) : 0)
	}
	var maxSpeed:CGFloat
	{
		return cachedMaxSpeed + CGFloat(cachedUseArmorStats ? (DataStore.getFloat("Armors", armor, "max speed") ?? 0) : 0)
	}
	var decelRate:CGFloat
	{
		return cachedDecelRate + CGFloat(cachedUseArmorStats ? (DataStore.getFloat("Armors", armor, "decel rate") ?? 0) : 0)
	}
	var accelRate:CGFloat
	{
		return cachedAccelRate + CGFloat(cachedUseArmorStats ? (DataStore.getFloat("Armors", armor, "accel rate") ?? 0) : 0)
	}
	var size:CGFloat
	{
		return cachedSize
	}
	var good:Bool
	{
		return cachedGood
	}
	
	//MARK: weapon stat accessors
	var attackSpeed:CGFloat
	{
		return CGFloat(DataStore.getFloat("Weapons", weapon, "speed")!)
	}
	var attackCooldownSpeed:CGFloat
	{
		return CGFloat(DataStore.getFloat("Weapons", weapon, "cooldown speed")!)
	}
	var attackAngularRange:CGFloat
	{
		return CGFloat(DataStore.getFloat("Weapons", weapon, "angular range")!) * CGFloat(M_PI)
	}
	var attackRange:CGFloat
	{
		return CGFloat(DataStore.getFloat("Weapons", weapon, "range")!)
	}
	var attackKnockback:CGFloat
	{
		return CGFloat(DataStore.getFloat("Weapons", weapon, "knockback")!)
	}
	var attackKnockbackLength:CGFloat
	{
		return CGFloat(DataStore.getFloat("Weapons", weapon, "knockback length")!)
	}
	var attackStunLength:CGFloat
	{
		return CGFloat(DataStore.getFloat("Weapons", weapon, "stun length")!)
	}
	
	//MARK: appearance accessors
	var weaponSprite:String?
	{
		return cachedWeaponSprite
	}
	var weaponAnimSet:String
	{
		return cachedWeaponAnimSet
	}
	var armorSprite:String?
	{
		return cachedArmorSprite
	}
}