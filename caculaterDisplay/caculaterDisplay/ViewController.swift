//
//  ViewController.swift
//  caculaterDisplay
//
//  Created by 米正龙 on 2018/9/27.
//  Copyright © 2018年 米正龙. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var temp = 0
    var sum = 0
    @IBOutlet weak var caculateDisplay: UILabel!
    
    @IBOutlet weak var caculateDisplay1: UILabel!
    
    
    @IBAction func Button0(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"0"
        
    }
    @IBAction func Button1(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"1"
        caculateDisplay1.text = caculateDisplay1.text!+"1"
    }
    @IBAction func Button7(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"7"
        caculateDisplay1.text = caculateDisplay1.text!+"7"
    }
    @IBAction func clear(_ sender: Any) {
        caculateDisplay.text = ""
        caculateDisplay1.text = ""
    }
    @IBAction func buttonAdd(_ sender: Any) {
        //temp=Int(caculateDisplay.text!)!
     
        temp=Int(caculateDisplay.text!)!
        
        sum+=temp
        caculateDisplay1.text = caculateDisplay1.text!+"+"
        
        caculateDisplay.text = ""
    }
    @IBAction func buttonCaculator(_ sender: Any) {
        
        sum = sum + Int(caculateDisplay.text!)!
        caculateDisplay.text = "\(sum)"
        caculateDisplay1.text = caculateDisplay.text
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

