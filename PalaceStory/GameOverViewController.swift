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

    
    override func viewWillAppear(_ animated: Bool) {
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
    
    fileprivate func startAnimation() {
        let scoreOffset: CGFloat = 100
        let playAgainOffset: CGFloat = 120
        gameOverImageView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
        scoreLabel.transform = CGAffineTransform.identity.translatedBy(x: -scoreOffset, y: 0)
        bestScoreLabel.transform = CGAffineTransform.identity.translatedBy(x: scoreOffset, y: 0)
        playAgainButton.transform = CGAffineTransform.identity.translatedBy(x: 0, y: playAgainOffset)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [unowned self] in
            self.gameOverImageView.transform = CGAffineTransform.identity.scaledBy(x: 1.25, y: 1.25)
            self.gameOverImageView.layoutIfNeeded()
            self.scoreLabel.transform = CGAffineTransform.identity.translatedBy(x: scoreOffset/2, y: 0)
            self.scoreLabel.layoutIfNeeded()
            self.bestScoreLabel.transform = CGAffineTransform.identity.translatedBy(x: -scoreOffset/2, y: 0)
            self.bestScoreLabel.layoutIfNeeded()
            self.playAgainButton.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -playAgainOffset/8)
            self.playAgainButton.layoutIfNeeded()
            }, completion: finalizeAnimation)
    }
    
    fileprivate func finalizeAnimation(_ notUsedParam: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            self.gameOverImageView.transform = CGAffineTransform.identity
            self.gameOverImageView.layoutIfNeeded()
            self.scoreLabel.transform = CGAffineTransform.identity
            self.scoreLabel.layoutIfNeeded()
            self.bestScoreLabel.transform = CGAffineTransform.identity
            self.bestScoreLabel.layoutIfNeeded()
            self.playAgainButton.transform = CGAffineTransform.identity
            self.playAgainButton.layoutIfNeeded()
            }, completion: nil)
    }
}

//MARK: actions
extension GameOverViewController {
    
    @IBAction func playAgainAction(_ sender: AnyObject) {
        delegate?.playAgain()
        dismiss(animated: true, completion: nil)
    }
}
