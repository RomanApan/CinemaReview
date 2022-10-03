import UIKit
import Kingfisher

class CriticsViewController: UIViewController {
    
    private lazy var mainView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 45))
        view.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 248/255, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 12, width: 20, height: 20))
        let image = UIImage(named: "icon_search_blue")
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
            attributes: [NSAttributedString.Key.foregroundColor: (UIColor(red: 75/255, green: 136/255, blue: 255/255, alpha: 1))]
        )
        search.textColor = UIColor(red: 75/255, green: 136/255, blue: 255/255, alpha: 1)
        search.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 248/255, alpha: 1)
        search.font = UIFont.init(name: "Lato-Regular", size: 16)
        search.leftViewMode = .always
        search.autocorrectionType = .no
        search.returnKeyType = .done
        search.leftView = mainView
        return search
    }()
    
    private lazy var viewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 58
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 60) / 2, height: (UIScreen.main.bounds.width - 60) / 2)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 58, right: 20)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.frame = UIScreen.main.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(CriticsCollectionViewCell.self, forCellWithReuseIdentifier: idCriticsCell)
        return collectionView
    }()
    
    private let idCriticsCell = "idCriticsCell"
    private let api = GetCriticsFromApi()
    private var critic = GetCriticsFromApi()
    private var modelCritic = ModelCritic(urlImage: "", name: "", status: "", bio: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Critics"
        
        setupViews()
        
        api.getDataCritics(urlCritics: api.urlCritics) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func responseSearchTextField(_ str: String) {
        
        for i in api.criticsData {
            if i.display_name == str {
                
                api.reservData = api.criticsData
                critic.criticsData.append(i)
                api.criticsData.removeAll()
                    api.criticsData = critic.criticsData
                collectionView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        setupToolbarForKeyboard()
        
        view.backgroundColor = .white
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        mainView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 45),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
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
        searchTextField.text = ""
        
        if !api.reservData.isEmpty {
            api.criticsData = api.reservData
            collectionView.reloadData()
        }
    }
    
    @objc
    private func doneBtnKeyboard() {
        searchTextField.resignFirstResponder()
        let str = searchTextField.text ?? ""
        responseSearchTextField(str)
    }

    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource
extension CriticsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        api.criticsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCriticsCell, for: indexPath) as! CriticsCollectionViewCell
        
        cell.contentView.isUserInteractionEnabled = true
        cell.nameLabel.text = api.criticsData[indexPath.row].display_name
        
        if api.criticsData[indexPath.row].multimedia != nil {
            cell.imageView.kf.setImage(with: api.setImage(index: indexPath.row), placeholder: UIImage(named: "critic1"))
            cell.imageView.contentMode = .scaleAspectFill
        } else {
            cell.imageView.image = UIImage(named: "critic1")
            cell.imageView.contentMode = .center
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CriticsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let criticData = ModelCritic(urlImage: api.criticsData[indexPath.row].multimedia?.resource.src ?? "https://www.vk.com/1",name: api.criticsData[indexPath.row].display_name, status: api.criticsData[indexPath.row].status, bio: api.criticsData[indexPath.row].bio)

        let vc = CriticViewController()
        vc.modelCritic = criticData
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension CriticsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        let str = searchTextField.text ?? ""
        responseSearchTextField(str)
        return false
    }
}

// MARK: - DataCriticsDelegate

extension CriticsViewController: DataCriticsDelegate {
    func delegateName(index: Int) -> String {
        return api.criticsData[index].display_name
    }
    
    func delegateStatus(index: Int) -> String {
        return api.criticsData[index].status
    }
    
    func delegateBio(index: Int) -> String {
        return api.criticsData[index].bio
    }
    
    func delegateUrlPicture(index: Int) -> URL {
        return URL(string: api.criticsData[index].multimedia?.resource.src ?? "vk.com/1")!
    }
}
