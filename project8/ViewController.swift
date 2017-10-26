//
//  ViewController.swift
//  project8
//
//  Created by Mac on 2017/10/25.
//  Copyright © 2017年 Sunny, Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  static let tableCellID: String = "tableViewCellID_section_#"

  let numberOfSections: Int = 20
  let numberOfCollectionsForRow: Int = 1
  let numberOfCollectionItems: Int = 20
  
  var colorsDict: [Int: [UIColor]] = [:]
  
  /// Set true to enable UICollectionViews scroll pagination
  var paginationEnabled: Bool = true
  
  /// Collection flow layout constant
  let collectionTopInset: CGFloat = 0
  let collectionBottomInset: CGFloat = 0
  let collectionLeftInset: CGFloat = 10
  let collectionRightInset: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    // Uncomment the following line to preserve selection between
    // presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the
    // navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    for tableViewSection in 0..<numberOfSections {
      var colorsArray: [UIColor] = []
      
      for _ in 0..<numberOfCollectionItems {
        var randomRed: CGFloat = CGFloat(arc4random_uniform(256))
        let randomGreen: CGFloat = CGFloat(arc4random_uniform(256))
        let randomBlue: CGFloat = CGFloat(arc4random_uniform(256))
        
        if randomRed == 255.0 && randomGreen == 255.0 && randomBlue == 255.0 {
          randomRed = CGFloat(arc4random_uniform(128))
        }
        
        colorsArray.append(UIColor(red: randomRed / 255.0, green: randomGreen / 255.0, blue: randomBlue / 255.0, alpha: 1.0))
      }
      
      colorsDict[tableViewSection] = colorsArray
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}
extension ViewController: UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  // MARK: <UITableView Data Source>
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfCollectionsForRow
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Instead of having a single cellIdentifier for each type of
    // UITableViewCells, like in a regular implementation, we have multiple
    // cellIDs, each related to a indexPath section. By Doing so the
    // UITableViewCells will still be recycled but only with
    // dequeueReusableCell of that section.
    //
    // For example the cellIdentifier for section 4 cells will be:
    //
    // "tableViewCellID_section_#3"
    //
    // dequeueReusableCell will only reuse previous UITableViewCells with
    // the same cellIdentifier instead of using any UITableViewCell as a
    // regular UITableView would do, this is necessary because every cell
    // will have a different UICollectionView with UICollectionViewCells in
    // it and UITableView reuse won't work as expected giving back wrong
    // cells.
    var cell: TableViewCell? = tableView.dequeueReusableCell(withIdentifier: ViewController.tableCellID + indexPath.section.description) as? TableViewCell
    
    if cell == nil {
      cell = TableViewCell(style: .default, reuseIdentifier: ViewController.tableCellID + indexPath.section.description)
      
      // Configure the cell...
      cell!.selectionStyle = .none
      cell!.collectionViewPaginatedScroll = paginationEnabled
    }
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section: " + section.description
  }
  
  // MARK: <UITableView Delegate>
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 88
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 28
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.0001
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell: TableViewCell = cell as? TableViewCell else {
      return
    }
    
    cell.setCollectionView(dataSource: self, delegate: self, indexPath: indexPath)
  }
  
  // MARK: <UICollectionView Data Source>
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfCollectionItems
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
      fatalError("UICollectionViewCell must be of GLIndexedCollectionViewCell type")
    }
    
    guard let indexedCollectionView: CollectionView = collectionView as? CollectionView else {
      fatalError("UICollectionView must be of GLIndexedCollectionView type")
    }
    
    // Configure the cell...
    cell.background.backgroundColor = colorsDict[indexedCollectionView.indexPath.section]?[indexPath.row]
    cell.sampleLabel.text = "A"
    
    return cell
  }
  
  // MARK: <UICollectionViewDelegate Flow Layout>
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: collectionTopInset, left: collectionLeftInset, bottom: collectionBottomInset, right: collectionRightInset)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let tableViewCellHeight: CGFloat = tableView.rowHeight
    let collectionItemWidth: CGFloat = tableViewCellHeight - (collectionLeftInset + collectionRightInset)
    let collectionViewHeight: CGFloat = collectionItemWidth
    
    return CGSize(width: collectionItemWidth, height: collectionViewHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  // MARK: <UICollectionView Delegate>
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
}



