//
//  NoteDetailsController.swift
//  NotAI
//
//  Created by Samed Karakuş on 1.01.2025.
//

import Foundation
import UIKit

class NoteDetailsController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var lastNoteDate: UILabel!
    @IBOutlet weak var modalLine: UIImageView!
    @IBOutlet weak var noteSearchBar: UISearchBar!
    @IBOutlet weak var noteDetailsTableView: UITableView!
    
    var viewModel = NoteDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        connectTable(to: noteDetailsTableView)
        addModalLine()
        addLastNoteDate()
        activateLightModeForSearchBar(to: noteSearchBar)
        editTitle()
        makeButtonRound()
    }
    
    func makeButtonRound() {
        addNoteButton.layer.cornerRadius = addNoteButton.frame.height / 2
        view.layer.masksToBounds = true
    }
    
    func editTitle() {
        let title = viewModel.filteredNotes.count
        mainTitle.text = "Notlarım (\(title))"
    }
    
    func addLastNoteDate() {
        if let lastNote = viewModel.notes.last?.createdDate.formatted() {
            lastNoteDate.text = "Son düzenleme: \(lastNote)"
        }
    }
    
    func addModalLine() {
        modalLine.backgroundColor = .lightGray
        modalLine.layer.cornerRadius = modalLine.frame.height / 2
        modalLine.clipsToBounds = true
    }
    
    func connectTable(to table: UITableView) {
        viewModel.filteredNotes = viewModel.notes
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: Constants.noteCellNibName, bundle: nil), forCellReuseIdentifier: Constants.noteCellIdentifier)
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        
        if let searchTextField = noteSearchBar.value(forKey: "searchField") as? UITextField {
            noteSearchBar.barStyle = .default
            searchTextField.font = UIFont.systemFont(ofSize: 14)
            searchTextField.layer.cornerRadius = 15
            searchTextField.clipsToBounds = true
            noteSearchBar.layer.cornerRadius = 15
            noteSearchBar.layer.masksToBounds = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredNotes(by: searchText)
        noteDetailsTableView.reloadData()
    }
    
    @IBAction func addNewNoteButtonPressed(_ sender: UIButton) {
        if let targetVC = storyboard?.instantiateViewController(withIdentifier: "NoteViewController") {
            targetVC.modalPresentationStyle = .fullScreen
            present(targetVC, animated: true, completion: nil)
        }
    }
}

extension NoteDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteDetailsTableView.dequeueReusableCell(withIdentifier: Constants.noteCellIdentifier, for: indexPath) as! NoteCell
        let note = viewModel.filteredNotes[indexPath.row]
        
        cell.noteTitle.text = "# \(note.title)"
        cell.noteDetails.text = note.body
        cell.dateLabel.text = note.createdDate.formatted()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.filteredNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { (action, view, completionHandler) in
            self.viewModel.filteredNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

