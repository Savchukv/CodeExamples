//
//  Router.swift
//
//  Created by Василий Савчук on 06/11/2018.
//  Copyright © 2018
//  Idea by Sacha Durand Saint Omer
//

import UIKit

public enum NavigationType {
    case push
    case modal
    case pop
    case root
}

public class Router {
    public static let `default`: IsRouter = DefaultRouter()
}

public protocol Navigation {
    func viewcontrollerForNavigation(navigation: Navigation) -> UIViewController
}

extension Navigation {
    func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController, type: NavigationType) {
        if appDelegate.window == nil {
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            appDelegate.window?.makeKeyAndVisible()
        }
        switch type {
        case .modal:
            to.modalPresentationStyle = .overFullScreen
            to.modalTransitionStyle = .coverVertical
            appDelegate.window?.rootViewController?.present(to, animated: true, completion: nil)
        case .pop:
            from.navigationController?.popViewController(animated: true)
        case .push:
            from.navigationController?.pushViewController(to, animated: true)
        case .root:
            appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
            appDelegate.window?.rootViewController = to
        }
    }
}

public protocol IsRouter {
    func navigate(_ navigation: Navigation, from: UIViewController, type: NavigationType)
    func didNavigate(block: @escaping (Navigation) -> Void)
}

public extension UIViewController {
    func navigate(_ navigation: Navigation, type: NavigationType) {
        Router.default.navigate(navigation, from: self, type: type)
    }
}

public class DefaultRouter: IsRouter {

    var didNavigateBlocks = [((Navigation) -> Void)]()

    public func navigate(_ navigation: Navigation, from: UIViewController, type: NavigationType) {
        let toVC = navigation.viewcontrollerForNavigation(navigation: navigation)
        navigation.navigate(navigation, from: from, to: toVC, type: type)
        for b in didNavigateBlocks {
            b(navigation)
        }
    }

    public func didNavigate(block: @escaping (Navigation) -> Void) {
        didNavigateBlocks.append(block)
    }
}
