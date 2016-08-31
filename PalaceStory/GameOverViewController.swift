//
//  GameOverViewController.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 30/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import UIKit

protocol GameOverViewControllerDelegate {
    func playAgain()
}

class GameOverViewController: BaseViewController {

    var delegate: GameOverViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

//MARK: actions

extension GameOverViewController {
    
    @IBAction func playAgainAction(sender: AnyObject) {
        delegate?.playAgain()
        dismissViewControllerAnimated(true, completion: nil)
    }
}