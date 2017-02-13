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
    @IBAction func restartGameAction(_ sender: AnyObject) {
        newGame()
    }
    
    @IBAction func gameOverAction(_ sender: AnyObject) {
        gameOver()
    }
}

//MARK: public methods
extension GameViewController {
    
}

//MARK: private methods
extension GameViewController {
    
    fileprivate func newGame() {
        guard let skView = view as? SKView else { return }
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        board = Board()
        scene.board = board
        scene.swipeHandler = handleSwipe
        
        skView.presentScene(scene)
        
        let newTiles = board.newGame()
        scene.addSpriteForTiles(newTiles)
        updateScore()
        view.isUserInteractionEnabled = true
        
        if let tileSize = scene.tileSize {
            restartButtonYConstraint.constant = -2.05*tileSize
            scoreLabelYConstraint.constant = 2.10*tileSize
        }
        
        //skView.showsFPS = true
        //skView.showsNodeCount = true
    }
    
    fileprivate func gameOver() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_MSEC) * 500) / Double(NSEC_PER_SEC)) {
            [unowned self] in
            guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GameOverViewController") as? GameOverViewController else { return }
            vc.delegate = self
            
            vc.modalPresentationStyle = .overFullScreen
            //showViewController(vc, sender: nil)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    fileprivate func handleSwipe(_ direction: MoveDirection) {
        guard direction != .unknown else { return }
        board.prepareForHandlingMove()
        guard board.isPossibleMove(direction) else {
            scene.playSound(.wrong)
            return
        }
        view.isUserInteractionEnabled = false
        scene.playSound(.move)
        performTilesMove(direction)
    }
    
    fileprivate func performTilesMove(_ direction: MoveDirection) {
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
    
    fileprivate func checkGameOver() {
        guard board.isItGameOver() else {
            view.isUserInteractionEnabled = true
            return
        }
        scene.playSound(.gameOver)
        if HighScore.newHighScore(board.points) {
            print("new HighScore: \(HighScore.points)")
        }
        
        gameOver()
    }
    
    fileprivate func updateScore() {
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

