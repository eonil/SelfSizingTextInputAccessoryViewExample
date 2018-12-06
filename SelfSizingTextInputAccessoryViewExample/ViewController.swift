//
//  ViewController.swift
//  SelfSizingTextInputAccessoryViewExample
//
//  Created by Henry on 2018/12/06.
//  Copyright © 2018 Henry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let v1 = ExampleTextTypingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        v1.maximumHeight = 200
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var inputAccessoryView: UIView? {
        return v1
    }
}
