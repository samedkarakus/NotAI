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
    @IBOutlet weak var settingsTableView: UITableView! // IBOutlet olan tableView

    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView'ı yapılandır
        setupTableView()
        makeCircular(view: memojiView)
        addBlurredBackground(memojiView)
        makeCircular(view: editButtonView)
        addBlurredBackgroundToPressedButton(editButtonView)
        configureQRCode()
        
        navigationItem.title = "Ayarlar"
        
        // Navigation bar ayarları
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        // Back button text'ini gizle
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    }
    
    private func configureQRCode() {
        let profileIdentifier = "www.instagram.com"
        let qrCodeSize = qrCodeImageView.frame.size
        qrCodeImageView.image = viewModel.generateProfileQRCode(for: profileIdentifier, size: qrCodeSize)
    }
    
    // TableView'ı yapılandırma
    func setupTableView() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // TableView'a ait özellikler
        settingsTableView.backgroundColor = .clear
        settingsTableView.showsVerticalScrollIndicator = false
        settingsTableView.showsHorizontalScrollIndicator = false
        settingsTableView.separatorStyle = .none // Çizgileri kaldır
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

        // İlgili veriyi al
        let item = viewModel.sections[indexPath.section][indexPath.row]
        
        // Hücre metni
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)

        if let iconName = item.icon {
            if iconName == "instagram" {
                cell.imageView?.image = UIImage(named: "instagram")
            } else if iconName == "linkedin" {
                cell.imageView?.image = UIImage(named: "linkedin")
            } else if iconName == "appStore" {
                cell.imageView?.image = UIImage(named: "appStore")
            } else {
                cell.imageView?.image = UIImage(systemName: iconName)
            }
            cell.imageView?.tintColor = .black
            NSLayoutConstraint.activate([
                cell.imageView!.widthAnchor.constraint(equalToConstant: 14)
            ])
        } else {
            cell.imageView?.image = nil // Eğer ikon yoksa boş bırak
        }
        
        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))
        disclosureIndicator.tintColor = .black // Set the color to black
        cell.accessoryView = disclosureIndicator
        
        cell.backgroundColor = .clear
        
        // Border radius ve arka plan rengi ekleme
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true

        addBlurredBackground(cell)
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.sections[indexPath.section][indexPath.row]
        
        switch item.title {
        case "Instagram'da Bizi Takip Edin":
            if let url = URL(string: "https://www.instagram.com") {
                UIApplication.shared.open(url)
            }
            
        case "LinkedIn'de Takip Edin":
            if let url = URL(string: "https://www.linkedin.com") {
                UIApplication.shared.open(url)
            }
            
        case "Bize Ulaşın":
            if let url = URL(string: "mailto:example@email.com") {
                UIApplication.shared.open(url)
            }
            
        case "Geri Bildirim Ver":
            print("Geri bildirim vermek için yönlendirme yapılabilir.")
            
        case "Çıkış Yap":
            print("Çıkış yapılıyor.")
            
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.clear
        header.layer.cornerRadius = 10
        header.layer.masksToBounds = true
    }
}

