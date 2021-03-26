//
//  DetailViewController.swift
//  Day74Challange
//
//  Created by Eren Erinanc on 14.03.2021.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var noteText: UITextView!
    
//    @IBOutlet var titleField: UITextField!
//
//    override func loadView() {
//        view = UIView()
//        view.backgroundColor = .white
//
//        titleField = UITextField()
//        titleField.translatesAutoresizingMaskIntoConstraints = false
//        titleField.textAlignment = .left
//        view.addSubview(titleField)
//
//        noteText = UITextView()
//        noteText.translatesAutoresizingMaskIntoConstraints = false
//        noteText.textAlignment = .left
//        view.addSubview(noteText)
//
//        NSLayoutConstraint.activate([
//            titleField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            titleField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            titleField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//            titleField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
//
//            noteText.topAnchor.constraint(equalTo: titleField.bottomAnchor),
//            noteText.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            noteText.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//            noteText.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
//            noteText.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
//        ])
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteText.delegate = self
        
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.isTranslucent = false
        navigationController?.toolbar.backgroundColor = .white
        navigationController?.toolbar.barTintColor = .white
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
    
        var items = [UIBarButtonItem]()
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        deleteButton.tintColor = .systemYellow
        shareButton.tintColor = .systemYellow
        items.append(deleteButton)
        items.append(flexibleSpace)
        items.append(shareButton)
        toolbarItems = items
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
//        let html = """
//        <p><strong><span style="font-size: 40px;">\(notes[selectedIndex].title)</span></strong></p>
//       """
//
//        let data = Data(html.utf8)
//        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
//            noteText.attributedText = attributedString

//        }
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

//    func textViewDidBeginEditing(_ textView: UITextView) {
//        noteText.backgroundColor = .lightGray
//    }

    func textViewDidEndEditing(_ textView: UITextView) {
        noteText.backgroundColor = .white
    }
    
    @objc func deleteTapped() {
        noteText.text = ""
        if let vc = storyboard?.instantiateViewController(identifier: "TableView") as? ViewController {
            vc.save()
            vc.tableView.reloadData()
        }

    }
    
    @objc func shareTapped() {
        guard noteText.text != nil else { return }
        let ac = UIActivityViewController(activityItems: [noteText.text ?? ""], applicationActivities: [])
        present(ac, animated: true)
    }
    
    @objc func doneTapped() {
        if let vc = storyboard?.instantiateViewController(identifier: "TableView") as? ViewController {
            if selectedIndex == -1 {
                selectedIndex = 0
            }
            notes[selectedIndex].title = self.getNoteTitle()
            notes[selectedIndex].body = self.noteText.text
            vc.save()
            vc.tableView.reloadData()

        }
    }
    
    func getNoteTitle() -> String {
        let components = self.noteText.text.components(separatedBy: "\n")
        for component in components {
            if component.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 {
                return component
            }
        }
        return self.navigationItem.title ?? "New note"
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            noteText.contentInset = .zero
        } else {
            noteText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            noteText.scrollIndicatorInsets = noteText.contentInset
        }


        let selectedRange = noteText.selectedRange
        noteText.scrollRangeToVisible(selectedRange)
    }
    

 
}
  
