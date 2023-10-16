//
//  LoginViewController.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 11/10/23.
//

import UIKit

protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set}
    func onloginPressed(email: String?, password: String?)
}

// Mark: - View State -
enum LoginViewState {
    case loading (_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}

class LoginViewController: UIViewController {
    // MARK: - IBOutlet -
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailFieldError: UILabel!
    @IBOutlet weak var passwordFieldError: UILabel!
    @IBOutlet weak var activityView: UIView!
    
    // MARK: - IBAction -
    @IBAction func onLoginPressed(){
        // Obtener el mail y password introducidos por el usuario
        // y enviarlos al servicion del API del Login
        viewModel?.onloginPressed(
            email: emailField.text,
            password: passwordField.text)
    }
    
    // MARK - Public properties -
    var viewModel: LoginViewControllerDelegate?
    
    private enum FieldType: Int {
        case email = 0
        case password
    }
    
    // Mark: - lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
    }
    
    // MARK: - Private Functions -
    private func initViews() {
        emailField.delegate = self
        emailField.tag = FieldType.email.rawValue
        passwordField.delegate = self
        passwordField.tag = FieldType.password.rawValue
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)
            )
        )
    }
    
    @objc func dismissKeyboard(){
        // Ocultar el teclado al pulsar en cualquier punto de la vista
        view.endEditing(true)
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.activityView.isHidden = !isLoading
                        
                    case .showErrorEmail(let error):
                        self?.emailFieldError.text = error
                        //echar un ojo a esta lógica
                        self?.emailFieldError.isHidden = (error == nil || error?.isEmpty == true)
                        
                    case .showErrorPassword(let error):
                        self?.passwordFieldError.text = error
                        self?.passwordFieldError.isHidden = (error == nil || error?.isEmpty == true)
                        
                    case .navigateToNext:
                        self?.activityView.isHidden = true
                        // TODO: Navegar a la vista
                        break
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) {
            case .email:
                emailFieldError.isHidden = true
                
            case .password:
                passwordFieldError.isHidden = true
                
            default: break
        }
        /*
         Forma anterior de hacerlo
         
         if emailField == textField {
         emailFieldError.isHidden = true
         } else if passwordField == textField {
         passwordFieldError.isHidden = true
         }
         */
    }
}
