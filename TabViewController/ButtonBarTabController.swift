//
//  ButtonBarTabController.swift
//  TabViewController
//
//  Created by Kunmiao Yang on 2/7/22.
//

import UIKit

public final class ButtonBarTabController: UIControl {
  public struct Style {
  }
  weak public var listener: TabControlListener?
}

// MARK: - UITabControllable

extension ButtonBarTabController: UITabControllable {

}
