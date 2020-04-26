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
        guard let textEntity = fetchedResultsController?.object(at: indexPath) else {
            return cell
        }
        cell.textEntity = textEntity
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let textEditViewController = prepareTextEditViewController(.editText)
        textEditViewController.textEntity = fetchedResultsController?.object(at: indexPath)
        navigationController?.pushViewController(textEditViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            
            addTextButtonOutlet.setAlphaWithAnimation(0, duration: 0.2)
            
            let sizeScale: CGFloat = 1.4
            
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
                guard `self` != nil else { return }
                self?.deleteObject(at: indexPath)
                completionHandler(true)
            }
            let trashIcon = UIImage(systemName: "trash")!.withTintColor(Brandbook.tintColor)
            var size = CGSize(width: trashIcon.size.width * sizeScale, height: trashIcon.size.height * sizeScale)
            deleteAction.image = UIGraphicsImageRenderer(size: size).image {
                _ in trashIcon.draw(in: CGRect(origin: .zero, size: size))
            }
            deleteAction.backgroundColor = .white
            
            let shareAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
                guard `self` != nil else { return } 
                print("Copied!")
                completionHandler(true)
            }
            
            let shareIcon = UIImage(systemName: "doc.on.doc")!.withTintColor(Brandbook.tintColor)
            size = CGSize(width: shareIcon.size.width * sizeScale, height: shareIcon.size.height * sizeScale)
            shareAction.image = UIGraphicsImageRenderer(size: size).image {
                _ in shareIcon.draw(in: CGRect(origin: .zero, size: size))
            }
            shareAction.backgroundColor = .white
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
            return configuration
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if !tableView.isEditing {
            addTextButtonOutlet.setAlphaWithAnimation(1, duration: 0.2)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        addTextButtonOutlet.setAlphaWithAnimation(0.3, duration: 0.3)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        addTextButtonOutlet.setAlphaWithAnimation(1, duration: 0.2)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            addTextButtonOutlet.setAlphaWithAnimation(1, duration: 0.2)
        }
    }
    
    fileprivate func deleteObject(at indexPath: IndexPath) {
        guard let managedObject: NSManagedObject = fetchedResultsController?.object(at: indexPath) else { return }
        context.delete(managedObject);
        CoreDataManager.saveContext(context)
    }
}
