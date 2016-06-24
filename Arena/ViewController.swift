//
//  ViewController.swift
//  Arena
//
//  Created by Theodore Abshire on 5/11/16.
//  Copyright © 2016 Theodore Abshire. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		let skView = view as! SKView
		
		skView.showsFPS = true
		skView.showsNodeCount = true
		skView.ignoresSiblingOrder = true
		
		let game = Game()
		let player = Creature(position: CGPointMake(200, 200), type: "testman")
		player.stats.weapon = "bow"
		player.stats.armor = "breastplate"
		game.addPlayer(player)
		game.addEnemy(Enemy(position: CGPointMake(300, 300), type: "testman bad"))
		let scene = GameScene(size: view.bounds.size)
		scene.game = game
		skView.presentScene(scene)
	}
}

