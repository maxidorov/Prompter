//
//  TextsViewController.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import CoreData

class TextsViewController: BaseViewController {

  internal var context: NSManagedObjectContext! {
    didSet {
      setupFetchedResultsController(for: context)
      fetchData()
    }
  }

  internal var backgroundContext: NSManagedObjectContext!

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.separatorStyle = .none
      tableView.contentInset = UIEdgeInsets(
        top: 0, left: 0, bottom: 44 + 16 + 16, right: 0
      )
    }
  }

  @IBOutlet weak var addTextButtonOutlet: BottomButton! {
    didSet {
      addTextButtonOutlet.setBackgroundImage(
        UIImage(named: "button-add-background"), for: .normal
      )
    }
  }

  @IBOutlet weak var settingsButtonOutlet: UIButton! {
    didSet {
      settingsButtonOutlet.setBackgroundImage(
        UIImage(named: "button-settings-background"), for: .normal
      )
    }
  }

  @IBOutlet weak var noContentLabel: UILabel! {
    didSet {
      noContentLabel.isHidden = true
      noContentLabel.text = Localized.tapHereToAddYourFirstNote()
      noContentLabel.textColor = .lightGray
      noContentLabel.font = Brandbook.font(size: 26, weight: .bold)
      noContentLabel.numberOfLines = 0
    }
  }

  internal let cellIdentifier = "TextCellIdentifier"

  internal var fetchedResultsController: NSFetchedResultsController<Text>?

  internal lazy var tapOnTableView: UITapGestureRecognizer = {
    UITapGestureRecognizer(
      target: self,
      action: #selector(tapOnTableViewAction)
    )
  }()

  private func setupFetchedResultsController(
    for context: NSManagedObjectContext
  ) {
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    let request = NSFetchRequest<Text>(entityName: "Text")
    request.sortDescriptors = [sortDescriptor]
    fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    fetchedResultsController?.delegate = self
  }

  private func fetchData() {
    do {
      try fetchedResultsController?.performFetch()
    } catch {
      print("ERROR: fetch data error: \(error)")
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    tableView.reloadData()
    setupManagedObjectContextDidSaveNotification()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    addTextButtonOutlet.cornerRadius = addTextButtonOutlet.frame.height / 2
    addTextButtonOutlet.addShadow()
    settingsButtonOutlet.cornerRadius = settingsButtonOutlet.frame.height / 2
    settingsButtonOutlet.addShadow()
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(
      UINib(nibName: "TextPreviewTableViewCell", bundle: nil),
      forCellReuseIdentifier: cellIdentifier
    )
    tableView.addGestureRecognizer(tapOnTableView)
  }

  @objc private func tapOnTableViewAction() {
    if tableView.numberOfSections == 0 ||
        (tableView.numberOfSections > 0 &&
          tableView.numberOfRows(inSection: 0) == 0) {
      addTextButtonAction(addTextButtonOutlet)
    }
  }

  private func setupManagedObjectContextDidSaveNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(managedObjectContextDidSave(notification:)),
      name: NSNotification.Name.NSManagedObjectContextDidSave,
      object: nil
    )
  }

  @objc private func managedObjectContextDidSave(notification: Notification) {
    context.perform {
      self.context.mergeChanges(fromContextDidSave: notification)
    }
  }

  @IBAction func addTextButtonAction(_ sender: BottomButton) {
    let textEditViewController = prepareTextEditViewController(.newNote)
    navigationController?.pushViewController(
      textEditViewController,
      animated: true
    )
  }

  internal func prepareTextEditViewController(
    _ textEditMode: NoteEditMode
  ) -> TextEditViewController {
    let textEditViewController = TextEditViewController()
    textEditViewController.noteEditMode = textEditMode
    textEditViewController.context = context
    textEditViewController.backgroundContext = backgroundContext
    return textEditViewController
  }

  @IBAction func settingsButtonAction(_ sender: Any) {
    present(
      BaseNavigationViewController(
        rootViewController: SettingsViewController()
      ),
      animated: true,
      completion: nil
    )
  }
}
