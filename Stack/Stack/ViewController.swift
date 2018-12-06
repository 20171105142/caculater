//
//  ViewController.swift
//  Stack
//
//  Created by 米正龙 on 2018/11/1.
//  Copyright © 2018 米正龙. All rights reserved.
//

import UIKit

public struct Stack <T>{
    fileprivate var array: [T] = []
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        return array.popLast()
    }
    
    func peek() -> T? {
        return array.last
    }
    var isEmpty: Bool{
        return array.isEmpty
    }
    var count:Int{
        return array.count
    }
}

public func digitalJudgment(number:Character)->Bool
{
    if number >= "0" && number <= "9" {
        return true;
    }
    else{
        return false;
    }
}
public func priority(pri:Character)->Int
{
    switch pri{
    case "#":
        return 0
    case "(":
        return 1
    case "+":
        return 2
    case "-":
        return 2
    case "*":
        return 3
    case "/":
        return 3
    case ")":
        return 4
    default:
        return -1
    }
}

public func addSpace(adS:inout [Character] )
 {//添加空格
    adS.append (" ")
 }

public func getNumber(number:Character)->Double
 {
    var num = [Character]()
    
    if number != " " {
        num.append(number)
    }
    let arrayStr = String(num)
    print(atof( arrayStr))
    return atof( arrayStr)
}

public func Cauculate( ch:Character, left:Double , right:Double )->Double//各个操作符对应的操作
 {
     switch ch
     {
        case "+":
        return left + right;
        case "-":
        return left - right;
        case "*":
        return left * right;
        case "/":
        return left / right;
        default:
        return 0;
     }
 }

 public func readSuffix(Operand:inout [Character])->Double
 {
    var a:Double = 0.0
    var b:Double = 0.0
    var num = [Character]()
    var arrayStr:String = ""
    var numberStack = Stack<Double>()
    for res in Operand{
        if (res == " "){
     //遇到空格跳过
            arrayStr = String(num)//将num数组转换为arrayStr字符串
            if arrayStr == ""{//当num为空时清空数组
                num.removeAll()
            }else {
                num.removeAll()
                numberStack.push(atof(arrayStr))//arrayStr字符串转换为doublel类型并进入数字堆栈
            }
        }else if(res != "*" && res != "+" && res != "-" && res != "/" && res != " ") {
            num.append(res)
                }else {
                    a = numberStack.peek()!//第一个运算数
                    numberStack.pop();
                    if(numberStack.isEmpty) {//当数字堆栈为空时只有一个运算符-6*5
                        numberStack.push(Cauculate(ch: "*", left: -1, right: a))
                    } else {
                        b = numberStack.peek()!
                        numberStack.pop();
                        numberStack.push(Cauculate(ch: res, left: b, right: a))//遇到符号时，取栈顶的第二个数和第一个数求解，并入栈
                    }
 
                }
    }
    
    while numberStack.count >= 2 {//最终栈内存在的数大于2时，继续计算，直到只剩下一个数{
        a = numberStack.peek()!
        numberStack.pop();
        b = numberStack.peek()!
        numberStack.pop();
        //numberStack.push(Cauculate(ch: res, left: b, right: a))
        numberStack.push(Cauculate(ch: Operand.last!, left: b, right: a))
     }
    
    print(numberStack.peek()!)
    return numberStack.peek()!
    
}
 
 
class ViewController: UIViewController {
    
    
    
    func Suffix(str:String) {//输入后缀表达式
        var Operand = [Character]()
    
        var calStack = Stack<Character>()
        calStack.push("#")
        var str1:String = ""
        str1 = str
        if str.contains("(-") {
            //将(-改为(0-方便运算
            print("字符串包含(-")
            str1 = str.replacingOccurrences(of: "(-", with: "(0-")//字符串替换
        }
        for ope in str1 {
            
            if !digitalJudgment(number:ope) && ope != "." {
                //在数字的字符串后面增加空格，组成多位数或小数
                    addSpace(adS: &Operand)
                //}
            if ope==")" {//')'输入堆栈中'('之前的全部符号
                while calStack.peek() != "(" {
                    Operand.append(calStack.peek()!)//为Operand增加符号
                    calStack.pop()
                    addSpace(adS: &Operand)
                }
                calStack.pop()
            }else if ope == "("  {//'('直接进栈
                calStack.push(ope);
            }else if priority(pri:ope)>priority(pri:calStack.peek()!)  {//如果栈外优先级大于栈顶优先级
                calStack.push(ope)
            }else if priority(pri:ope)<=priority(pri:calStack.peek()!) {//如果栈外优先级小于等于栈顶优先级
                repeat {
                    Operand.append(calStack.peek()!)
                calStack.pop()
               addSpace(adS: &Operand)
                }while priority(pri:ope)<=priority(pri:calStack.peek()!)//栈外小于栈顶，输出到栈内与栈外相等运算符的优先级
                 calStack.push(ope)
                }
            }
            if digitalJudgment(number:ope) || ope == "." {//当ope为数字或者是小数点时进入字符串数组
            Operand.append(ope)
            }
        }
        
        while calStack.peek() != "#" {//将堆栈中剩余操作符输出
            addSpace(adS: &Operand)
            
            Operand.append(calStack.peek()!)
            calStack.pop()
        }
       print(Operand)
        Text.text = String(readSuffix( Operand: &Operand))
    }
    
    
    

    
    @IBOutlet weak var Text: UILabel!
    
    @IBAction func Button5(_ sender: Any) {
        Text.text = Text.text!+"5"
 
    }
    @IBAction func Button9(_ sender: Any) {
        Text.text = Text.text!+"9"
   
    }
    @IBAction func ButtonMul(_ sender: Any) {
        Text.text = Text.text!+"*"
    
    }
    @IBAction func ButtonAdd(_ sender: Any) {
        Text.text = Text.text!+"+"
     
    }
    @IBAction func ButtonRes(_ sender: Any) {
        
        Suffix(str:Text.text!)
    }
    
    @IBAction func ButtonLift(_ sender: Any) {
         Text.text = Text.text!+"("
    }
    
    @IBAction func ButtonRight(_ sender: Any) {
         Text.text = Text.text!+")"
    }
    
    @IBAction func ButtonDot(_ sender: Any) {
        Text.text = Text.text!+"."
    }
    
    @IBAction func Button0(_ sender: Any) {
        Text.text = Text.text!+"0"
    }
    
    @IBAction func ButtonSub(_ sender: Any) {
        
        Text.text = Text.text!+"-"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


