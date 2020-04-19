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
        cell.titleTextLabel.text = textObject.text
        return cell
    }
}
