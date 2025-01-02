//
//  NoteDetailsViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 1.01.2025.
//

import Foundation

class NoteDetailsViewModel {
    var notes: [Note] = [
        Note(title: "Algoritmalar ve Veri Yapıları - Arama Algoritmaları", body: "Lineer arama, ikili arama gibi temel arama algoritmaları ve karşılaştırmalı analizleri.", createdDate: Date()),
        Note(title: "Yazılım Mühendisliği - Yazılım Geliştirme Yaşam Döngüsü", body: "Yazılım projelerinin planlanması, tasarlanması, geliştirilmesi ve bakımı.", createdDate: Date().addingTimeInterval(-86400)),
        Note(title: "Veritabanı Yönetim Sistemleri - SQL Sorguları", body: "Temel SQL sorguları, JOIN, GROUP BY, ve subquery kullanımı.", createdDate: Date().addingTimeInterval(-172800)),
        Note(title: "İleri Seviye C++ - Bellek Yönetimi", body: "Dinamik bellek yönetimi, pointerlar, bellek sızıntıları ve önlenmesi.", createdDate: Date().addingTimeInterval(-259200)),
        Note(title: "JavaScript - Asenkron Programlama", body: "JavaScript'te async, await ve Promise yapıları ile asenkron kod yazma.", createdDate: Date().addingTimeInterval(-345600)),
        Note(title: "Web Teknolojileri - HTML ve CSS Temelleri", body: "HTML etiketleri, CSS özellikleri, responsive tasarım ve flexbox kullanımı.", createdDate: Date().addingTimeInterval(-432000)),
        Note(title: "Mobil Uygulama Geliştirme - iOS ve Swift", body: "Swift dilinde temel uygulama geliştirme, UIKit, ve Auto Layout kullanımı.", createdDate: Date().addingTimeInterval(-518400)),
        Note(title: "Python - Veri Bilimi ve Pandas", body: "Pandas kütüphanesi ile veri analizi, veri temizleme ve görselleştirme.", createdDate: Date().addingTimeInterval(-604800)),
        Note(title: "Yapay Zeka - Makine Öğrenmesi Temelleri", body: "Makine öğrenmesinin temel kavramları, eğitim verisi, model doğruluğu ve algoritmalar.", createdDate: Date().addingTimeInterval(-691200)),
        Note(title: "Sistem Programlama - İşlem Yönetimi", body: "İşlem yaratma, zamanlayıcılar, işlem sıralaması ve multithreading kavramları.", createdDate: Date().addingTimeInterval(-777600))
    ]

    
    var filteredNotes: [Note] = []

    func filteredNotes(by searchText: String) {
        if searchText.isEmpty {
            filteredNotes = notes
        } else {
            filteredNotes = notes.filter { note in
                note.title.lowercased().contains(searchText.lowercased()) ||
                note.body.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
