//
//  ViewController.swift
//  Day74Challange
//
//  Created by Eren Erinanc on 14.03.2021.
//

import UIKit
var notes = [Note]()
var selectedIndex = -1

class ViewController: UITableViewController, NSTextStorageDelegate {
    var editButtonTapped: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        decode()
        
        title = "Folders"
      
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.isTranslucent = false
        navigationController?.toolbar.backgroundColor = .white
        navigationController?.toolbar.barTintColor = .white
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
     
        
        var items = [UIBarButtonItem]()
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addFolder))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        addButton.tintColor = .systemYellow
        items.append(flexibleSpace)
        items.append(addButton)

        toolbarItems = items
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(notes.count)
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        print(cell.textLabel?.text)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editButtonTapped {
            let ac = UIAlertController(title: "Rename folder", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Save", style: .default){ [weak self, weak ac] _ in
                if let folderName = ac?.textFields?[0].text {
                    notes[indexPath.row].title = folderName
                    if let button = self?.navigationItem.rightBarButtonItem {
                        button.isEnabled = true
                    }
                    self?.editButtonTapped = false
                    self?.save()
                    self?.tableView.reloadData()
                }
            })
            ac.view.tintColor = .systemYellow
            present(ac, animated: true)
        }
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            selectedIndex = indexPath.row
            let _ = vc.view
            vc.noteText.text = notes[indexPath.row].body
            print(notes[indexPath.row].body)
            save()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
            tableView.reloadData()
        }
    }

    
    @objc func addFolder() {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let _ = vc.view
            let newNote = Note(title: "New Note" , body: vc.noteText.text)
            submit(newNote)
            self.tableView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    
    @objc func editTapped(_ button: UIBarButtonItem) {
        button.isEnabled = false
        editButtonTapped = true
    }
    
    func submit(_ note: Note) {
        notes.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.reloadData()
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: notes, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        }
    }
     
    
    func decode() {
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            if let decodedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedNotes) as? [Note] {
                notes = decodedNotes
            }
        }
    }
}
    


