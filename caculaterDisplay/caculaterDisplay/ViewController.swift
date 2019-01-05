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

enum ExpressionError : Error {
    case DividedZero//除数为0错误
    case OperandsError
}
func PrintError(number:Double) throws {
    if Int(number) == 0 {
        throw ExpressionError.DividedZero
    }
}
class ViewController: UIViewController {
    
    var LeftBracketsCount:Int = 0//左括号计数
    var RightBracketsCount:Int = 0//右括号计数
    var decimainPoint:Bool = false//判断小数点
    var judgmentResult:Bool = false//结果刷新
    var parenthesisJudgement:Bool = false //判断括号
    var DividedZero:Bool = false//被除数为0
    var OperandsError:Bool = false//运算数为0
    var numberCount:Int = 0//数字计数
    var operatorCount:Int = 0//运算符计数
    var decimalCount:Int = 0//小数点后位数计数
    
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
        case "%":
            return 4
        case ")":
            return 5
        default:
            return -1
        }
    }
    
    public func deleteZero (result:String )->String {
        //删除结果中".0"
        var tempResult = result
        var i = 1
        if result.contains(".") {
            while i < result.count {
                if tempResult.hasSuffix("0") {
                    tempResult.remove(at: tempResult.index(before: tempResult.endIndex))
                    i = i + 1
                } else {
                    break
                }
            }
            if tempResult.hasSuffix(".") {
                tempResult.remove(at: tempResult.index(before: tempResult.endIndex))
            }
            return tempResult
        } else {
            return result
        }
    }
    
    public func addSpace(blank:inout [Character] )
    {   //为数字后添加空格
        blank.append (" ")
    }

    public func cauculate( ch:Character, left:Double , right:Double )->String
    {
        //对运算数和运算符进行计算
        switch ch {
        case "+"://加法
            return String(left + right)
        case "-"://减法
            return String(left - right)
        case "×"://乘法
            return String(left * right)
        case "÷"://除法
            do {
                try PrintError(number: right)
                return String(left / right)
            } catch {
                switch (error){
                case ExpressionError.DividedZero:DividedZero = false
                default:
                    promptBox(text: "未知错误")
                }
            }
        case "%"://百分号运算
            return String(right / left)
        default:
            return "error"
        }
        return "error"
    }
    
    public func readSuffix(suffix:inout [Character])->String {
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
                if (numberStack.peek() != nil){
                a = numberStack.peek()!//第一个运算数
                _=numberStack.pop()
                } else {
                 OperandsError = false
                }
                if sff == "%" {//百分号运算
                    numberStack.push(Double(cauculate(ch: sff, left: 100, right: a))!)
                } else {
                    if (numberStack.peek() != nil) {
                    b = numberStack.peek()!
                    _=numberStack.pop()
                        if cauculate(ch: sff, left: b, right: a) != "error" {
                            numberStack.push(Double(cauculate(ch: sff, left: b, right: a))!)
                        }
                    //遇到符号时，取栈顶的第二个数和第一个数求解，并入栈
                    } else {
                     OperandsError = false
                     }
                }
            }
        }
        while numberStack.count >= 2 {
            //最终栈内存在的数大于2时，继续计算，直到只剩下一个数
            a = numberStack.peek()!
            _=numberStack.pop()
            b = numberStack.peek()!
            _=numberStack.pop()
            numberStack.push(Double(cauculate(ch: suffix.last!, left: b, right: a))!)
        }
        if (numberStack.peek() == nil) {
        OperandsError = false
        } else {
        return String(numberStack.peek()!)
        }
        return "error"
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
        if readSuffix(suffix: &suffix) != "error" {
            SubsidiaryDisplay.text = "\(deleteZero(result: String(Double(readSuffix(suffix: &suffix))!.roundTo(places: 10))))"
        }
    }
    
    public func promptBox(text:String)
    {
        //提示框
        let alertController = UIAlertController(title: text,message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    public func numberButton(number:String)//数字按键函数
    {
        var last:Character = " "
        if numberCount == 15 {
            promptBox(text: "最大数字位数为15")
        } else if decimalCount == 10 {
            promptBox(text: "小数后最大数字位数为10")
        } else {
            if caculateDisplay.text! == ""{//屏幕为空时
                caculateDisplay.text = number
            } else if !judgmentResult {//没有按下等号
                last = caculateDisplay.text!.last!
                if last == ")" || last == "%" {
                    //最后一位 为“），%”
                    caculateDisplay.text = caculateDisplay.text!+"×"+number
                }else if caculateDisplay.text! == "0" {//屏幕只有零
                    caculateDisplay.text = number
                } else {
                    caculateDisplay.text = caculateDisplay.text!+number
                }
            } else {
                caculateDisplay.text = number
            }
            if decimainPoint {
                decimalCount = decimalCount + 1
            }
            numberCount = numberCount + 1
            judgmentResult = false
            parenthesisJudgement = true//括号判断
        }
        postfixExpression(str:caculateDisplay.text!)
    }
    
    public func operatorButton(operator1:String)//运算符按键函数
    {
        var last:Character = " "
        if operatorCount == 20  {
            promptBox(text: "最多可添加20个运算符号")
        } else if caculateDisplay.text! == "" {
        } else {
            
            last = caculateDisplay.text!.last!
            if JudgementNumber(number:last) || last == ")" || last == "%" {
                //数字，右括号，百分号
                caculateDisplay.text = caculateDisplay.text!+operator1
            }
            if operator1 == "-" && last == "(" {
                caculateDisplay.text = caculateDisplay.text!+"-"
            }
            decimainPoint = false
            operatorCount = operatorCount + 1
            numberCount = 0
        }
        SubsidiaryDisplay.text = ""
    }
    
    @IBOutlet weak var caculateDisplay: UILabel!
    @IBOutlet weak var SubsidiaryDisplay: UILabel!
    
    @IBAction func Button0(_ sender: Any) {
        numberButton(number: "0")
    }
    @IBAction func Button1(_ sender: Any) {
        numberButton(number: "1")
    }
    @IBAction func Button2(_ sender: Any) {
        numberButton(number: "2")
    }
    @IBAction func Button3(_ sender: Any) {
        numberButton(number: "3")
    }
    @IBAction func Button4(_ sender: Any) {
        numberButton(number: "4")
    }
    @IBAction func Button5(_ sender: Any) {
        numberButton(number: "5")
    }
    @IBAction func Button6(_ sender: Any) {
        numberButton(number: "6")
    }
    @IBAction func Button7(_ sender: Any) {
        numberButton(number: "7")
    }
    @IBAction func Button8(_ sender: Any) {
        numberButton(number: "8")
    }
    @IBAction func Button9(_ sender: Any) {
        numberButton(number: "9")
    }
    @IBAction func ButtonDot(_ sender: Any) {//小数点
        var last:Character = " "
        if caculateDisplay.text! == "" {//当屏幕为空时
            caculateDisplay.text = "0."
        } else if !decimainPoint {//没有按下小数点或按下操作符
            last = caculateDisplay.text!.last!
            if !JudgementNumber(number:last) {//前一位非数字
                if last == ")" || last == "%" {
                    caculateDisplay.text = caculateDisplay.text!+"×0."
                } else {
                    caculateDisplay.text = caculateDisplay.text!+"0."
                }
            } else {
                caculateDisplay.text = caculateDisplay.text!+"."
            }
            decimainPoint = true//小数点
           
        }
    }
    
    @IBAction func ButtonBrackets(_ sender: Any) {//括号
        var last:Character = " "
        if caculateDisplay.text! == "" {//屏幕为空时
            caculateDisplay.text = caculateDisplay.text!+"("
            LeftBracketsCount = LeftBracketsCount + 1
        } else {
            last = caculateDisplay.text!.last!
            if !parenthesisJudgement || LeftBracketsCount == RightBracketsCount {//按下数字h或左右括号数量相等
                if JudgementNumber(number:last) || last == ")" || last == "%" || last == "." {
                    //在数字，右括号，百分号后面
                    caculateDisplay.text = caculateDisplay.text!+"×("
                    decimainPoint = false
                    LeftBracketsCount = LeftBracketsCount + 1
                    operatorCount = operatorCount + 1
                } else {
                    caculateDisplay.text = caculateDisplay.text!+"("
                    LeftBracketsCount = LeftBracketsCount + 1
                }
            } else if parenthesisJudgement && RightBracketsCount < LeftBracketsCount {
                //左h括号数量大于右括号
                if last == "×" || last == "("{
                    caculateDisplay.text = caculateDisplay.text!+"("
                    LeftBracketsCount = LeftBracketsCount + 1
                } else {
                    caculateDisplay.text = caculateDisplay.text!+")"
                    decimainPoint = false
                    RightBracketsCount = RightBracketsCount + 1
                }
            }
        }
        if LeftBracketsCount == RightBracketsCount {//当左括号数量等于右括号时
            parenthesisJudgement = false
        }
    }
    @IBAction func ButtonClear(_ sender: Any) {
        caculateDisplay.text = ""
        SubsidiaryDisplay.text = ""
        decimainPoint = false//判断小数点
        judgmentResult = false//判断结果
        parenthesisJudgement = false//括号判断
        DividedZero = false
        OperandsError = false
        LeftBracketsCount = 0//左括号
        RightBracketsCount = 0//右括号
        numberCount = 0
        operatorCount = 0
        decimalCount = 0
    }
    @IBAction func buttonAdd(_ sender: Any) {//加法
        operatorButton(operator1: "+")
    }
    @IBAction func buttonSub(_ sender: Any) {//减法
        operatorButton(operator1: "-")
    }
    @IBAction func buttonMul(_ sender: Any) {//乘法
        operatorButton(operator1: "×")
    }
    @IBAction func buttonDiv(_ sender: Any) {//除法
        operatorButton(operator1: "÷")
    }
    @IBAction func ButtonPercentage(_ sender: Any) {//百分比运算
        var last:Character = " "
        if caculateDisplay.text! == "" {
        } else {
            last = caculateDisplay.text!.last!
            if JudgementNumber(number:last) || last == ")" || last == "%"{
                //在数字和右括号后面
                caculateDisplay.text = caculateDisplay.text!+"%"
                operatorCount = operatorCount + 1
            }
            decimainPoint = false
            numberCount = 0
        }
        postfixExpression(str:caculateDisplay.text!)
    }
    @IBAction func buttonBrs(_ sender: Any) {//(-
        var last:Character = " "
        if caculateDisplay.text! == "" {//屏幕为空
            caculateDisplay.text = "(-"
            LeftBracketsCount = LeftBracketsCount + 1
            operatorCount = operatorCount + 1
        } else {
            last = caculateDisplay.text!.last!
            if JudgementNumber(number:last) || last == ")" || last == "%" {//数字后面,右括号，百分号
                caculateDisplay.text = caculateDisplay.text!+"×(-"
                LeftBracketsCount = LeftBracketsCount + 1
                operatorCount = operatorCount + 2
            } else if last == "." {
            } else {
                caculateDisplay.text = caculateDisplay.text!+"(-"
                LeftBracketsCount = LeftBracketsCount + 1
                operatorCount = operatorCount + 1
            }
        }
    }
    @IBAction func buttonBs(_ sender: Any) {//退格
        var last:Character = " "
        //str = caculateDisplay.text!
        if caculateDisplay.text! == ""{
        } else {
            if judgmentResult {
                judgmentResult = false
            }
            last = caculateDisplay.text!.last!
            if last == "(" {//删除左括号
                (caculateDisplay.text!).remove(at: (caculateDisplay.text!).index(before: (caculateDisplay.text!).endIndex))//清除最后一位
                LeftBracketsCount = LeftBracketsCount - 1
            } else if last == ")" {//删除右括号
                (caculateDisplay.text!).remove(at: (caculateDisplay.text!).index(before: (caculateDisplay.text!).endIndex))//清除最后一位
                RightBracketsCount = RightBracketsCount - 1
            } else if JudgementNumber(number:last) {//删除数字
                (caculateDisplay.text!).remove(at: (caculateDisplay.text!).index(before: (caculateDisplay.text!).endIndex))//清除最后一位
                //数字-1
                numberCount = numberCount - 1
                SubsidiaryDisplay.text = ""
            } else if last == "." {
                (caculateDisplay.text!).remove(at: (caculateDisplay.text!).index(before: (caculateDisplay.text!).endIndex))//清除最后一位
                decimalCount = decimalCount - 1
                decimainPoint = false//判断小数点
            } else if !JudgementNumber(number:last) || last != "." {
                (caculateDisplay.text!).remove(at: (caculateDisplay.text!).index(before: (caculateDisplay.text!).endIndex))//清除最后一位
                operatorCount = operatorCount - 1
            }
        }
        postfixExpression(str:caculateDisplay.text!)
    }
    @IBAction func buttonCaculator(_ sender: Any) {//等于
     //   switch num{
      //  case !num:
        //w=414   h=666
        
        //let button1:UIButton = UIButton(type:.contactAdd)
        if caculateDisplay.text! == "" {//屏幕为空时
        } else if operatorCount == 0 {
        } else {
            while LeftBracketsCount != RightBracketsCount {
                //当左右括号数量不相等时，补全括号
                caculateDisplay.text = caculateDisplay.text!+")"
                RightBracketsCount = RightBracketsCount + 1
                }
                //postfixExpression(str:caculateDisplay.text!)
            if DividedZero {
                print(DividedZero)
                promptBox(text: "不可除以0")
            } else if OperandsError {
                promptBox(text: "格式错误")
            } else {
                caculateDisplay.text! = SubsidiaryDisplay.text!
                SubsidiaryDisplay.text = ""
                decimainPoint = false//判断小数点
                judgmentResult = true//判断结果
                parenthesisJudgement = false//括号判断
                LeftBracketsCount = 0//左括号
                RightBracketsCount = 0//右括号
                numberCount = 0//数字计数
                operatorCount = 0//运算符计数
            }
        }
        
        if LeftBracketsCount == RightBracketsCount {//当左括号数量等于右括号时
            
        }
    }
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button5: UIButton!
    @IBOutlet weak var Button6: UIButton!
    @IBOutlet weak var Button7: UIButton!
    @IBOutlet weak var Button8: UIButton!
    @IBOutlet weak var Button9: UIButton!
    @IBOutlet weak var ButtonCle: UIButton!
    @IBOutlet weak var ButtonBra: UIButton!
    @IBOutlet weak var ButtonPer: UIButton!
    @IBOutlet weak var ButtonDiv: UIButton!
    @IBOutlet weak var ButtonMul: UIButton!
    @IBOutlet weak var ButtonSub: UIButton!
    @IBOutlet weak var ButtonAdd: UIButton!
    @IBOutlet weak var ButtonBrs: UIButton!
    @IBOutlet weak var ButtonDot: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        caculateDisplay.lineBreakMode = NSLineBreakMode.byWordWrapping
        caculateDisplay.numberOfLines = 0
        // 文本换行
        ButtonCle.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonCle.layer.borderWidth = 1
        
        
        
        ButtonPer.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonPer.layer.borderWidth = 1
        
        ButtonDiv.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonDiv.layer.borderWidth = 1
        
        ButtonMul.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonMul.layer.borderWidth = 1
        
        ButtonSub.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonSub.layer.borderWidth = 1
        
        ButtonAdd.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonAdd.layer.borderWidth = 1
        
        ButtonBra.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonBra.layer.borderWidth = 1
        
        ButtonBrs.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonBrs.layer.borderWidth = 1
        
        ButtonDot.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        ButtonDot.layer.borderWidth = 1
        
        Button.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button.layer.borderWidth = 1
        
        Button1.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button1.layer.borderWidth = 1
        
        Button2.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button2.layer.borderWidth = 1
        
        Button3.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button3.layer.borderWidth = 1
        
        Button4.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button4.layer.borderWidth = 1
        
        Button5.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button5.layer.borderWidth = 1
        
        Button6.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button6.layer.borderWidth = 1
        
        Button7.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button7.layer.borderWidth = 1
        
        Button8.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button8.layer.borderWidth = 1
        
        Button9.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.1).cgColor
        Button9.layer.borderWidth = 1
        
    }
}

