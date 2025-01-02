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
    
    func updateQuestionsInViewModel(with questions: [Question]) {
            quizViewModel?.updateQuestions(with: questions)
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
        
        guard let userInput = noteBodyTextView.text, !userInput.isEmpty else {
                   print("Lütfen bir metin girin.")
                   return
        }
        
        callChatGPTAPI(with: userInput) { [weak self] response in
            DispatchQueue.main.async {
               
                print("Gelen Cevap:\(response)")
                if let jsonData = response.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    do {
                        let questions = try decoder.decode([Question].self, from: jsonData)
                        self?.updateQuestionsInViewModel(with: questions)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else {
                    print("Error: Unable to convert string to data")
                }
            }
            
        }

        
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
