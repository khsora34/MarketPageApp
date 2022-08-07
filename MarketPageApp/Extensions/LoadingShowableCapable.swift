import UIKit

protocol LoadingShowableCapable {
    var loadingViewController: UIViewController { get }
    func showLoading()
    func hideLoading()
}

extension LoadingShowableCapable {
    func showLoading() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        loadingViewController.view.addSubview(containerView)
        containerView.tag = 9999
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: loadingViewController.view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: loadingViewController.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: loadingViewController.view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: loadingViewController.view.bottomAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        guard let containerView = loadingViewController.view.subviews.first(where: { $0.tag == 9999 }) else { return }
        containerView.removeFromSuperview()
    }
}

extension LoadingShowableCapable where Self: UIViewController {
    var loadingViewController: UIViewController {
        return self
    }
}
