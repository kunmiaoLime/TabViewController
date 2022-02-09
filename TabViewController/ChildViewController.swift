//
//  TabViewController.swift
//  TabViewController
//
//  Created by Kunmiao Yang on 2/7/22.
//

import RxRelay
import RxSwift
import SnapKit
import UIKit

class ChildViewController: UIViewController, UITabViewable {
  private let titleRelay: BehaviorRelay<String>
  let titleObservable: Observable<String>

  let button = UIButton()

  var bgColor: UIColor? {
    didSet {
      view.backgroundColor = bgColor
    }
  }

  init(title: String, bgColor: UIColor) {
    self.titleRelay = .init(value: title)
    self.titleObservable = titleRelay.asObservable()
    self.bgColor = bgColor
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = bgColor

    view.addSubview(button)
    button.backgroundColor = .white
    button.setTitle("+", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = .systemFont(ofSize: 20)
    button.addTarget(self, action: #selector(didTabAddButton), for: .touchUpInside)

    button.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.width.equalTo(40)
    }
  }

  @objc
  private func didTabAddButton() {
    titleRelay.accept(titleRelay.value + "+")
  }
}
