//
//  NoteViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 10.10.2024.
//


import UIKit
import PDFKit
import MobileCoreServices
import UniformTypeIdentifiers
import FirebaseDatabase

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
    var quizViewModel: QuizViewModel?
    var isGradientAdded: Bool = false
    let titlePlaceholder = "Konu başlığı"
    let bodyPlaceholder = "Detaylar.."
    var loadingAnimation: UIView!
    var noteDetailsViewModel: NoteDetailsViewModel
    
    let firebaseService: FirebaseService
    private let db = Database.database().reference()
    
    required init?(coder: NSCoder) {
        self.noteDetailsViewModel = NoteDetailsViewModel()
        self.firebaseService = FirebaseService()
        super.init(coder: coder)
    }
    
    func formatCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupTextViews()
        setupButtons()
        
        viewModel = NoteViewModel()
        if quizViewModel == nil {
            quizViewModel = QuizViewModel()
        }
        viewModel?.onTextUpdate = { [weak self] text in
            self?.noteBodyTextView.text = text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimerManager.shared.startTimer(for: timeLeftLabel, foreword: "")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TimerManager.shared.stopTimer()
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
            
            isGradientAdded = true
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        guard let userInput = noteBodyTextView.text, !userInput.isEmpty else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen bir içerik girin.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let userInput = noteTitleTextView.text, !userInput.isEmpty else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen bir başlık girin.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let noteTitle = noteTitleTextView.text, !noteTitle.isEmpty else {
            print("Please enter a title.")
            return
        }

        guard let noteBody = noteBodyTextView.text, !noteBody.isEmpty else {
            print("Please enter the note body.")
            return
        }
        
        firebaseService.addNewNote(title: noteTitle, body: noteBody) { success, error in
            if success {
                print("Note successfully added.")
            } else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        loadingAnimationSetup()
        print("API call is being initiated...")
        
        let startTime = Date()
        
        func updateQuestionsInViewModel(with questions: [Question]) {
            quizViewModel?.updateQuestions(with: questions)
        }
        
        callChatGPTAPIForQuestionGeneration(with: userInput) { [weak self] response in
            DispatchQueue.main.async {
                let endTime = Date()
                let elapsedTime = endTime.timeIntervalSince(startTime)
                print("İşlem süresi: \(elapsedTime) saniye")
                
                if let jsonData = response.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    do {
                        let questions = try decoder.decode([Question].self, from: jsonData)
                        updateQuestionsInViewModel(with: questions)
                        self?.continueAfterAPIResponse()
                    } catch {
                        print("JSON çözümleme hatası: \(error)")
                    }
                } else {
                    print("Gelen veri dönüştürülemedi.")
                }
            }
        }
    }

    
    //MARK: - API Response
    
    func continueAfterAPIResponse() {
        print("Operations continue after the API response...")
        
        loadingAnimation.removeFromSuperview()
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let quizVC = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController {
                quizVC.modalPresentationStyle = .fullScreen
                self.present(quizVC, animated: true, completion: nil)
            } else {
                print("QuizViewController bulunamadı!")
            }

            self.navigationController?.popViewController(animated: true)
        }
    }

    
    
    //MARK: - Loading Setup
    
    private func loadingAnimationSetup() {
        loadingAnimation = UIView(frame: view.bounds)
        loadingAnimation.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y - 20)
        activityIndicator.startAnimating()
        loadingAnimation.addSubview(activityIndicator)
        
        let loadingLabel = UILabel()
        loadingLabel.textColor = .white
        loadingLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        loadingLabel.textAlignment = .center
        loadingLabel.frame = CGRect(x: 20, y: activityIndicator.frame.maxY + 10, width: view.bounds.width - 40, height: 30)
        loadingLabel.text = "Sorularınız hazırlanıyor"
        loadingAnimation.addSubview(loadingLabel)
        
        func createGradientLayer(for frame: CGRect) -> CAGradientLayer {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = frame
            gradientLayer.colors = [
                UIColor.brand.cgColor,
                UIColor.clear.cgColor,
                UIColor.brand.cgColor
            ]
            gradientLayer.locations = [0.0, 0.5, 1.0]
            
            let fadeAnimation = CABasicAnimation(keyPath: "opacity")
            fadeAnimation.fromValue = 0.0
            fadeAnimation.toValue = 1.0
            fadeAnimation.duration = 2.0
            fadeAnimation.autoreverses = true
            fadeAnimation.repeatCount = .infinity
            gradientLayer.add(fadeAnimation, forKey: "gradientFade")
            
            return gradientLayer
        }
        
        let topGradient = createGradientLayer(for: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        let bottomGradient = createGradientLayer(for: CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height))
        
        loadingAnimation.layer.addSublayer(topGradient)
        loadingAnimation.layer.addSublayer(bottomGradient)
        
        view.addSubview(loadingAnimation)
    }


    
    //MARK: - File&Image Functions
    
    @IBAction func photoBtnPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Fotoğraf Seç", message: "Fotoğraf çek veya galeriden seç", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Kamerayı Aç", style: .default, handler: { _ in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Galeriden Seç", style: .default, handler: { _ in
            self.openGallery()
        }))
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel))
        self.present(actionSheet, animated: true)
    }

    @IBAction func addFileBtnPressed(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
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
            present(imagePickerController, animated: true)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel?.processImage(image: image)
            noteBodyTextView.textColor = .white
        }
        picker.dismiss(animated: true)
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
            print("PDF could not be opened.")
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        viewModel?.processPDF(url: url)
        noteBodyTextView.textColor = .white
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("The user canceled the file selection screen.")
    }
}
