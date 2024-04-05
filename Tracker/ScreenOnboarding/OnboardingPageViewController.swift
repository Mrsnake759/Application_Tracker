//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 27.01.2024.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    //MARK: - UI
    private lazy var pages: [UIViewController] = {
        let firstScreen = FirstScreenOnboardingViewController()
        let secondScreen = SecondScreenOnboardingViewController()
        return [firstScreen, secondScreen]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var skipButton: UIButton = {
        let button  = UIButton(type: .system)
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle(NSLocalizedString("Technologies", comment: ""), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Initializers
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(skipButton.heightAnchor.constraint(equalToConstant: 60))
        constraints.append(skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        constraints.append(skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        constraints.append(skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50))
        
        constraints.append(pageControl.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -24))
        constraints.append(pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView() {
        view.addSubview(skipButton)
        view.addSubview(pageControl)
        
        dataSource = self
        delegate = self
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    // MARK: - Objc Methods
    @objc private func skipButtonClicked() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Ошибка с инициализацией AppDelegate")
        }
        appDelegate.window?.rootViewController = TabBarController()
    }
}
// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else  {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}
// MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
