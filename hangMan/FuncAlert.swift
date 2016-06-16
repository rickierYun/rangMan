//
//  File.swift
//  hangMan
//
//  Created by 欧阳云慧 on 16/6/14.
//  Copyright © 2016年 欧阳云慧. All rights reserved.
//

import Foundation
import UIKit

// 这个是我以前写的alert封装 其中有段代码没高兴删除
public func showAlert<T>(title: String,message: String,alertTitle: String,viewController: T,showTheWindows: Bool) {

    let showSuccess = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    var makeSureA = UIAlertAction()

    makeSureA = UIAlertAction(title: alertTitle, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
        if showTheWindows{
            let window = UIApplication.sharedApplication().windows[0]
            window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("main") as?
            UITabBarController
        }

    })

    showSuccess.addAction(makeSureA)
    (viewController as? UIViewController)!.presentViewController(showSuccess, animated: true, completion: nil)
}

