//
//  SplashViewController.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 19/10/23.
//

import UIKit

protocol SplashViewControllerDelegate {
    var viewState: ((SplashViewState) -> Void)? { get set }
    var loginViewModel: LoginViewControllerDelegate { get set }
    var heroesViewModel: HeroesViewControllerDelegate { get set }
    func onViewAppear()
}

// MARK: - View State -
enum SplashViewState {
    case loading(_ isLoading: Bool)
    case navigateToLogin
    case navigateToHeroes
}

class SplashViewController: UIViewController {
// MARK: - IBOutlet -
    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var splashActivity: UIActivityIndicatorView!
    
    var viewModel: SplashViewControllerDelegate?
    
// MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        viewModel?.onViewAppear()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: animated)
    }
    
// MARK: - Segues -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "SPLASH_TO_LOGIN":
                guard let loginViewController = segue.destination as? LoginViewController else { return }
                loginViewController.viewModel = viewModel?.loginViewModel
                
            case "SPLASH_TO_HEROES":
                guard let heroesViewController = segue.destination as? HeroesViewController else { return }
                heroesViewController.viewModel = viewModel?.heroesViewModel
            default:
                break
        }
    }
    
// MARK: - Private functions -
    private func setObservers(){
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.splashActivity.isHidden = !isLoading
                    case .navigateToLogin:
                        self?.performSegue(withIdentifier: "SPLASH_TO_LOGIN",
                                           sender: nil)
                    case .navigateToHeroes:
                        self?.performSegue(withIdentifier: "SPLASH_TO_HEROES",
                                           sender: nil)
                }
            }
        }
    }
}

