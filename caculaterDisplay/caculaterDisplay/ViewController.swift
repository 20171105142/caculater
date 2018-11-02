//
//  ViewController.swift
//  caculaterDisplay
//
//  Created by 米正龙 on 2018/9/27.
//  Copyright © 2018年 米正龙. All rights reserved.
//

import UIKit


 extension Double{
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class ViewController: UIViewController {
    
    var temp = 0.0
    var temp1 = ""
    var sum = 0.0
    var val = ""
    var sum1 = 0
    @IBOutlet weak var caculateDisplay: UILabel!
    var num:Bool = true
    
    @IBAction func Button0(_ sender: Any) {
        if caculateDisplay.text == "0"{
        //caculateDisplay.text = caculateDisplay.text!+"0"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"0"
        }
        
    }
    @IBAction func Button1(_ sender: Any) {
        if caculateDisplay.text == "0"{
        caculateDisplay.text = "1"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"1"
        }
        //caculateDisplay1.text = caculateDisplay1.text!+"1"
    }
    @IBAction func Button2(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "2"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"2"
        }
    }
    @IBAction func Button3(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "3"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"3"
        }
    }
    @IBAction func Button4(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "4"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"4"
        }
    }
    @IBAction func Button5(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "5"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"5"
        }
    }
    @IBAction func Button6(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "6"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"6"
        }
    }
    @IBAction func Button7(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "7"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"7"
        }
        //caculateDisplay1.text = caculateDisplay1.text!+"7"
    }
    @IBAction func Button8(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "8"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"8"
        }
        
    }
    @IBAction func Button9(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "9"
        }else{
            caculateDisplay.text = caculateDisplay.text!+"9"
        }
    }
    @IBAction func buttonDot(_ sender: Any) {
        
        if caculateDisplay.text == "" && num{
            caculateDisplay.text = "0."
        }else if num {
            caculateDisplay.text = caculateDisplay.text!+"."
        }
        num = false
      
    }
    @IBAction func clear(_ sender: Any) {
        caculateDisplay.text = "0"
        num = true
        //caculateDisplay1.text = ""
    }
    @IBAction func buttonAdd(_ sender: Any) {//加法
        temp = Double(caculateDisplay.text!)!
        val = "+"
        caculateDisplay.text = "0"
        num = true
        //caculateDisplay1.text = caculateDisplay1.text!+"+"
    }
    @IBAction func buttonSub(_ sender: Any) {//减法
        temp = Double(caculateDisplay.text!)!
        val = "-"
        caculateDisplay.text = "0"
        num = true
    }
    @IBAction func buttonMul(_ sender: Any) {//乘法
        temp = Double(caculateDisplay.text!)!
        val = "*"
        caculateDisplay.text = "0"
        num = true
    }
    @IBAction func buttonDiv(_ sender: Any) {//除法
        temp = Double(caculateDisplay.text!)!
        val = "/"
        caculateDisplay.text = "0"
        num = true
    }
    @IBAction func buttonBs(_ sender: Any) {//退格
        (caculateDisplay.text!).remove(at: (caculateDisplay.text!).index(before: (caculateDisplay.text!).endIndex))
      
    }
    @IBAction func buttonCaculator(_ sender: Any) {//等于
     //   switch num{
      //  case !num:
        
            switch val {
            case "+":
                sum = temp + Double(caculateDisplay.text!)!
            case "-":
                sum = temp - Double(caculateDisplay.text!)!
            case "*":
                sum = temp * Double(caculateDisplay.text!)!
            case "/":
               // temp1 = caculateDisplay.text
                //if temp1 == "0" {
                  //  caculateDisplay.text = "2"
                    //} else {
                    sum = temp / Double(caculateDisplay.text!)!
                //}
            default :
                break
            }
       
       /* case num:
           
            switch val {
                case "+":
                    sum = Int(temp) + Int(caculateDisplay.text!)!
                case "-":
                    sum = Int(temp) - Int(caculateDisplay.text!)!
                case "*":
                    sum = Int(temp) * Int(caculateDisplay.text!)!
                case "/":
                    sum = Int(temp) / Int(caculateDisplay.text!)!
                default :
                    break
             }
        default :
            break
        }*/
        //sum = sum + Int(caculateDisplay.text!)!
        
        
        //if sum {
           
            
        //   if sum.truncatingRemainder(dividingBy: 1.0) == 0.0{
      //          sum1 = Int(sum)
       //         caculateDisplay.text = "\(sum1)"
       //     }else{
                caculateDisplay.text = "\(sum.roundTo(places: 10))"
        //    }
            
     /*   }else {
            sum1 = Int(sum)
            caculateDisplay.text = "\(sum1)"
        }*/
        
        
        
       // let distanceInM: Double = 1234.56789
       
       // print(visibleDistanceInM)
        //caculateDisplay.text = "\(sum)"
        //caculateDisplay.text = "sum"
        //caculateDisplay1.text = caculateDisplay.text
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

