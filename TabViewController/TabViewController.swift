//
//  ViewController.swift
//  TabViewController
//
//  Created by Kunmiao Yang on 2/7/22.
//

import SnapKit
import UIKit

protocol UITabViewable {
  var view: UIView! { get set }
  var tabTitle: String { get set }
}

class TabViewController: UIViewController {
  let tabButtonView = UIView()
  let tabContentView = UIScrollView()
  var tabViews: [UITabViewable]

  init(tabViews: [UITabViewable]) {
    self.tabViews = tabViews
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    self.tabViews = []
    super.init(coder: coder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  // MARK: - setupUI
  private func setupUI() {
    setupTabButtonView()
    setupTabContenView()
    setupConstraints()
  }

  private func setupTabButtonView() {
    view.addSubview(tabButtonView)
    tabButtonView.backgroundColor = .yellow
  }

  private func setupTabContenView() {
    view.addSubview(tabContentView)
    tabContentView.backgroundColor = .cyan
  }

  // MARK: - setupConstraints

  private func setupConstraints() {
    tabButtonView.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(100)
    }

    tabContentView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(tabButtonView.snp.bottom)
    }
  }
}

