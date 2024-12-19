//
//  ProfileViewModels.swift
//  NotAI
//
//  Created by Samed Karakuş on 6.12.2024.
//

import Foundation
import UIKit

class ProfileViewModel {
    
    var sections: [[ProfileItem]]
    
    init() {
        sections = [
            [
                ProfileItem(icon: "barcode", title: "Arkadaşlık Kodu"),
                ProfileItem(icon: "flame", title: "Streak Sayısı"),
                ProfileItem(icon: "bolt", title: "Arkadaşlık Aktivitesi"),
                ProfileItem(icon: "clock", title: "Son Aktivite")
            ],
            [
                ProfileItem(icon: "doc.text", title: "EULA"),
                ProfileItem(icon: "doc.text.magnifyingglass", title: "Kullanım Şartları"),
                ProfileItem(icon: "shield", title: "Gizlilik Politikası"),
                ProfileItem(icon: "questionmark.circle", title: "Uygulamayı nasıl kullanırım?")
            ],
            [ProfileItem(icon: "appStore", title: "App Store'da Bizi Oyla")],
            [
                ProfileItem(icon: "instagram", title: "Instagram'da Bizi Takip Edin"),
                ProfileItem(icon: "linkedin", title: "LinkedIn'de Takip Edin")
            ],
            [
                ProfileItem(icon: "star", title: "Geri Bildirim Ver"),
                ProfileItem(icon: "iphone.and.arrow.right.outward", title: "Çıkış Yap")
            ]
        ]
    }
    
    func generateProfileQRCode(for text: String, size: CGSize) -> UIImage? {
        return QRCodeGenerator.shared.generateQRCode(from: text, size: size)
    }
}
