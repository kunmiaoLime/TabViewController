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

public protocol UITabViewable {
  var view: UIView! { get set }
  var tabTitle: String { get set }
}

public protocol UITabControllable: AnyObject {
  var titles: [String] { get set }
  var listener: TabControlListener? { get set }
  func scrollViewDidScroll(at position: CGFloat)
  func scroll(to index: Int, animated: Bool)
}

public protocol TabControlListener: AnyObject {
  func scroll(to index: Int, animated: Bool)
}

open class TabViewController: UIViewController {
  public typealias UITabControl = UIControl & UITabControllable
  public struct IndexChange: Equatable {
    let prev: Int
    let current: Int
  }

  private let indexRelay: BehaviorRelay<IndexChange>
  private let disposeBag = DisposeBag()
  let indexObservable: Observable<IndexChange>
  let tabController: UITabControl
  let tabContentView = UIScrollView()
  var tabViews: [UITabViewable]
  var synchronizePosition: Bool = false

  var count: Int {
    tabViews.count
  }

  public init(tabViews: [UITabViewable],
              tabController: UITabControl) {
    self.indexRelay = .init(value: .init(prev: 0, current: 0))
    self.indexObservable = indexRelay.distinctUntilChanged()
    self.tabViews = tabViews
    self.tabController = tabController
    super.init(nibName: nil, bundle: nil)
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupTabConstraints()
  }

  // MARK: - setupUI
  private func setupUI() {
    setupView()
    setupTabController()
    setupTabContenView()
    setupConstraints()
  }

  private func setupView() {
    view.backgroundColor = .white
  }

  private func setupTabController() {
    view.addSubview(tabController)
    tabController.listener = self
    tabController.titles = tabViews.map { $0.tabTitle }
    tabController.backgroundColor = .clear
  }

  private func setupTabContenView() {
    view.addSubview(tabContentView)
    tabContentView.delegate = self
    tabContentView.bounces = false
    tabContentView.clipsToBounds = true
    tabContentView.showsHorizontalScrollIndicator = false
    tabContentView.isPagingEnabled = true
    let barFrame = tabController.frame
    tabContentView.contentSize = .init(width: view.frame.width * CGFloat(count),
                                       height: view.frame.height - barFrame.height - barFrame.minY)
    tabContentView.backgroundColor = .cyan

    for tabView in tabViews {
      tabContentView.addSubview(tabView.view)
    }

    indexObservable.subscribe(onNext: { indexChange in
      guard indexChange.prev != indexChange.current else { return }
      print("Prev: \(indexChange.prev), Current: \(indexChange.current)")
    }).disposed(by: disposeBag)
  }

  // MARK: - setupConstraints
  private func setupConstraints() {
    tabController.snp.makeConstraints { make in
      let frame = tabController.frame
      make.leading.equalToSuperview().offset(frame.minX)
      make.top.equalToSuperview().offset(frame.minY)
      make.size.equalTo(frame.size)
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
    let pos = scrollView.contentOffset.x / view.frame.width
    if synchronizePosition {
      tabController.scrollViewDidScroll(at: pos)
    }
    let index = Int(round(pos))
    let prevIndex = indexRelay.value.current
    if prevIndex != index {
      print("accept pos: \(pos)")
      indexRelay.accept(.init(prev: prevIndex, current: index))
      if !synchronizePosition {
        tabController.scroll(to: index, animated: true)
      }
    }
  }
}

// MARK: - TabContentScrollable
extension TabViewController: TabControlListener {
  public func scroll(to index: Int, animated: Bool = true) {
    guard index >= 0 && index < count else { return }
    let size = tabContentView.frame.size
    let frame = CGRect(origin: .init(x: CGFloat(index) * size.width, y: 0), size: size)
    tabContentView.scrollRectToVisible(frame, animated: animated)
  }
}
