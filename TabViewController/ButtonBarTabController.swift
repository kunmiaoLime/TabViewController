//
//  ButtonBarTabController.swift
//  TabViewController
//
//  Created by Kunmiao Yang on 2/7/22.
//

import SnapKit
import UIKit

public final class ButtonBarTabController: UIControl {
  private struct Constants {
    public let animateDuration: TimeInterval = 0.3
  }

  public struct Style {
    public struct Button {
      public var buttonBackgroundColor: UIColor
      public var buttonFont: UIFont
      public var buttonFontColor: UIColor
    }

    public var stripHeight: CGFloat = 3
    public var stripTopPadding: CGFloat = 0
    public var stripCornerRadius: CGFloat? = 1.5
    public var stripColor: UIColor = .green

    public var buttonHeight: CGFloat = 19
    public var buttonPadding: CGFloat = 40
    public var buttonNormal: Button = .init(buttonBackgroundColor: .clear, buttonFont: .systemFont(ofSize: 16), buttonFontColor: .darkGray)
    public var buttonHighlight: Button = .init(buttonBackgroundColor: .clear, buttonFont: .systemFont(ofSize: 16), buttonFontColor: .black)
  }

  private let constants = Constants()
  public var style: Style
  public var titles: [String] = [] {
    didSet {
      setupUI()
    }
  }
  public var currentIndex: Int = 0 {
    didSet {
      setupLabel(labelViews[oldValue], highlight: false)
      setupLabel(labelViews[currentIndex], highlight: true)
    }
  }
  let contentView = UIView()
  let scrollView = UIScrollView()
  var labelViews: [UILabel] = []
  let stripView = UIView()

  weak public var listener: TabControlListener?

  private var contentWidth: CGFloat {
    guard !titles.isEmpty else { return 0 }
    var width = labelViews[0].frame.width
    for index in 1..<count {
      width += labelViews[index].frame.width + style.buttonPadding
    }
    return width
  }

  var count: Int {
    titles.count
  }

  init(titles: [String] = [], frame: CGRect = .zero, style: Style = .init()) {
    self.style = style
    self.titles = titles
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = .init(
      x: 0,
      y: 0,
      width: contentWidth,
      height: scrollView.frame.height
    )
  }

  // MARK: - setupUI
  private func setupUI() {
    setupScrollView()
    setupContentView()
    setupLabels()
    setupStrip()
    setupConstraints()
  }

  private func setupScrollView() {
    if scrollView.superview == nil {
      addSubview(scrollView)
    }
    scrollView.contentSize = frame.size
  }

  private func setupContentView() {
    if contentView.superview == nil {
      scrollView.addSubview(contentView)
    }
  }

  private func setupLabels() {
    for index in 0..<count {
      if index >= labelViews.count {
        let label = UILabel()
        setupLabel(label, at: index)
        labelViews.append(label)
      } else {
        setupLabel(labelViews[index], at: index)
      }
    }

    if count < labelViews.count {
      for index in count..<labelViews.count {
        labelViews[index].removeFromSuperview()
      }
    }
  }

  private func setupLabel(_ label: UILabel, at index: Int) {
    guard index < titles.count else { return }
    if label.superview == nil {
      contentView.addSubview(label)
    }
    setupLabel(label, highlight: index == currentIndex)
    label.text = titles[index]
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = false
    label.sizeToFit()

    let tap = UITapIndexGestureRecognizer(target: self, action: #selector(didTapLabel(sender:)))
    tap.index = index
    label.addGestureRecognizer(tap)
    label.isUserInteractionEnabled = true
  }

  private func setupLabel(_ label: UILabel, highlight: Bool) {
    let buttonStyle = highlight ? style.buttonHighlight : style.buttonNormal
    label.backgroundColor = buttonStyle.buttonBackgroundColor
    label.textColor = buttonStyle.buttonFontColor
    label.font = buttonStyle.buttonFont
  }

  private func setupStrip() {
    if stripView.superview == nil {
      contentView.addSubview(stripView)
    }
    stripView.backgroundColor = style.stripColor
    if let radius = style.stripCornerRadius {
      stripView.layer.cornerRadius = radius
      stripView.layer.masksToBounds = true
    }
  }

  // MARK: - setup constraints
  private func setupConstraints() {
    scrollView.snp.remakeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
    }

    let labelBottomInset = style.stripHeight + style.stripTopPadding
    for index in 0..<count {
      labelViews[index].snp.remakeConstraints { make in
        if index == 0 {
          make.leading.equalToSuperview()
        } else {
          make.leading.equalTo(labelViews[index - 1].snp.trailing).offset(style.buttonPadding)
        }
        if index == count - 1 {
          make.trailing.equalToSuperview()
        }
        make.bottom.equalToSuperview().inset(labelBottomInset)
      }
    }

    if currentIndex < labelViews.count {
      stripView.snp.remakeConstraints { make in
        make.leading.trailing.equalTo(labelViews[currentIndex])
        make.bottom.equalToSuperview()
        make.height.equalTo(style.stripHeight)
      }
    }
  }
}

// MARK: - private
extension ButtonBarTabController {
  private func select(index: Int, animate: Bool = true) {
    guard index >= 0 && index < count else { return }
    stripView.snp.remakeConstraints { make in
      make.leading.trailing.equalTo(labelViews[index])
      make.bottom.equalToSuperview()
      make.height.equalTo(style.stripHeight)
    }
    guard animate else {
      currentIndex = index
      contentView.layoutIfNeeded()
      return
    }

    UIView.animate(withDuration: constants.animateDuration,
                   delay: 0,
                   options: .curveEaseInOut) {
      self.contentView.layoutIfNeeded()
    } completion: { _ in
      self.currentIndex = index
    }
  }
}

// MARK: - @objc
extension ButtonBarTabController {
  @objc
  private func didTapLabel(sender: UITapIndexGestureRecognizer) {
    select(index: sender.index)
    listener?.scroll(to: sender.index, animated: true)
  }
}

// MARK: - UITabControllable

extension ButtonBarTabController: UITabControllable {

}

public class UITapIndexGestureRecognizer: UITapGestureRecognizer {
  var index: Int = -1
}
