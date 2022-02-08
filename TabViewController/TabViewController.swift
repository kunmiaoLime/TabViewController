//
//  ViewController.swift
//  TabViewController
//
//  Created by Kunmiao Yang on 2/7/22.
//

import RxRelay
import RxSwift
import SnapKit
import UIKit

protocol UITabViewable {
  var view: UIView! { get set }
  var tabTitle: String { get set }
}

protocol UITabControllable: UIScrollViewDelegate {

}

open class TabViewController: UIViewController {
  typealias UITabControl = UIControl & UITabControllable
  public struct IndexChange: Equatable {
    let prev: Int
    let current: Int
  }

  private let indexRelay: BehaviorRelay<IndexChange>
  private let disposeBag = DisposeBag()
  let indexObservable: Observable<IndexChange>
  let tabController: UITabControl = ButtonBarTabController()
  let tabContentView = UIScrollView()
  var tabViews: [UITabViewable]

  var count: Int {
    tabViews.count
  }

  init(tabViews: [UITabViewable]) {
    self.indexRelay = .init(value: .init(prev: 0, current: 0))
    self.indexObservable = indexRelay.distinctUntilChanged()
    self.tabViews = tabViews
    super.init(nibName: nil, bundle: nil)
  }

  required public init?(coder: NSCoder) {
    self.indexRelay = .init(value: .init(prev: 0, current: 0))
    self.indexObservable = indexRelay.distinctUntilChanged()
    self.tabViews = []
    super.init(coder: coder)
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupTabConstraints()
  }

  // Override this to configure tab bar frame
  open func tabBarFrame() -> CGRect {
    return .init(x: 0, y: 0, width: view.frame.width, height: 100)
  }

  // MARK: - setupUI
  private func setupUI() {
    setupTabButtonView()
    setupTabContenView()
    setupConstraints()
  }

  private func setupTabButtonView() {
    view.addSubview(tabController)
    tabController.backgroundColor = .yellow
  }

  private func setupTabContenView() {
    view.addSubview(tabContentView)
    tabContentView.delegate = self
    tabContentView.bounces = false
    tabContentView.clipsToBounds = true
    tabContentView.showsHorizontalScrollIndicator = false
    tabContentView.isPagingEnabled = true
    let barFrame = tabBarFrame()
    tabContentView.contentSize = .init(width: view.frame.width * CGFloat(count),
                                       height: view.frame.height - barFrame.height - barFrame.minY)
    tabContentView.backgroundColor = .cyan

    for tabView in tabViews {
      tabContentView.addSubview(tabView.view)
    }

    indexObservable.subscribe(onNext: { indexChange in
      print("Prev: \(indexChange.prev), Current: \(indexChange.current)")
    }).disposed(by: disposeBag)
  }

  // MARK: - setupConstraints

  private func setupConstraints() {
    tabController.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(tabBarFrame().height)
    }

    tabContentView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(tabController.snp.bottom)
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

extension TabViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    tabController.scrollViewDidScroll?(scrollView)
  }

  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let index = Int(round(scrollView.contentOffset.x / view.frame.width))
    let prevIndex = indexRelay.value.current
    if prevIndex != index {
      indexRelay.accept(.init(prev: prevIndex, current: index))
    }
  }
}

