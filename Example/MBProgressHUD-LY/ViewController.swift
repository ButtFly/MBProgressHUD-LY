//
//  ViewController.swift
//  MBProgressHUD-LY
//
//  Created by ButtFly on 01/17/2020.
//  Copyright (c) 2020 ButtFly. All rights reserved.
//

import UIKit
import MBProgressHUD_LY

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            DispatchQueue.main.async {
                print("显示文字")
                self.ly_showTextHub(text: "显示文字")
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 4) {
            DispatchQueue.main.async {
                print("显示成功")
                self.ly_showSuccessHud(text: nil)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 6) {
            DispatchQueue.main.async {
                print("显示失败")
                self.ly_showFailureHud(text: "大声道奥术大师")
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 8) {
            DispatchQueue.main.async {
                print("显示loading")
                self.ly_showLoadingHUD(text: "安徽省的")
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 10) {
            DispatchQueue.main.async {
                print("开始隐藏")
                self.ly_hideHud()
            }
        }
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

