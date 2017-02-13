//
//  BaseViewController.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 30/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    deinit {
        print("deinit: \(type(of: self))")
    }
}

//MARK: overrided methods
extension BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning: \(type(of: self))")
    }
}
