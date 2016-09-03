//
//  GameViewController.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 10/08/16.
//  Copyright (c) 2016 Łukasz Majchrzak. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: BaseViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var scene: GameScene!
    var board: Board!
    @IBOutlet weak var restartButtonYConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabelYConstraint: NSLayoutConstraint!
}

//MARK: overrided methods
extension GameViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }
}

//MARK: actions
extension GameViewController {
    @IBAction func restartGameAction(sender: AnyObject) {
        newGame()
    }
    
    @IBAction func gameOverAction(sender: AnyObject) {
        gameOver()
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
        view.userInteractionEnabled = true
        
        if let tileSize = scene.tileSize {
            restartButtonYConstraint.constant = -2.05*tileSize
            scoreLabelYConstraint.constant = 2.10*tileSize
        }
        
        //skView.showsFPS = true
        //skView.showsNodeCount = true
    }
    
    private func gameOver() {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC) * 500), dispatch_get_main_queue()) {
            [unowned self] in
            guard let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("GameOverViewController") as? GameOverViewController else { return }
            vc.delegate = self
            
            vc.modalPresentationStyle = .OverFullScreen
            //showViewController(vc, sender: nil)
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    private func handleSwipe(direction: MoveDirection) {
        guard direction != .Unknown else { return }
        board.prepareForHandlingMove()
        guard board.isPossibleMove(direction) else {
            scene.playSound(.Wrong)
            return
        }
        view.userInteractionEnabled = false
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
        }
    }
    
    private func checkGameOver() {
        guard board.isItGameOver() else {
            view.userInteractionEnabled = true
            return
        }
        scene.playSound(.GameOver)
        if HighScore.newHighScore(board.points) {
            print("new HighScore: \(HighScore.points)")
        }
        
        gameOver()
    }
    
    private func updateScore() {
        scoreLabel.text = "Score: \(board.points)"
    }
}

//MARK: GameOverViewControllerDelegate
extension GameViewController: GameOverViewControllerDelegate {
    var gameScore: Int {
        return board.points
    }
    func playAgain() {
        newGame()
    }
}

