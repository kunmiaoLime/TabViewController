//
//  TabViewController.swift
//  TabViewController
//
//  Created by Kunmiao Yang on 2/7/22.
//

import SnapKit
import UIKit

class ChildViewController: UIViewController {
  let titleView = UILabel()

  var titleText: String? {
    get { titleView.text }
    set { titleView.text = newValue }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(titleView)
    titleView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
  }
}
