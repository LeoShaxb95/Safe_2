//
//  DefaultRouter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

public final class DefaultRouter: Routable {
    
    private weak var rootController: UINavigationController?
    
    private var completions: [UIViewController : () -> Void]
    
    // MARK: - Init
    
    public init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    // MARK: - Presentable
    
    public func toPresent() -> UIViewController? {
        rootController
    }
    
    // MARK: - Present
    
    public func present(module: Presentable?) {
        present(module: module, animated: true)
    }
    
    public func present(module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    // MARK: - Dismiss
    
    public func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - Push
    
    public func push(module: Presentable?)  {
        push(module: module, animated: true)
    }
    
    public func push(module: Presentable?, hideBottomBar: Bool)  {
        push(module: module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    public func push(module: Presentable?, animated: Bool)  {
        push(module: module, animated: animated, completion: nil)
    }
    
    public func push(module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module: module, animated: animated, hideBottomBar: false, completion: completion)
    }
    
    public func push(module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
        else {
            assertionFailure("Deprecated push UINavigationController.")
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        controller.hidesBottomBarWhenPushed = hideBottomBar
        rootController?.pushViewController(controller, animated: animated)
    }
    
    // MARK: - Pop
    
    public func pop()  {
        pop(animated: true)
    }
    
    public func pop(animated: Bool)  {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    public func popToRoot(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    public func popTo(module: AnyClass, animated: Bool)  {
        for controller in self.rootController!.viewControllers as Array {
            if controller.isKind(of: module.self) {
                self.rootController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    // MARK: - Set Root VC
    
    public func setRoot(module: Presentable?) {
        setRoot(module: module, hideBar: false)
    }
    
    public func setRoot(module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    // MARK: - Run Completion
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

