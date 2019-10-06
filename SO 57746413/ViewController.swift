//
//  ViewController.swift
//  SO 57746413
//
//  Created by acyrman on 10/6/19.
//  Copyright © 2019 iCyrman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

  @IBOutlet var table: UITableView!
  @IBOutlet var searchBar: UISearchBar!
  var resultSearchController = UISearchController()
  
  fileprivate var data = [
    "Central America": ["Costa Rica", "El Salvador", "Guatemala", "Nicaraga"],
    "South America": ["Argentina", "Brasil", "Colombia"],
    "North America": ["Canada", "Mexico", "United States of America"],
    "Europe": ["Belgium", "France", "Poland", "Spain"]
  ]
  
  fileprivate var displayableData = [String:[String]]() {
    didSet {
      DispatchQueue.main.async {
        self.table.reloadData()
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addSearchBar()
    table.dataSource = self
    displayableData = data
  }
  
  fileprivate func addSearchBar() {
    resultSearchController = ({
      let controller = UISearchController(searchResultsController: nil)
      controller.searchResultsUpdater = self
      controller.searchBar.sizeToFit()
      table.tableHeaderView = controller.searchBar
      navigationItem.searchController = resultSearchController
      controller.searchBar.delegate = self
      controller.hidesNavigationBarDuringPresentation = false
      return controller
    })()
  }
  
  
  func emptyTableViewMessage(with message: String) -> UIView {
    let messageLabel: UILabel = UILabel(frame: CGRect(x: table.bounds.size.width/2, y: table.bounds.size.height / 2 , width: table.bounds.size.width, height: table.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = UIColor.gray
    messageLabel.font = UIFont(name: "Open Sans", size: 15)
    messageLabel.textAlignment = .center
    return messageLabel
  }
  
  //MARK: Table's data source
  func numberOfSections(in tableView: UITableView) -> Int {
    return displayableData.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return Array(displayableData.keys).sorted()[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let key = Array(displayableData.keys).sorted()[section]
    guard let countries = displayableData[key] else { return 0 }
    return countries.count == 0 ? 1 : countries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let key = Array(displayableData.keys).sorted()[indexPath.section]
    guard let countries = displayableData[key] else { return UITableViewCell() }
    
    let notFound = countries.count == 0
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: notFound ? "NotFoundCellId" : "CellId") else { return UITableViewCell() }
    
    if notFound {
      cell.backgroundView = emptyTableViewMessage(with: "Not Found")
    } else {
      cell.textLabel?.text = countries[indexPath.row]
    }

    return cell
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    let textToSearch = searchController.searchBar.text!.lowercased()
    if textToSearch == "" {
      displayableData = data
    }
    else {
      data.keys.forEach { key in
        displayableData[key]! = data[key]!.filter { $0.lowercased().contains(textToSearch)
        }
      }
    }
  }
  
}

