//
//  MBProgressHUD-LY.swift
//  MBProgressHUD
//
//  Created by 阿卡丽 on 2020/1/17.
//

import UIKit
import MBProgressHUD

extension UIImage {
    
    fileprivate class func ly_inSelfBundleNamed(_ name: String) -> UIImage? {

        if let path = Bundle.main.path(forResource: "MBProgressHUD_LY", ofType: "bundle") {
            return UIImage(named: name, in: Bundle(path: path), compatibleWith: nil)
        } else if let path = Bundle.main.path(forResource: "Frameworks/MBProgressHUD_LY.framework/MBProgressHUD_LY", ofType: "bundle") {
            return UIImage(named: name, in: Bundle(path: path), compatibleWith: nil)
        } else {
            return UIImage(named: name)
        }
        
    }
    
}


open class LYProgressHUD: MBProgressHUD {
    
    open func show(animated: Bool, autoHideDelay: TimeInterval) {
        show(animated: animated)
        if autoHideDelay > 0 {
            hide(animated: animated, afterDelay: autoHideDelay)
        }
    }
    
    open func loadingHud(text: String?) -> Void {
        
        mode = .indeterminate
        removeFromSuperViewOnHide = true
        
        customView = nil

        backgroundColor = .clear
        bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        contentColor = .white
        label.text = text
        label.numberOfLines = 0
        
    }
    
    open func textHud(text: String?) -> Void {
        
        mode = .text
        removeFromSuperViewOnHide = true
        
        customView = nil
        
        backgroundColor = .clear
        bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        contentColor = .white
        label.text = text
        label.numberOfLines = 0
        
    }
    
    open func successHud(text: String?) -> Void {

        mode = .customView
        removeFromSuperViewOnHide = true

        customView = nil
        
        backgroundColor = .clear
        bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
        iv.image = UIImage.ly_inSelfBundleNamed("hud_success_bgi")
        customView = iv
        contentColor = .white
        label.text = text
        label.numberOfLines = 0
        
    }
    
    open func failureHud(text: String?) -> Void {

        mode = .customView
        removeFromSuperViewOnHide = true
        
        customView = nil
        
        backgroundColor = .clear
        bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
        iv.image = UIImage.ly_inSelfBundleNamed("hud_failure_bgi")
        customView = iv
        contentColor = .white
        label.text = text
        label.numberOfLines = 0

    }
    
}




extension DispatchQueue {
    
    fileprivate static func ly_mbph_runInMain(_ block: @escaping () -> Void) -> Void {
        if Thread.current == Thread.main {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
}




public extension UIViewController {
    
    var lyHud: LYProgressHUD {
        get {
            let pointer = UnsafeRawPointer(bitPattern: "_buttfly_MBProgressHUD_lyHud".hashValue)!
            let hud = objc_getAssociatedObject(self, pointer) as? LYProgressHUD
            if let hud = hud {
                return hud
            } else {
                let hud = LYProgressHUD(view: view)
                hud.bezelView.style = .solidColor
                objc_setAssociatedObject(self, pointer, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return hud
            }
        }
    }
    
    func ly_showLoadingHUD(text: String?, autoHideDelay: TimeInterval = 0) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            self.lyHud.loadingHud(text: text)
            self.view.addSubview(self.lyHud)
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
        }
    }
    
    func ly_showTextHub(text: String?, autoHideDelay: TimeInterval = 0) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            self.lyHud.textHud(text: text)
            self.view.addSubview(self.lyHud)
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
        }
    }
    
    func ly_showSuccessHud(text: String?, autoHideDelay: TimeInterval = 0) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            self.lyHud.successHud(text: text)
            self.view.addSubview(self.lyHud)
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
        }
    }
    
    func ly_showFailureHud(text: String?, autoHideDelay: TimeInterval = 0) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            self.lyHud.failureHud(text: text)
            self.view.addSubview(self.lyHud)
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
        }
    }
    
    func ly_hideHub(afterDelay delay: TimeInterval = 0) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            self.lyHud.hide(animated: true, afterDelay: delay)
        }
    }
    
}
