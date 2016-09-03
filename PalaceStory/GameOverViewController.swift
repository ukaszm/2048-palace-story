//
//  GameOverViewController.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 30/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import UIKit

protocol GameOverViewControllerDelegate {
    var gameScore: Int { get }
    func playAgain()
}

class GameOverViewController: BaseViewController {

    @IBOutlet weak var gameOverImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var delegate: GameOverViewControllerDelegate?
    var executeOnce = true
}

//MARK: override 
extension GameOverViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bestScore = delegate?.gameScore {
            scoreLabel.text = "Score: \(bestScore)"
        }
        bestScoreLabel.text = "Best score: \(HighScore.points)"
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard executeOnce else { return }
        executeOnce = false
        startAnimation()
    }
}

//MARK: private
extension GameOverViewController{
    
    private func startAnimation() {
        let scoreOffset: CGFloat = 100
        let playAgainOffset: CGFloat = 120
        gameOverImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5)
        scoreLabel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -scoreOffset, 0)
        bestScoreLabel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, scoreOffset, 0)
        playAgainButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, playAgainOffset)
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: { [unowned self] in
            self.gameOverImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.25, 1.25)
            self.gameOverImageView.layoutIfNeeded()
            self.scoreLabel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, scoreOffset/2, 0)
            self.scoreLabel.layoutIfNeeded()
            self.bestScoreLabel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -scoreOffset/2, 0)
            self.bestScoreLabel.layoutIfNeeded()
            self.playAgainButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -playAgainOffset/8)
            self.playAgainButton.layoutIfNeeded()
            }, completion: finalizeAnimation)
    }
    
    private func finalizeAnimation(notUsedParam: Bool) {
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: { [unowned self] in
            self.gameOverImageView.transform = CGAffineTransformIdentity
            self.gameOverImageView.layoutIfNeeded()
            self.scoreLabel.transform = CGAffineTransformIdentity
            self.scoreLabel.layoutIfNeeded()
            self.bestScoreLabel.transform = CGAffineTransformIdentity
            self.bestScoreLabel.layoutIfNeeded()
            self.playAgainButton.transform = CGAffineTransformIdentity
            self.playAgainButton.layoutIfNeeded()
            }, completion: nil)
    }
}

//MARK: actions
extension GameOverViewController {
    
    @IBAction func playAgainAction(sender: AnyObject) {
        delegate?.playAgain()
        dismissViewControllerAnimated(true, completion: nil)
    }
}