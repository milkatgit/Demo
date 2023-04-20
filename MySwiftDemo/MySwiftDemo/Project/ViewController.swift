//
//  ViewController.swift
//  MySwiftDemo
//
//  Created by milk on 2023/4/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "home"
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = TableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

