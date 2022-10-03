
import UIKit

class LoadingCell: UITableViewCell, UITextFieldDelegate {
    
    lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.addSubview(activityIndicator)
        activityIndicator.color = (UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1))
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.placeAtTheCenter(activity: activityIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func placeAtTheCenter(activity: UIActivityIndicatorView) {
        
        self.addConstraint(NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
    }
    
}
