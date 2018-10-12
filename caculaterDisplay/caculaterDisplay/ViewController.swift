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
    var val = ""
    @IBOutlet weak var caculateDisplay: UILabel!
    @IBAction func Button0(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"0"
        
    }
    @IBAction func Button1(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"1"
        //caculateDisplay1.text = caculateDisplay1.text!+"1"
    }
    @IBAction func Button2(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"2"
    }
    @IBAction func Button3(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"3"
    }
    @IBAction func Button7(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"7"
        //caculateDisplay1.text = caculateDisplay1.text!+"7"
    }
    @IBAction func buttonDot(_ sender: Any) {
        caculateDisplay.text = caculateDisplay.text!+"."
    }
    @IBAction func clear(_ sender: Any) {
        caculateDisplay.text = ""
        //caculateDisplay1.text = ""
    }
    @IBAction func buttonAdd(_ sender: Any) {//加法
        temp=Int(caculateDisplay.text!)!
        val = "+"
        
        //caculateDisplay1.text = caculateDisplay1.text!+"+"
        caculateDisplay.text = ""
    }
    @IBAction func buttonSub(_ sender: Any) {//减法
        temp=Int(caculateDisplay.text!)!
        val = "-"
        caculateDisplay.text = ""
    }
    @IBAction func buttonMul(_ sender: Any) {//乘法
        temp=Int(caculateDisplay.text!)!
        val = "*"
        caculateDisplay.text = ""
    }
    @IBAction func buttonDiv(_ sender: Any) {//除法
        temp=Int(caculateDisplay.text!)!
        val = "/"
        caculateDisplay.text = ""
    }
    @IBAction func buttonCaculator(_ sender: Any) {//等于
        switch val {
        case "+":
            sum = temp + Int(caculateDisplay.text!)!
        case "-":
            sum = temp - Int(caculateDisplay.text!)!
        case "*":
            sum = temp * Int(caculateDisplay.text!)!
        case "/":
            sum = temp / Int(caculateDisplay.text!)!
        default :
            print("error")
        }
        
        //sum = sum + Int(caculateDisplay.text!)!
        caculateDisplay.text = "\(sum)"
        //caculateDisplay1.text = caculateDisplay.text
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

