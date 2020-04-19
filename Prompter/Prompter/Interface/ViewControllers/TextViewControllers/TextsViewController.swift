//
//  TextsViewController.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import CoreData

class TextsViewController: UIViewController {
    
    public var context: NSManagedObjectContext! {
        didSet {
            setupFetchedResultsController(for: context)
            fetchData()
        }
    }
    public var backgroundContext: NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    
    
    @IBOutlet weak var addTextButtonOutlet: BottomButton! {
        didSet {
            addTextButtonOutlet.setTitle("New Text", for: .normal)
        }
    }
    
    internal let cellIdentifier = "TextCellIdentifier"
    
    internal var fetchedResultsController: NSFetchedResultsController<Text>?
    
    private func setupFetchedResultsController(for context: NSManagedObjectContext) {
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
        let request = NSFetchRequest<Text>(entityName: "Text")
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    private func fetchData() {
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("ERROR: fetch data error: \(error)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        tableView.reloadData()
        setupManagedObjectContextDidSaveNotification()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TextPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupManagedObjectContextDidSaveNotification() {
         NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc private func managedObjectContextDidSave(notification: Notification) {
        context.perform {
            self.context.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    @IBAction func addTextButtonAction(_ sender: BottomButton) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let textObject = Text(context: self.backgroundContext)
            textObject.text = "La-la-la"
            self.backgroundContext.performAndWait {
                do {
                    try self.backgroundContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}
