//
//  UIViewControllerExtension.swift
//  Pods
//
//  Created by Kersten Broich on 27/05/16.
//
//

import UIKit

extension UIViewController {
    
    public func showElissaFromTabbar(at index: Int, configuration: ElissaConfiguration, onTouchHandler: (() -> Void)?) {
        guard
            let tabBarController = tabBarController,
            index <= tabBarController.tabBar.items?.count ?? 0,
            let view = tabBarController.tabBar.items?[index].value(forKey: "view") as? UIView
            else { return }
        
        if Elissa.isVisible {
            Elissa.dismiss()
        }
        
        let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [unowned self] _ in
            let elissa = Elissa.showElissa(self.updatePresentingFrame(view), configuration: configuration, completionHandler: onTouchHandler)
            
            self.tabBarController?.view.addSubview(elissa)
            elissa.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6, options: UIViewAnimationOptions(), animations: {
                elissa.transform = CGAffineTransform.identity
                }, completion: { _ in
                    self.tabBarController?.view.bringSubview(toFront: elissa)
            })
        }
    }
    
    private func updatePresentingFrame(_ sourceView: UIView) -> UIView {
        var sourceFrame = sourceView.frame
        if let height = tabBarController?.tabBar.frame.size.height {
            sourceFrame.origin.y = UIScreen.main.applicationFrame.size.height - height / 2
        }
        return UIView(frame: sourceFrame)
    }
}

extension UIView {
    public func showElissa(fromSourceView sourceView: UIView, configuration: ElissaConfiguration, onTouchHandler: (() -> Void)?) -> Elissa {
        let elissa = Elissa(sourceView: sourceView, configuration: configuration, completionHandler: onTouchHandler)
        
        self.addSubview(elissa)
        elissa.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6, options: UIViewAnimationOptions(), animations: {
            elissa.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.bringSubview(toFront: elissa)
        })
        
        return elissa
    }
}
