//
//  TextsViewController+UITableViewDataSource.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import CoreData

extension TextsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TextPreviewTableViewCell else {
            return UITableViewCell()
        }
        guard let textObject = fetchedResultsController?.object(at: indexPath) else {
            return cell
        }
        cell.titleLabel.text = textObject.title
        cell.subtitleLabel.text = textObject.text
        cell.dateLabel.date = textObject.date!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let textEditViewController = prepareTextEditViewController(.editText)
        textEditViewController.textEntity = fetchedResultsController?.object(at: indexPath)
        presentFullScreen(textEditViewController)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
                guard `self` != nil else { return }
                self?.deleteObject(at: indexPath)
                completionHandler(true)
            }
//            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.title = "Delete"
            deleteAction.backgroundColor = .systemGreen
            
            let shareAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
                guard `self` != nil else { return } 
                print("Shared!")
                completionHandler(true)
            }
//            shareAction.image = UIImage(named: "")
            shareAction.title = "Share"
            shareAction.backgroundColor = .systemBlue
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
            return configuration
            
    }
    
    fileprivate func deleteObject(at indexPath: IndexPath) {
        guard let managedObject: NSManagedObject = fetchedResultsController?.object(at: indexPath) else { return }
        context.delete(managedObject);
        CoreDataManager.saveContext(context)
    }
}
