
import Foundation
import UIKit
import NVActivityIndicatorView

class LoadingActivity {
    
    static let shared = LoadingActivity()
    
    func show(type: NVActivityIndicatorType = .ballRotateChase, message: String? = nil, thresholdTime: Int = 0) {
        let font = UIFont.systemFont(ofSize: 15)
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = thresholdTime
       let activityData = ActivityData(message: message, messageFont: font, type: type, color: UIColor.hexStringToUIColor(hex: "#F86C4B"), textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    func showLoadding(type: NVActivityIndicatorType = .ballScaleMultiple, message: String? = nil, autoHide: Bool = true, completed: ((Bool) -> Void)?) {
        let font = UIFont.systemFont(ofSize: 15)
        let activityData = ActivityData(message: message, messageFont: font, type: type, textColor: nil)
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD  = 10
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        if autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.hide()
                completed?(true)
            }
        }
    }
    
    func updateMessage(newMessage: String) {
        NVActivityIndicatorPresenter.sharedInstance.setMessage(newMessage)
    }
    
    func hide() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func isAnimating() -> Bool {
        return NVActivityIndicatorPresenter.sharedInstance.isAnimating
    }
    
    func hideAfter(second: TimeInterval = 3, completed: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second) {
            self.hide()
            completed?()
        }
    }
}
