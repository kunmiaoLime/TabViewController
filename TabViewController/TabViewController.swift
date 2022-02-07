//
//  ViewController.swift
//  TabViewController
//
//  Created by Kunmiao Yang on 2/7/22.
//

import UIKit

class TabViewController: UIPageViewController {

  var tabs: [UIViewController] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  // MARK: - setupUI
  private func setupUI() {
    view.backgroundColor = .systemCyan
  }
}
