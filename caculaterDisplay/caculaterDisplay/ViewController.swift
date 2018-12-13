//
//  ViewController.swift
//  caculaterDisplay
//
//  Created by 米正龙 on 2018/9/27.
//  Copyright © 2018年 米正龙. All rights reserved.
//

import UIKit

public struct Stack <T>{
    //堆栈定义
    fileprivate var array: [T] = []//堆栈数组
    
    mutating func push(_ element: T) {//入栈
        array.append(element)
    }
    
    mutating func pop() -> T? {//出栈
        return array.popLast()
    }
    
    func peek() -> T? {//栈顶
        return array.last
    }
    var isEmpty: Bool{//判断堆栈是否为空
        return array.isEmpty
    }
    var count:Int{//堆栈元素个数
        return array.count
    }
}

extension Double{
    public func roundTo(places: Int) -> Double
    {
        //小数四舍五入
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}



class ViewController: UIViewController {
    
    var temp = 0.0
    var sum = 0.0
    var val = ""
    var sum1 = 0
    var decimainPoint:Bool = true//判断小数点
    var judgmentResult:Bool = false//判断结果
    var parenthesisJudgement:Bool = true //判断括号
    
    public func JudgementNumber(number:Character)->Bool
    {
        //判断字符是否为数字
        if number >= "0" && number <= "9" {
            return true;
        }
        else{
            return false;
        }
    }
    
    public func operatorPriority(opp:Character)->Int
    {
        //运算符优先级判断
        switch opp{
        case "#":
            return 0
        case "(":
            return 1
        case "+":
            return 2
        case "-":
            return 2
        case "×":
            return 3
        case "÷":
            return 3
        case ")":
            return 4
        default:
            return -1
        }
    }
    
    public func addSpace(blank:inout [Character] )
    {   //为数字后添加空格
        blank.append (" ")
    }

    public func cauculate( ch:Character, left:Double , right:Double )->Double
    {
        //对运算数和运算符进行计算
        switch ch {
            
        case "+"://加法
            return left + right
        case "-"://减法
            return left - right
        case "×"://乘法
            return left * right
        case "÷"://除法
            if right == 0.0 {
                let alertController = UIAlertController(title: "不可除以零",message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            } else {
                return left / right;
            }
        default:
            return 0
        }
        return 0
    }
    
    public func readSuffix(suffix:inout [Character])->Double {
        //读取后缀表达式
        var a:Double = 0.0//左运算数
        var b:Double = 0.0//右运算数
        var number = [Character]()
        var numberStr:String = ""
        var numberStack = Stack<Double>()//数字堆栈
        
        for sff in suffix {
            if sff == " " {//当遇到空格时
                numberStr = String (number)//将number数组转化为字符串
                if numberStr == "" {//当字符串为空时，将数组清空
                    number.removeAll()
                } else {
                    number.removeAll()
                    numberStack.push(atof(numberStr))//不为空时将多位数或小数进入数字堆栈
                }
            } else if JudgementNumber(number:sff) || sff == "." {//当遇到数字
                number.append(sff)
            } else {//当遇到运算符
                a = numberStack.peek()!//第一个运算数
                _=numberStack.pop()
                b = numberStack.peek()!
                _=numberStack.pop()
                numberStack.push(cauculate(ch: sff, left: b, right: a))
                //遇到符号时，取栈顶的第二个数和第一个数求解，并入栈
            }
        }
        while numberStack.count >= 2 {
            //最终栈内存在的数大于2时，继续计算，直到只剩下一个数
            a = numberStack.peek()!
            _=numberStack.pop()
            b = numberStack.peek()!
            _=numberStack.pop()
            numberStack.push(cauculate(ch: suffix.last!, left: b, right: a))
        }
        return numberStack.peek()!
    }
    
    public func postfixExpression(str:String)
    {
        //将中缀表达式改为后缀表达式
        var operatorStack = Stack<Character>()//运算符堆栈
        var suffix = [Character]()//存放后缀表达式数组
        var infix:String = ""//中缀表达式
        
        infix = str
        operatorStack.push("#")//最低优先级
        
        if str.contains("(-") {//将(-改为(0-方便运算
            infix = str.replacingOccurrences(of: "(-", with: "(0-")//字符串替换
        }
        for inf in infix {
            if !JudgementNumber(number:inf) && inf != "." {
                //当inf不是数字或小数点
                addSpace(blank: &suffix)
                //在数字的字符串后面增加空格，组成多位数或小数
                if inf == ")" {//当遇到右括号时
                    while operatorStack.peek() != "(" {//将堆栈中“（”之前的运算符全部输出
                        suffix.append(operatorStack.peek()!)//保存进后缀表达式
                        _=operatorStack.pop()
                        addSpace(blank: &suffix)
                    }
                    _=operatorStack.pop()//后缀表达式不含有括号
                } else if inf == "(" {//当遇到左括号时s直接进栈
                    operatorStack.push(inf)
                } else if operatorPriority(opp:inf)>operatorPriority(opp:operatorStack.peek()!) {
                    //如果栈外优先级大于栈顶优先级直接进栈
                    operatorStack.push(inf)
                } else if operatorPriority(opp:inf)<=operatorPriority(opp:operatorStack.peek()!) {
                    //如果栈外优先级小于或等于栈顶优先级
                    repeat {
                        suffix.append(operatorStack.peek()!)
                        _=operatorStack.pop()
                        addSpace(blank: &suffix)
                    }while operatorPriority(opp:inf)<=operatorPriority(opp:operatorStack.peek()!)
                    //栈外小于栈顶，输出到栈内与栈外相等运算符的优先级
                    operatorStack.push(inf)
                }
            }
            if JudgementNumber(number:inf) || inf == "." {
                //当inf为数字或者是小数点时
                suffix.append(inf)
            }
        }
        while operatorStack.peek() != "#" {//将堆栈中剩余操作符输出
            addSpace(blank: &suffix)
            suffix.append(operatorStack.peek()!)
            _=operatorStack.pop()
        }
        print(suffix)
        caculateDisplay.text = "\(readSuffix(suffix: &suffix).roundTo(places: 10))"
        //显示答案
    }
    
    @IBOutlet weak var caculateDisplay: UILabel!
    
    
    @IBAction func Button0(_ sender: Any) {
        if caculateDisplay.text == "0"{
        //caculateDisplay.text = caculateDisplay.text!+"0"
        } else if judgmentResult {
            caculateDisplay.text = "0"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"0"
        }
        judgmentResult = false
        parenthesisJudgement = false
    }
    @IBAction func Button1(_ sender: Any) {
        if caculateDisplay.text == "0"{
        caculateDisplay.text = "1"
        } else if judgmentResult {
            caculateDisplay.text = "1"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"1"
        }
        judgmentResult = false
        parenthesisJudgement = false
        //caculateDisplay1.text = caculateDisplay1.text!+"1"
    }
    @IBAction func Button2(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "2"
        } else if judgmentResult {
            caculateDisplay.text = "2"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"2"
        }
        judgmentResult = false
    }
    @IBAction func Button3(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "3"
        } else if judgmentResult {
            caculateDisplay.text = "3"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"3"
        }
        judgmentResult = false
        parenthesisJudgement = false
    }
    @IBAction func Button4(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "4"
        } else if judgmentResult {
            caculateDisplay.text = "4"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"4"
        }
        judgmentResult = false
        parenthesisJudgement = false
    }
    @IBAction func Button5(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "5"
        } else if judgmentResult {
            caculateDisplay.text = "5"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"5"
        }
        judgmentResult = false
    }
    @IBAction func Button6(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "6"
        } else if judgmentResult {
            caculateDisplay.text = "6"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"6"
        }
        judgmentResult = false
        parenthesisJudgement = false
    }
    @IBAction func Button7(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "7"
        } else if judgmentResult {
            caculateDisplay.text = "7"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"7"
        }
        judgmentResult = false
        parenthesisJudgement = false
        //caculateDisplay1.text = caculateDisplay1.text!+"7"
    }
    @IBAction func Button8(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "8"
        } else if judgmentResult {
            caculateDisplay.text = "8"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"8"
        }
        judgmentResult = false
        parenthesisJudgement = false
    }
    @IBAction func Button9(_ sender: Any) {
        if caculateDisplay.text == "0"{
            caculateDisplay.text = "9"
        } else if judgmentResult {
            caculateDisplay.text = "9"
        } else {
            caculateDisplay.text = caculateDisplay.text!+"9"
        }
        judgmentResult = false
        parenthesisJudgement = false
    }
    @IBAction func buttonDot(_ sender: Any) {
        var a:Character = " "
        if caculateDisplay.text! == ""{
            caculateDisplay.text = "0."
        } else {
            a = caculateDisplay.text!.last!
            if !JudgementNumber(number:a) {
                caculateDisplay.text = caculateDisplay.text!+"0."
            } else {
                caculateDisplay.text = caculateDisplay.text!+"."
            }
        }
        
        
        /*if caculateDisplay.text == "" && decimainPoint{
            caculateDisplay.text = "0."
        } else if decimainPoint {
            caculateDisplay.text = caculateDisplay.text!+"."
        }*/
        decimainPoint = false
    }
    
    @IBAction func buttonBrackets(_ sender: Any) {//括号
        if parenthesisJudgement {
            caculateDisplay.text = caculateDisplay.text!+"("
        } else {
            caculateDisplay.text = caculateDisplay.text!+")"
            
        }
    }
    @IBAction func clear(_ sender: Any) {
        caculateDisplay.text = "0"
        decimainPoint = true
        //caculateDisplay1.text = ""
    }
    @IBAction func buttonAdd(_ sender: Any) {//加法
        caculateDisplay.text = caculateDisplay.text!+"+"
        decimainPoint = true
        
    }
    @IBAction func buttonSub(_ sender: Any) {//减法
        caculateDisplay.text = caculateDisplay.text!+"-"
        decimainPoint = true
    }
    @IBAction func buttonMul(_ sender: Any) {//乘法
        
        caculateDisplay.text = caculateDisplay.text!+"×"
        decimainPoint = true
    }
    @IBAction func buttonDiv(_ sender: Any) {//除法
        caculateDisplay.text = caculateDisplay.text!+"÷"
        decimainPoint = true
    }
    @IBAction func buttonBs(_ sender: Any) {//退格
        if caculateDisplay.text! == "0"{
        } else {
        (caculateDisplay.text!).remove(at: (caculateDisplay.text!).index(before: (caculateDisplay.text!).endIndex))
        }
      
    }
    @IBAction func buttonCaculator(_ sender: Any) {//等于
     //   switch num{
      //  case !num:
        //w=375   h=666
        
        //let button1:UIButton = UIButton(type:.contactAdd)
        postfixExpression(str:caculateDisplay.text!)
        
        judgmentResult = true
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

