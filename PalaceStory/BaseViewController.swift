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
        print("deinit: \(self.dynamicType)")
    }
}

//MARK: overrided methods
extension BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait, .PortraitUpsideDown]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning: \(self.dynamicType)")
    }
}
