//
//  CollectionViewCell.swift
//  project8
//
//  Created by Mac on 2017/10/26.
//  Copyright © 2017年 Sunny, Lee. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  static let identifier: String = "collectionViewCellID"
  
  @IBOutlet weak var sampleLabel: UILabel!
  @IBOutlet weak var background: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
}
