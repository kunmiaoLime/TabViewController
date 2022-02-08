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

  var count: Int {
    tabViews.count
  }

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

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupTabConstraints()
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
    tabContentView.delegate = self
    tabContentView.bounces = false
    tabContentView.clipsToBounds = true
    tabContentView.showsHorizontalScrollIndicator = false
    tabContentView.isPagingEnabled = true
    tabContentView.contentSize = .init(width: view.frame.width * CGFloat(count),
                                       height: view.frame.height - 100)
    tabContentView.backgroundColor = .cyan

    for tabView in tabViews {
      tabContentView.addSubview(tabView.view)
    }
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

  private func setupTabConstraints() {
    let size = tabContentView.frame.size
    for index in 0..<count {
      tabViews[index].view.frame = .init(
        origin: .init(x: CGFloat(index) * size.width, y: 0),
        size: size
      )
    }
  }
}

// MARK: - UIScrollViewDelegate

extension TabViewController: UIScrollViewDelegate {}

