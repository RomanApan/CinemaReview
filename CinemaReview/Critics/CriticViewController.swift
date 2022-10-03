protocol DataCriticsDelegate {
    
    func delegateName(index: Int) -> String
    func delegateStatus(index: Int) -> String
    func delegateBio(index: Int) -> String
    func delegateUrlPicture(index: Int) -> URL
}

import UIKit
import Kingfisher
import SafariServices

class CriticViewController: UIViewController, SFSafariViewControllerDelegate {
    
    private var delegateDataCritics: DataCriticsDelegate?

    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 248/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Caryn James"
        nameLabel.font = UIFont.init(name: "Lato-Bold", size: 24)
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Part Time"
        statusLabel.font = UIFont.init(name: "Lato-Regular", size: 16)
        statusLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        return statusLabel
    }()
    
    private lazy var bioLabel: UILabel = {
        let bioLabel = UILabel()
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.text = "Caryn James writes about film and pop culture for a number of publications including Intelligent Life magazine, the Guardian, the Independent and Metro. Follow here on Twitter here"
        bioLabel.font = UIFont.init(name: "Lato-Regular", size: 16)
        bioLabel.numberOfLines = 0
        bioLabel.textColor = .black
        return bioLabel
    }()
    
    private lazy var nameReviews: UILabel = {
        let nameReviews = UILabel()
        nameReviews.translatesAutoresizingMaskIntoConstraints = false
        nameReviews.text = "Caryn's Reviews"
        nameReviews.font = UIFont.init(name: "Lato-Bold", size: 18)
        nameReviews.textColor = .black
        return nameReviews
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var nameReviewsHeightConstraint: NSLayoutConstraint?
    private var nameReviewsTopConstraint: NSLayoutConstraint?
    
    private var bioLabelHeightConstraint: NSLayoutConstraint?
    private var bioLabelTopConstraint: NSLayoutConstraint?
    
    private let idReviewsCell = "idReviewsCell"
    
    var apiReviews = GetReviewsFromApi()
    
    var apiCritics = GetCriticsFromApi()
    
    var modelCritic = ModelCritic(urlImage: "", name: "", status: "", bio: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Critic Profile"
        
        setupViews()
        setupText()
        
        apiReviews.getDataReviews(urlReviews: transformation(name: modelCritic.name, url: apiReviews.urlReviewsByCritic), itsInfiniteScrolling: true) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func transformation(name: String, url: String) -> String {
        let newName = name.replacingOccurrences(of: " ", with: "%20")
        var url = url
        let index = url.index(url.endIndex, offsetBy: -9)
        url.insert(contentsOf: newName, at: index)
        return url
    }
    
    private func setupText() {
        nameLabel.text = modelCritic.name
        
        if modelCritic.urlImage != "https://www.vk.com/1" {
            titleImage.kf.setImage(with: URL(string: modelCritic.urlImage), placeholder: UIImage(named: "critic1"))
        } else {
            titleImage.image = UIImage(named: "critic1")
            titleImage.contentMode = .center
        }
        
        if !modelCritic.name.contains(".") {
            
            if let index = modelCritic.name.firstIndex(of: " ") {
                let subString = modelCritic.name[..<index]
                let string = String(subString)
                nameReviews.text = string + "'s  Reviews"
            }
        } else {
            nameReviewsTopConstraint?.constant = 0
            nameReviewsHeightConstraint?.constant = 0
            nameReviews.isHidden = true
        }
        
        statusLabel.text = modelCritic.status
        
        if modelCritic.bio == "" {
            bioLabelHeightConstraint?.constant = 0
            bioLabelTopConstraint?.constant = 0
            bioLabel.isHidden = true
        } else {
            bioLabel.text = modelCritic.bio
        }
    }
    
    private func timeFromApi(indexPath: IndexPath) -> String {
        var timeFromApi: String = ""
        timeFromApi = String(apiReviews.reviewsData[indexPath.row].date_updated.suffix(8))
        timeFromApi = String(timeFromApi[timeFromApi.startIndex...timeFromApi.index(timeFromApi.startIndex, offsetBy: 4)])
        return timeFromApi
    }
}


//MARK: SetConstraints

extension CriticViewController {
    
    private func setupViews() {
        
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: idReviewsCell)
        
        view.addSubview(titleImage)
        NSLayoutConstraint.activate([
            titleImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleImage.heightAnchor.constraint(equalToConstant: 124),
            titleImage.widthAnchor.constraint(equalToConstant: 124),
        ])
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 31),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 170),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        view.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 11),
            statusLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 170),
            statusLabel.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        view.addSubview(bioLabel)
        bioLabelHeightConstraint = bioLabel.heightAnchor.constraint(equalToConstant: 90)
        bioLabelHeightConstraint?.isActive = true
        
        bioLabelTopConstraint = bioLabel.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 20)
        bioLabelTopConstraint?.isActive = true
        NSLayoutConstraint.activate([
            bioLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bioLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(nameReviews)
        nameReviewsHeightConstraint = nameReviews.heightAnchor.constraint(equalToConstant: 20)
        nameReviewsHeightConstraint?.isActive = true
        
        nameReviewsTopConstraint = nameReviews.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 25)
        nameReviewsTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            nameReviews.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameReviews.widthAnchor.constraint(lessThanOrEqualToConstant: 155)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nameReviews.bottomAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
}


//MARK: settingTableView

extension CriticViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiReviews.reviewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idReviewsCell, for: indexPath) as! ReviewsTableViewCell
                
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = true
        cell.delegateOpenReview = self
        cell.readReviewButton.tag = indexPath.row
        cell.titleLabel.text = apiReviews.reviewsData[indexPath.row].display_title
        cell.detailLabel.text = apiReviews.reviewsData[indexPath.row].summary_short
        cell.nameCritics.text = apiReviews.reviewsData[indexPath.row].byline
        cell.dateLabel.text = apiReviews.reviewsData[indexPath.row].publication_date
        cell.timeLabel.text = timeFromApi(indexPath: indexPath)
        
        if apiReviews.reviewsData[indexPath.row].multimedia != nil {
            cell.titleImage.kf.setImage(with: apiReviews.setImage(index: indexPath.row), placeholder: UIImage(named: "icon_placeholder"))
            cell.titleImage.contentMode = .scaleAspectFill
        } else {
            cell.titleImage.image = UIImage(named: "icon_placeholder")
            cell.titleImage.contentMode = .center
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        460
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: delegateReviews to cell

extension CriticViewController: OpenReviewDelegate {
    func openReview(_ url: String) {
        if let url = URL(string: url) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    func returnApi() -> GetReviewsFromApi {
        return apiReviews
    }
}
