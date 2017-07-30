//
//  MoreController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class MoreController: FunctionController {

    private let viewController: MoreViewController

    override init() {
        self.viewController = MoreViewController()
    }

    func prepare() -> UIViewController {
        return viewController
    }
}
