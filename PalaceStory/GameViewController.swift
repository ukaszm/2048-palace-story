//
//  GameViewController.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 10/08/16.
//  Copyright (c) 2016 Łukasz Majchrzak. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    var board: Board!
}

//MARK: overrided methods
extension GameViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let skView = view as? SKView else { return }
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        board = Board()
        scene.board = board
        scene.swipeHandler = handleSwipe
        
        skView.presentScene(scene)
        
        
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        startGame()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait, .PortraitUpsideDown]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

//MARK: methods
extension GameViewController {
    func startGame() {
        let newTiles = board.newGame()
        scene.addSpriteForTiles(newTiles)
    }
    
    func handleSwipe(direction: MoveDirection) {
        view.userInteractionEnabled = false
        
        print("handle move: \(direction)")
        board.prepareForHandlingMove()
        print("can move: \(board.isPossibleMove(direction))")
        
        view.userInteractionEnabled = true
        
    }
}
