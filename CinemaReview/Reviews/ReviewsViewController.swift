import UIKit
import Kingfisher
import SafariServices

class ReviewsViewController: UIViewController, SFSafariViewControllerDelegate {
    
    private lazy var mainView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 45))
        view.backgroundColor = UIColor(red: 255/255, green: 234/255, blue: 225/255, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 12, width: 20, height: 20))
        let image = UIImage(named: "icon_search")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        
        let search = UITextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.layer.cornerRadius = 15
        search.delegate = self
        search.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: (UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1))]
        )
        search.textColor = (UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1))
        search.backgroundColor = UIColor(red: 255/255, green: 234/255, blue: 225/255, alpha: 1)
        search.font = UIFont.init(name: "Lato-Regular", size: 16)
        search.leftViewMode = .always
        search.tintColor = .clear
        search.autocorrectionType = .no
        search.returnKeyType = .done
        search.leftView = mainView
        return search
    }()
    
    private lazy var mainViewDate: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 45))
        view.backgroundColor = UIColor(red: 255/255, green: 234/255, blue: 225/255, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var imageViewDate: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 12, width: 20, height: 20))
        let image = UIImage(named: "icon_calendar")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        textField.layer.cornerRadius = 15
        textField.attributedPlaceholder = NSAttributedString(
            string: "2017 / 12 / 10",
            attributes: [NSAttributedString.Key.foregroundColor: (UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1))]
        )
        textField.textColor = (UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1))
        textField.backgroundColor = UIColor(red: 255/255, green: 234/255, blue: 225/255, alpha: 1)
        textField.font = UIFont.init(name: "Lato-Regular", size: 12)
        textField.leftViewMode = .always
        textField.leftView = mainViewDate
        
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private let idReviewsCell = "idReviewsCell"

    private let api = GetReviewsFromApi()
    
    private lazy var datePicker = UIDatePicker()
    
    private var isLoading = false
    
    private let idLoadCell = "LoadingCell"
    
//MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reviews"
        
        setupView()
        api.getDataReviews(urlReviews: api.urlReviews, itsInfiniteScrolling: false) { [weak self] in
            self?.tableView.reloadData()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    private func loadMoreData() {
        if !isLoading && (api.reviewsData.count % 20 == 0) {
            isLoading = true
            var url: String = api.urlReviewsNext
            
            let index = url.index(url.endIndex, offsetBy: -9)
            url.insert(contentsOf: "\(api.reviewsData.count)", at: index)
            
            api.getDataReviews(urlReviews: url, itsInfiniteScrolling: true) { [weak self] in
                self?.tableView.reloadData()
            }
            
            tableView.reloadData()
            isLoading = false
        }
    }
    
    @objc
    private func refresh(_ sender: AnyObject) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc
    private func responseSearchTextField(_ str: String) {
        var urlReviewsWord = api.urlReviewsWord
        let index = urlReviewsWord.index(urlReviewsWord.endIndex, offsetBy: -9)
        urlReviewsWord.insert(contentsOf: str, at: index)
        
        api.getDataReviews(urlReviews: urlReviewsWord, itsInfiniteScrolling: false) { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc
    private func timeFromApi(indexPath: IndexPath) -> String {
        var timeFromApi: String = ""
        timeFromApi = String(api.reviewsData[indexPath.row].date_updated.suffix(8))
        timeFromApi = String(timeFromApi[timeFromApi.startIndex...timeFromApi.index(timeFromApi.startIndex, offsetBy: 4)])
        return timeFromApi
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: SetConstraints

extension ReviewsViewController {
    
    private func setupView() {
        
        view.backgroundColor = .white
        
        mainView.addSubview(imageView)
        mainViewDate.addSubview(imageViewDate)
        
        searchTextField.delegate = self
        setupToolbarForKeyboard()
        setupDatePicker()

        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(LoadingCell.self, forCellReuseIdentifier: idLoadCell)
        tableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: idReviewsCell)
        
        view.addSubview(dateTextField)
        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dateTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dateTextField.heightAnchor.constraint(equalToConstant: 45),
            dateTextField.widthAnchor.constraint(equalToConstant: 125),
        ])
        
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: self.dateTextField.leadingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 45),
                        
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
}

//MARK: settingTableView

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            //Return the amount of items
            return api.reviewsData.count
        } else if section == 1 {
            //Return the Loading cell
            return 1
        } else {
            //Return nothing
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: idReviewsCell, for: indexPath) as! ReviewsTableViewCell
            
            cell.selectionStyle = .none
            cell.contentView.isUserInteractionEnabled = true
            cell.delegateOpenReview = self
            cell.readReviewButton.tag = indexPath.row
            cell.titleLabel.text = api.reviewsData[indexPath.row].display_title
            cell.detailLabel.text = api.reviewsData[indexPath.row].summary_short
            cell.nameCritics.text = api.reviewsData[indexPath.row].byline
            cell.dateLabel.text = api.reviewsData[indexPath.row].publication_date
            cell.timeLabel.text = timeFromApi(indexPath: indexPath)
            
            if api.reviewsData[indexPath.row].multimedia != nil {
                cell.titleImage.kf.setImage(with: api.setImage(index: indexPath.row), placeholder: UIImage(named: "icon_placeholder"))
                cell.titleImage.contentMode = .scaleAspectFill
            } else {
                cell.titleImage.image = UIImage(named: "icon_placeholder")
                cell.titleImage.contentMode = .center
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: idLoadCell, for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 460
        } else {
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 460
        } else {
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            
            loadMoreData()
        }
    }

}

// MARK: setting toolbar for keyboard textField

extension ReviewsViewController {
    
    private func setupToolbarForKeyboard() {
        
        let toolBar: UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelBtnKeyboard))
        
        let spaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.doneBtnKeyboard))
        
        toolBar.setItems([cancelButton ,spaceButton, doneButton], animated: true)
        
        self.searchTextField.inputAccessoryView = toolBar
    }
    
    @objc
    private func cancelBtnKeyboard() {
        searchTextField.resignFirstResponder()
        
        api.getDataReviews(urlReviews: api.urlReviewsDate, itsInfiniteScrolling: false) { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        searchTextField.text = ""
    }
    
    @objc
    private func doneBtnKeyboard() {
        searchTextField.resignFirstResponder()
        let str = searchTextField.text ?? ""
        responseSearchTextField(str)
    }
}

// MARK: setup datePicker

extension ReviewsViewController {
    private func setupDatePicker() {
        
        self.datePicker = UIDatePicker.init(frame: CGRect(x:0, y: 0, width: self.view.frame.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        
        self.dateTextField.inputView = datePicker
        
        let toolBar: UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelBtnDate))
        
        let spaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.doneBtnDate))
        
        toolBar.setItems([cancelButton ,spaceButton, doneButton], animated: true)
        
        self.dateTextField.inputAccessoryView = toolBar
    }
    
    @objc
    private func cancelBtnDate() {
        dateTextField.resignFirstResponder()
        dateTextField.text = ""
        
        api.getDataReviews(urlReviews: api.urlReviewsDate, itsInfiniteScrolling: true) { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc
    private func dateChanged() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.dateFormat = "yyyy / MM / dd"
        dateTextField.text = dateFormat.string(from: datePicker.date)
    }
    
    @objc
    private func doneBtnDate() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.dateFormat = "yyyy / MM / dd"
        dateTextField.text = dateFormat.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
               
        var str = dateTextField.text ?? ""
        str = str.replacingOccurrences(of: " / ", with: "-")
        
        var urlReviewsDate = api.urlReviewsDate
        let index = urlReviewsDate.index(urlReviewsDate.endIndex, offsetBy: -9)
        urlReviewsDate.insert(contentsOf: "\(str):\(str)", at: index)
        print("\(urlReviewsDate)")
        api.getDataReviews(urlReviews: urlReviewsDate, itsInfiniteScrolling: false) { [weak self] in
            self?.tableView.reloadData()
            if !(self?.api.reviewsData.isEmpty ?? false) {
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            } else {
                // тут должен вызываться alert, сделать позже
            }
        }
    }
}

// MARK: delegateReviews to cell

extension ReviewsViewController: OpenReviewDelegate {
    func openReview(_ url: String) {
        if let url = URL(string: url) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    func returnApi() -> GetReviewsFromApi {
        return api
    }
}

//MARK: - UITextFieldDelegate

extension ReviewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        let str = searchTextField.text ?? ""
        responseSearchTextField(str)
        return false
    }
}
