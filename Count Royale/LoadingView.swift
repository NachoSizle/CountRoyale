//
//  LoadingView.swift
//

import UIKit

class LoadingView: UIView {
    
    var titleLabel: UILabel!
    
    var title: String! {
        get {
            return titleLabel.text
        }
        
        set(title) {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 20
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        let air = frame.size.height * 0.20
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
      
        activity.frame = CGRect(x: 37, y: 37, width: (frame.size.width - 37) / 2, height: air)
        activity.startAnimating()
        addSubview(activity)
        
  
        titleLabel = UILabel(frame: CGRect(x: 0, y: air + 37, width: frame.size.width, height: frame.size.height - 57))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
    }
}
