//
//  TabViewController.swift
//  TabViewController
//
//  Created by Kunmiao Yang on 2/7/22.
//

import SnapKit
import UIKit

class ChildViewController: UIViewController, UITabViewable {
  var tabTitle: String = "Tab Name"
  var bgColor: UIColor? {
    didSet {
      view.backgroundColor = bgColor
    }
  }

  init(title: String, bgColor: UIColor) {
    self.tabTitle = title
    self.bgColor = bgColor
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
