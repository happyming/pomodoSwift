//
//  ViewController.swift
//  pomodoSwift
//
//  Created by 光明 徐 on 15/4/3.
//  Copyright (c) 2015年 Guangming Xu. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var totalSeconds = 25*60
    var timer: NSTimer?
    var dateTime: NSDate?
    var workButton = 0  //工作按钮的状态机 0 初始状态 1 工作状态 2 休息状态 3 重置状态 可以避免重复设置定时器的问题
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var startWorkButton: UIButton!
    @IBOutlet weak var restButton: UIButton!
    

    @IBOutlet weak var timeLable: UILabel!
    
    //休息
    @IBAction func rest(sender: AnyObject) {
        if self.workButton == 2 {
            return
        }
        
        stopTimer()
        self.timeLable.text = "05:00"
        self.restButton.backgroundColor = UIColor.yellowColor()
        self.totalSeconds = 5 * 60 - 1
        
        var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "workSeconds", userInfo: nil, repeats: true)
        self.timer = timer
        addLocalNotification(5.0 * 60 - 1, alertString: "休息时间到啦！")
        self.dateTime = NSDate()
        self.workButton = 2
    }
    
    //开始一个番茄钟
    @IBAction func startWork(sender: AnyObject) {
        if self.workButton == 1 {
            return
        }
        
        stopTimer()
        self.timeLable.text = "25:00"
        self.startWorkButton.backgroundColor = UIColor.yellowColor()
        self.totalSeconds = 25 * 60 - 1
        
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "workSeconds", userInfo: nil, repeats: true)
        self.timer = timer
        
        addLocalNotification(25.0 * 60 - 1, alertString: "番茄钟时间到啦！")
        self.dateTime = NSDate()
        self.workButton = 1
    }
    
    //重新设置
    @IBAction func reset(sender: AnyObject) {
        if self.workButton == 3 {
            return
        }
        
        self.timeLable.text = "25:00"
        stopTimer()
        self.workButton = 3
    }
    
    //开始 休息 重设都要先关掉其他的定时器
    func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
        }
        
        switch self.workButton {
        case 1:
            self.startWorkButton.backgroundColor = UIColor.whiteColor()
        case 2:
            self.restButton.backgroundColor = UIColor.whiteColor()
        default: return
        }
        
        // 移除已设的本地通知
        self.removeNotification()
    }
    
    // 用于显示剩余时间
    func workSeconds() {
        var minutes, seconds:String
        
        var remainingTime = self.totalSeconds + Int(self.dateTime!.timeIntervalSinceNow)
        
        if remainingTime / 60 < 10 {
            minutes = "0\(remainingTime / 60)"
        } else {
            minutes = "\(remainingTime / 60)"
        }
        
        if remainingTime % 60 < 10 {
            seconds = "0\(remainingTime % 60)"
        } else {
            seconds = "\(remainingTime % 60)"
        }
        
        if remainingTime <= 0 {
            stopTimer()
            self.timeLable.text = "00:00"
            self.workButton = 0
            return
        }
        
        self.timeLable.text = minutes + ":" + seconds
        println(minutes + ":" + seconds)
        println("\(self.dateTime!.timeIntervalSinceNow)")
    }
 
    
    // 设置本地通知的一些事项
    func addLocalNotification(seconds: Double, alertString: String) {
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: seconds)
        notification.alertBody = alertString
        notification.alertAction = "打开应用"
        notification.alertLaunchImage = "Default"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // 移除通知
    func removeNotification() {
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
}

