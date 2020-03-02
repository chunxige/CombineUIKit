//
//  ViewController.swift
//  CombineWithUIKit
//
//  Created by chunxi on 2020/2/28.
//  Copyright © 2020 chunxi. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
     
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var textTF: UITextField!
    
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancellable = textTF.publisherEvent(.editingChanged).map(\.text).map({$0 ?? ""}).sink { (text) in
            print(text)
        }
    }
}
