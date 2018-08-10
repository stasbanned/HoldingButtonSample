//
//  ViewController.swift
//  MicroAnimation
//
//  Created by Станислав Тищенко on 06.08.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import UIKit
import Toaster

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var customView: CustomView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customView = CustomView(frame: CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(customView)
    }
}

