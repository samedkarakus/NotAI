//
//  NoteViewController.swift
//  zap
//
//  Created by Samed Karakuş on 10.10.2024.
//
import UIKit
import PDFKit
import MobileCoreServices
import UniformTypeIdentifiers

class NoteViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    @IBOutlet weak var addFileBtnView: UIButton!
    @IBOutlet weak var addImageBtnView: UIButton!
    @IBOutlet weak var cancelBtnView: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var noteTitleTextView: UITextView!
    
    var timer: Timer?
    var viewModel: NoteViewModel?
    var isGradientAdded: Bool = false
    let titlePlaceholder = "Konu başlığı"
    let bodyPlaceholder = "Detaylar.."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimerManager.shared.startTimer(for: timeLeftLabel)
        setupTextViews()
        setupButtons()
        setupNavigationBar()
        viewModel?.loadData()
    }

    private func setupTextViews() {
        noteTitleTextView.delegate = self
        noteBodyTextView.delegate = self
        noteTitleTextView.applyPlaceholder(titlePlaceholder)
        noteBodyTextView.applyPlaceholder(bodyPlaceholder)
        noteBodyTextView.setLineSpacing(6)
    }

    private func setupButtons() {
        [timeView, cancelBtnView, confirmBtn, addImageBtnView, addFileBtnView].forEach { $0?.applyRoundedStyle() }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isGradientAdded {
            let startColor = UIColor(red: 114/255, green: 53/255, blue: 240/255, alpha: 1.0).cgColor
            let endColor = UIColor(red: 114/255, green: 53/255, blue: 240/255, alpha: 0.0).cgColor
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [endColor, startColor]
            gradientLayer.locations = [0.0, 0.7]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.frame = self.gradientView.bounds
            
            self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
            getTextFromGeneratedNote()
            
            isGradientAdded = true
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func photoBtnPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Fotoğraf Seç", message: "Fotoğraf çek veya galeriden seç", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Kamerayı Aç", style: .default, handler: { (action) in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Galeriden Seç", style: .default, handler: { (action) in
            self.openGallery()
        }))
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func addFileBtnPressed(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size.height = size.height
        
        if textView == noteBodyTextView {
            noteBodyTextView.isScrollEnabled = true
            noteBodyTextView.scrollRangeToVisible(NSRange(location: textView.text.count - 1, length: 1))
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == titlePlaceholder || textView.text == bodyPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholders: [UITextView: (text: String, color: UIColor)] = [
            noteTitleTextView: (titlePlaceholder, UIColor.white.withAlphaComponent(0.25)),
            noteBodyTextView: (bodyPlaceholder, UIColor.white.withAlphaComponent(0.25))
        ]
        
        if textView.text.isEmpty, let placeholder = placeholders[textView] {
            textView.text = placeholder.text
            textView.textColor = placeholder.color
        }
    }
    
    
    //MARK: - Camera Functions
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.cameraDevice = .rear
            imagePickerController.showsCameraControls = true
            imagePickerController.allowsEditing = false
            
            imagePickerController.cameraViewTransform = CGAffineTransform.identity
            present(imagePickerController, animated: true, completion: nil)
            textViewDidBeginEditing(noteBodyTextView)
            
        } else {
            print("Kamera kullanılamıyor.")
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            TextRecognition.recognizeText(in: editedImage, textTo: noteBodyTextView)
        } else if let originalImage = info[.originalImage] as? UIImage {
            TextRecognition.recognizeText(in: originalImage, textTo: noteBodyTextView)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - PDF
    
    func handleSelectedPDF(url: URL, textTo textView: UITextView) {
        if let pdfDocument = PDFDocument(url: url) {
            var fullText = ""
            
            for pageIndex in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: pageIndex) {
                    if let pageContent = page.string {
                        fullText += pageContent
                    }
                }
            }
            
            textView.text = fullText
        } else {
            print("PDF açılamadı.")
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]/*, textTo textView: UITextView*/) {
        guard let selectedURL = urls.first else { return }
        
        do {
            let fileManager = FileManager.default
            let tempDirectory = fileManager.temporaryDirectory
            let tempFileURL = tempDirectory.appendingPathComponent(selectedURL.lastPathComponent)
            
            if fileManager.fileExists(atPath: tempFileURL.path) {
                try fileManager.removeItem(at: tempFileURL)
            }
            try fileManager.copyItem(at: selectedURL, to: tempFileURL)
            
            if let pdfDocument = PDFDocument(url: tempFileURL) {
                var fullText = ""
                
                for i in 0..<pdfDocument.pageCount {
                    if let page = pdfDocument.page(at: i), let pageText = page.string {
                        fullText += pageText
                    }
                }
                
                DispatchQueue.main.async {
                    self.textViewDidBeginEditing(self.noteBodyTextView)
                    self.noteBodyTextView.text = fullText
                }
            } else {
                print("PDF dosyası açılamadı.")
            }
        } catch {
            print("Dosya kopyalanamadı: \(error)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Kullanıcı dosya seçim ekranını iptal etti.")
    }
    
    func getTextFromGeneratedNote() -> String {
        if noteBodyTextView.text == "" {
            confirmBtn.isHidden = true
        }
        return noteBodyTextView.text
    }
}
