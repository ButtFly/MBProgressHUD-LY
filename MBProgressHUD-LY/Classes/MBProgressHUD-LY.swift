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

        let frameworkBundle = Bundle(for: LYProgressHUD.self)
        let bundle: Bundle
        if let bundleUrl = frameworkBundle.url(forResource: "MBProgressHUD_LY", withExtension: "bundle") {
            let currentBundel = Bundle(url: bundleUrl)
            bundle = currentBundel ?? Bundle.main
        } else {
            bundle = Bundle.main
        }
        if #available(iOS 13.0, *) {
            return UIImage(named: name, in: bundle, with: nil)
        } else {
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
    }
    
}


open class LYProgressHUD: MBProgressHUD {
    
    public var successImage: UIImage?
    public var failureImage: UIImage?

    
    public init(successImage: UIImage? = nil, failureImage: UIImage? = nil) {
        self.successImage = successImage
        self.failureImage = failureImage
        super.init(frame: UIScreen.main.bounds)
        bezelView.style = .solidColor
        backgroundColor = .clear
        bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        contentColor = .white
        removeFromSuperViewOnHide = true
        label.numberOfLines = 0
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func show(animated: Bool, autoHideDelay: TimeInterval) {
        show(animated: animated)
        if autoHideDelay > 0 {
            hide(animated: animated, afterDelay: autoHideDelay)
        }
    }
    
    open func loadingHud(text: String?) -> Void {
        mode = .indeterminate
        customView = nil
        label.text = text
        
    }
    
    open func textHud(text: String?) -> Void {
        
        mode = .text
        customView = nil
        label.text = text
        
    }
    
    open func successHud(text: String?) -> Void {

        mode = .customView
        customView = nil
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
        iv.image = successImage ?? UIImage.ly_inSelfBundleNamed("hud_success_bgi")
        customView = iv
        label.text = text
        
    }
    
    open func failureHud(text: String?) -> Void {

        mode = .customView
        customView = nil
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
        iv.image = failureImage ?? UIImage.ly_inSelfBundleNamed("hud_failure_bgi")
        customView = iv
        label.text = text
        
    }
    
    ///style:   1-横着的条形进度条。2-圆环形进度圈，进度在里圈。3-菊花转。其他：圆形进度条，已进行的部分是实体色，未进行的事浅色
    open func progressHud(proress:CGFloat,text:String?,style:Int=1) {
        
        switch style {
        case 1:
            mode = .determinateHorizontalBar
        case 2:
            mode = .determinate
        case 3:
            mode = .indeterminate
        default:
            mode = .annularDeterminate
        }
        
        label.text = text
        progress = Float(proress)
        
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
                let hud = LYProgressHUD()
                objc_setAssociatedObject(self, pointer, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return hud
            }
        }
    }
    
    func ly_showLoadingHUD(text: String?, autoHideDelay: TimeInterval = 0, inView: UIView? = nil, complete: ((_ weakSelf: UIViewController) -> Void)? = nil) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            let view: UIView = inView ?? self.view
            self.lyHud.loadingHud(text: text)
            view.addSubview(self.lyHud)
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
            weak var weakSelf = self
            self.lyHud.completionBlock = {
                guard let weakSelf = weakSelf else { return }
                let strongSelf = weakSelf
                DispatchQueue.ly_mbph_runInMain {
                    complete?(strongSelf)
                }
                strongSelf.lyHud.completionBlock = nil
            }
        }
    }
    
    func ly_showTextHub(text: String?, autoHideDelay: TimeInterval = 0, inView: UIView? = nil, complete: ((_ weakSelf: UIViewController) -> Void)? = nil) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            let view: UIView = inView ?? self.view
            self.lyHud.textHud(text: text)
            view.addSubview(self.lyHud)
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
            weak var weakSelf = self
            self.lyHud.completionBlock = {
                guard let weakSelf = weakSelf else { return }
                let strongSelf = weakSelf
                DispatchQueue.ly_mbph_runInMain {
                    complete?(strongSelf)
                }
                strongSelf.lyHud.completionBlock = nil
            }
        }
    }
    
    func ly_showSuccessHud(text: String?, autoHideDelay: TimeInterval = 0, inView: UIView? = nil, complete: ((_ weakSelf: UIViewController) -> Void)? = nil) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            let view: UIView = inView ?? self.view
            self.lyHud.successHud(text: text)
            view.addSubview(self.lyHud)
            self.lyHud.isUserInteractionEnabled = false
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
            weak var weakSelf = self
            self.lyHud.completionBlock = {
                guard let weakSelf = weakSelf else { return }
                let strongSelf = weakSelf
                DispatchQueue.ly_mbph_runInMain {
                    complete?(strongSelf)
                }
                strongSelf.lyHud.completionBlock = nil
            }
        }
    }
    
    func ly_showFailureHud(text: String?, autoHideDelay: TimeInterval = 0, inView: UIView? = nil, complete: ((_ weakSelf: UIViewController) -> Void)? = nil) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            let view: UIView = inView ?? self.view
            self.lyHud.failureHud(text: text)
            view.addSubview(self.lyHud)
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
            weak var weakSelf = self
            self.lyHud.completionBlock = {
                guard let weakSelf = weakSelf else { return }
                let strongSelf = weakSelf
                DispatchQueue.ly_mbph_runInMain {
                    complete?(strongSelf)
                }
                strongSelf.lyHud.completionBlock = nil
            }
        }
    }
    
    func ly_hideHud(afterDelay delay: TimeInterval = 0, complete: ((_ weakSelf: UIViewController) -> Void)? = nil) -> Void {
        DispatchQueue.ly_mbph_runInMain {
            self.lyHud.hide(animated: true, afterDelay: delay)
            weak var weakSelf = self
            self.lyHud.completionBlock = {
                guard let weakSelf = weakSelf else { return }
                let strongSelf = weakSelf
                DispatchQueue.ly_mbph_runInMain {
                    complete?(strongSelf)
                }
                strongSelf.lyHud.completionBlock = nil
            }
        }
    }
    
    func ly_showProgressHud(progress:CGFloat, text:String?, style:Int = 1, autoHideDelay: TimeInterval = 0, inView: UIView? = nil, complete: ((_ weakSelf: UIViewController) -> Void)? = nil)  {
        
        DispatchQueue.ly_mbph_runInMain {
            let view: UIView = inView ?? self.view
            self.lyHud.progressHud(proress: progress, text: text, style: style)
            view.addSubview(self.lyHud)
            self.lyHud.show(animated: true, autoHideDelay: autoHideDelay)
            weak var weakSelf = self
            self.lyHud.completionBlock = {
                guard let weakSelf = weakSelf else { return }
                let strongSelf = weakSelf
                DispatchQueue.ly_mbph_runInMain {
                    complete?(strongSelf)
                }
                strongSelf.lyHud.completionBlock = nil
            }
        }
    }
    
    
}




