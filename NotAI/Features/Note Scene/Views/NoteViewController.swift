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
    var girisEkrani: OnboardingViewController?
    
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

    func callChatGPTAPI(with input: String, completion: @escaping (String) -> Void) {

        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
            
        let dersNotlari = input
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                        [
                            "role": "user",
                            "content": """
                            \(dersNotlari)
                            Bu ders notlarını sana aşağıda verdiğim kriterlere göre işle.

                            struct Question: Codable {
                                var question: String
                                var answer: [String]
                                var correctAnswer: String
                            }
                            ve
                            var questions: [Question] = [] oldugunu bil. 
                            Ders Notlarını kullanarak yukarıdaki kurallara uygun ve aşağıdaki örnek formata göre bana 10 adet soru hazırla. Bana yollayacağın çıktı sadece aşağıdaki formatta dönen bir JSON dizisi olsun. Ekstra açıklama, başlık ya da yorum ekleme. Sorular birbirinden ve aşağıdakilerden farklı olsun.
                            questions = [
                                        Question(
                                            question: "Aşağıdakilerden hangisi bir sözleşmenin 'geçersiz' olmasına sebep olabilir?",
                                            answer: ["Sözleşmenin yazılı yapılması.", "Taraflardan birinin ehliyetsiz olması.", "Sözleşmenin noter huzurunda yapılması.", "Tarafların mutabakata varması."],
                                            correctAnswer: "Taraflardan birinin ehliyetsiz olması."
                                        ),
                                        Question(
                                            question: "Aşağıdakilerden hangisi medeni hukukun dallarından biridir?",
                                            answer: ["Ceza hukuku.", "Vergi hukuku.", "Aile hukuku.", "İdari hukuk."],
                                            correctAnswer: "Aile hukuku."
                                        )
                            ]
                            
                            """
                        ]
            ],
            "temperature": 0.6
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                completion("Bir hata oluştu.")
                return
            }
            
            guard let data = data else {
                print("Veri alınamadı.")
                completion("Bir hata oluştu.")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let dict = json as? [String: Any],
               let choices = dict["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                completion(content)
            } else {
                print("JSON çözümleme hatası.")
                completion("Bir hata oluştu.")
            }
        }
        
        task.resume()
    }
    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        guard let userInput = noteBodyTextView.text, !userInput.isEmpty else {
            print("Lütfen bir metin girin.")
            return
        }
        
        loadingAnimationSetup()
        print("API çağrısı başlatılıyor...")
        
        let startTime = Date()
        
        func updateQuestionsInViewModel(with questions: [Question]) {
                quizViewModel?.updateQuestions(with: questions)
            }
        
        callChatGPTAPI(with: userInput) { [weak self] response in
            DispatchQueue.main.async {
                let endTime = Date()
                let elapsedTime = endTime.timeIntervalSince(startTime)
                print("İşlem süresi: \(elapsedTime) saniye")
                
                // Gelen cevabı kontrol ediyoruz
                if let jsonData = response.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    do {
                        let questions = try decoder.decode([Question].self, from: jsonData)
                        updateQuestionsInViewModel(with: questions)
                        
                        // API cevabından sonra diğer işlemlere devam ediyoruz
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

    // API çağrısı sonrası işlemleri burada tanımlayın
    func continueAfterAPIResponse() {
        print("API cevabından sonra işlemler devam ediyor...")
        
        // Firebase'den veri çekmek
        let databaseRef = Database.database().reference()
        
        let formattedDate = formatCurrentDate()
        

        func addUserToFirebase() {
            let usersRef = Database.database().reference().child("users")
            
            // Kullanıcı sayısını al
            usersRef.observeSingleEvent(of: .value) { snapshot in
            
                // Kullanıcı sayısını belirlemek için snapshot içindeki veriyi kontrol et
                let userCount = snapshot.childrenCount

                // Yeni kullanıcıyı eklemek için doğru user id'sini oluştur
                let userKey = "user\(userCount + 1)"

                let noteTitle = self.noteTitleTextView.text ?? ""  // Optional kontrolü
                let noteBody = self.noteBodyTextView.text ?? ""   // Optional kontrolü
                let emailAdresi = self.girisEkrani?.girisYapilanMailAdresi

                // Kullanıcı verisini oluştur
                let newUser: [String: Any] = [
                    "info": [
                        "userId": "\(userCount + 1)",
                        "userName": "kullaniciadi",
                        "email": "\(emailAdresi ?? "noteai@noteai.com")",
                        "name": "Ad Soyad",
                        "streak": "15"
                    ],
                    "userNotes": [
                        "note1": [
                            "notId": "1",
                            "title": "\(noteTitle)",
                            "text": "\(noteBody)",
                            "lastUpdate": "\(formattedDate)"
                        ]
                    ]
                ]

                // Veriyi belirli bir anahtara (user1, user2, ...) ekle
                usersRef.child(userKey).setValue(newUser) { error, _ in
                    if let error = error {
                        print("Veri eklenirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Veri başarıyla eklendi.")
                    }
                }
            }
        }
        
        addUserToFirebase()
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
        
        /*var dotCount = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            dotCount = (dotCount + 1) % 4
            let dots = String(repeating: ".", count: dotCount)
            loadingLabel.text = "Sorularınız hazırlanıyor\(dots)"
        }*/
        
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
            print("PDF açılamadı.")
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        viewModel?.processPDF(url: url)
        noteBodyTextView.textColor = .white
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Kullanıcı dosya seçim ekranını iptal etti.")
    }
}
