//
//  ProfileViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 6.12.2024.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var editButtonView: UIButton!
    @IBOutlet weak var memojiView: UIView!
    @IBOutlet weak var settingsTableView: UITableView!

    private let viewModel = ProfileViewModel()
    private var qrViewModel: QRViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        makeCircular(view: memojiView)
        addBlurredBackground(memojiView)
        makeCircular(view: editButtonView)
        addBlurredBackgroundToPressedButton(editButtonView)
    
        qrViewModel = QRViewModel(qrData: "https://www.instagram.com")
        configureQRCode()
        
        navigationItem.title = "Ayarlar"
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    }
    
    private func configureQRCode() {
        guard let qrViewModel = qrViewModel else {
            print("qrViewModel is nil")
            return
        }
        
        let qrCodeSize = qrCodeImageView.frame.size
        qrCodeImageView.image = qrViewModel.getQRCodeImage(for: qrCodeSize)
    }

    
    func setupTableView() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        settingsTableView.backgroundColor = .clear
        settingsTableView.showsVerticalScrollIndicator = false
        settingsTableView.showsHorizontalScrollIndicator = false
        settingsTableView.separatorStyle = .none
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = viewModel.sections[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)

        configureCellIcon(cell, item: item)
        
        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))
        disclosureIndicator.tintColor = .black
        cell.accessoryView = disclosureIndicator
        
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        cell.selectedBackgroundView = selectedBackground
        
        addBlurredBackground(cell)
        
        return cell
    }

    private func configureCellIcon(_ cell: UITableViewCell, item: ProfileItem) {
        if let iconName = item.icon {
            if let image = UIImage(named: iconName) {
                cell.imageView?.image = image
            } else {
                cell.imageView?.image = UIImage(systemName: iconName)
            }
            cell.imageView?.tintColor = .black
            NSLayoutConstraint.activate([
                cell.imageView!.widthAnchor.constraint(equalToConstant: 14)
            ])
        } else {
            cell.imageView?.image = nil
        }
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.sections[indexPath.section][indexPath.row]
        
        switch item.title {
        case "Notlarım":
            if let targetVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetailsController") {
                targetVC.modalPresentationStyle = .automatic
                present(targetVC, animated: true, completion: nil)
            }

        case "Instagram'da Bizi Takip Edin":
            openURL("https://www.instagram.com")
            
        case "LinkedIn'de Takip Edin":
            openURL("https://www.linkedin.com")
            
        case "Bize Ulaşın":
            openURL("mailto:example@email.com")
            
        case "Geri Bildirim Ver":
            print("Geri bildirim vermek için yönlendirme yapılabilir.")
            
        case "Çıkış Yap":
            if let targetVC = storyboard?.instantiateViewController(withIdentifier: "OnboardingViewController") {
                targetVC.modalPresentationStyle = .fullScreen
                present(targetVC, animated: true, completion: nil)
            }
            print("Çıkış yapılıyor.")
            
        default:
            break
        }
    }

    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.clear
        header.layer.cornerRadius = 10
        header.layer.masksToBounds = true
    }
}
