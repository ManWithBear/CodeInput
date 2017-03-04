//
//  ViewController.swift
//  CodeInputDemo
//
//  Created by Denis Bogomolov on 04/03/2017.
//

import UIKit
import CodeInput

class ViewController: UIViewController {

    var input: CodeInputView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let input = CodeInputView(8, spacing: 6)
        input.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(input)
        self.input = input
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        input?.center = view.center
    }

    @IBAction func tap(_ sender: Any) {
        view.endEditing(true)
    }
}
