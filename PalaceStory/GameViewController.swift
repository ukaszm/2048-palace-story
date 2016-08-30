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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var scene: GameScene!
    var board: Board!
}

//MARK: overrided methods
extension GameViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
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

//MARK: actions
extension GameViewController {
    @IBAction func restartGameAction(sender: AnyObject) {
        newGame()
    }
    
    @IBAction func gameOverAction(sender: AnyObject) {
    }
}

//MARK: public methods
extension GameViewController {
    
}

//MARK: private methods
extension GameViewController {
    
    private func newGame() {
        guard let skView = view as? SKView else { return }
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        board = Board()
        scene.board = board
        scene.swipeHandler = handleSwipe
        
        skView.presentScene(scene)
        
        let newTiles = board.newGame()
        scene.addSpriteForTiles(newTiles)
        updateScore()
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    private func handleSwipe(direction: MoveDirection) {
        guard direction != .Unknown else { return }
        view.userInteractionEnabled = false
        board.prepareForHandlingMove()
        guard board.isPossibleMove(direction) else {
            view.userInteractionEnabled = true
            scene.playSound(.Wrong)
            return
        }
        scene.playSound(.Move)
        performTilesMove(direction)
    }
    
    private func performTilesMove(direction: MoveDirection) {
        if board.isPossibleMove(direction) {
            let moves = board.performSwipe(direction)
            scene.animateSpriteSwipe(moves) { [unowned self] in
                self.performTilesMove(direction)
            }
            updateScore()
        }
        else {
            let tile = board.addBasicTile()
            scene.addSpriteForTiles([tile])
            checkGameOver()
            view.userInteractionEnabled = true
        }
    }
    
    private func checkGameOver() {
        guard board.isItGameOver() else { return }
        scene.playSound(.GameOver)
        if HighScore.newHighScore(board.points) {
            print("new HighScore: \(HighScore.points)")
        }
        print("GAME OVER")
    }
    
    private func updateScore() {
        scoreLabel.text = "Score: \(board.points)"
    }
}


