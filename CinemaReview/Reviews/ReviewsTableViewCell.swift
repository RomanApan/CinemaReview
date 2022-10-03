protocol OpenReviewDelegate: AnyObject {
    func openReview(_ url: String)
    func returnApi() -> GetReviewsFromApi
}

import UIKit

class ReviewsTableViewCell: UITableViewCell {
    
    weak var delegateOpenReview: OpenReviewDelegate?
    
    lazy var titleImage: UIImageView = {
        var titleImage = UIImageView()
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleImage.layer.cornerRadius = 15
        titleImage.contentMode = .scaleAspectFill
        titleImage.clipsToBounds = true
        titleImage.backgroundColor = UIColor(red: 255/255, green: 234/255, blue: 225/255, alpha: 1)
        return titleImage
    }()
    
    lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Wonder Woman 1984 'fills you with wonder'"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.init(name: "Lato-Bold", size: 24)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var detailLabel: UILabel = {
        var detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.text = "There used to be a time when you could follow a Hollywood blockbuster even if you hadn't memorised all the prequels, sequels and characters' family trees..."
        detailLabel.textColor = .black
        detailLabel.font = UIFont.init(name: "Lato-Regular", size: 16)
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.numberOfLines = 3
        detailLabel.textAlignment = .justified
        return detailLabel
    }()
    
    lazy var miniCritic: UIImageView = {
        var miniCritic = UIImageView(image: UIImage(named: "icon_critic")?.withRenderingMode(.alwaysTemplate))
        miniCritic.translatesAutoresizingMaskIntoConstraints = false
        miniCritic.tintColor = UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1)
        return miniCritic
    }()
    
    lazy var nameCritics: UILabel = {
        var nameCritics = UILabel()
        nameCritics.translatesAutoresizingMaskIntoConstraints = false
        nameCritics.text = "Nicholas Barber"
        nameCritics.contentMode = .left
        nameCritics.font = UIFont.init(name: "Lato-Regular", size: 16)
        nameCritics.textColor = UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1)
        return nameCritics
    }()
    
    lazy var dateLabel: UILabel = {
        var dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "2017 / 12 / 14"
        dateLabel.font = UIFont.init(name: "Lato-Regular", size: 12)
        dateLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        return dateLabel
    }()
    
    lazy var timeLabel: UILabel = {
        var timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "12:04"
        timeLabel.font = UIFont.init(name: "Lato-Regular", size: 12)
        timeLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        return timeLabel
    }()
    
    lazy var readReviewButton: UIButton = {
        var readReviewButton = UIButton()
        readReviewButton.tag = 0
        readReviewButton.addTarget(self, action: #selector(openReview), for: .touchUpInside)
        readReviewButton.translatesAutoresizingMaskIntoConstraints = false
        readReviewButton.setTitle("Read Review", for: .normal)
        readReviewButton.titleLabel?.font = UIFont.init(name: "Lato-Bold", size: 16)
        readReviewButton.setTitleColor(UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1), for: .normal)
        readReviewButton.backgroundColor = .white
        readReviewButton.layer.cornerRadius = 15
        readReviewButton.layer.borderWidth = 1
        readReviewButton.layer.borderColor = CGColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1)
        return readReviewButton
    }()
    
    @objc
    private func openReview() {
        
        let api = self.delegateOpenReview?.returnApi()
                
        self.delegateOpenReview?.openReview(api?.reviewsData[readReviewButton.tag].link.url ?? "https://www.vk.com/1")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITextFieldDelegate

extension ReviewsTableViewCell {
    private func setConstrains() {
        contentView.addSubview(titleImage)
        NSLayoutConstraint.activate([
            titleImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleImage.heightAnchor.constraint(equalToConstant: 172)
            
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        contentView.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 90)
        ])
        
        contentView.addSubview(miniCritic)
        NSLayoutConstraint.activate([
            miniCritic.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 11),
            miniCritic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            miniCritic.heightAnchor.constraint(equalToConstant: 24),
            miniCritic.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        contentView.addSubview(nameCritics)
        NSLayoutConstraint.activate([
            nameCritics.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 13),
            nameCritics.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            nameCritics.heightAnchor.constraint(equalToConstant: 21),
            nameCritics.widthAnchor.constraint(equalToConstant: 127)
        ])
        
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 18),
            dateLabel.widthAnchor.constraint(equalToConstant: 79),
            dateLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        contentView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 18),
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        contentView.addSubview(readReviewButton)
        NSLayoutConstraint.activate([
            readReviewButton.topAnchor.constraint(equalTo: nameCritics.bottomAnchor, constant: 17),
            readReviewButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            readReviewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            readReviewButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

