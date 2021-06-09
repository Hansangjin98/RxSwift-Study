//
//  ViewController.swift
//  MVVMPractice
//
//  Created by 한상진 on 2021/05/27.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var pw: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let disposeBag = DisposeBag()
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelSet()
        setupControl()
        
    }
    private func labelSet() {
        self.subTitleLabel.numberOfLines = 0
        self.subTitleLabel.text = "사용하던 카카오계정이 있다면\n이메일 또는 전화번호로 로그인해주세요."
    }
    
    func setupControl() {
        id.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        
        pw.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        
        viewModel.isValid.bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .map { $0 ? 1 : 0.3 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { [self] _ in loginAction()}).disposed(by: disposeBag)
    }
    
    
    func loginAction()
    {
        LoginService.shared.login(email: self.id.text!, password: self.pw.text!) { result in
            switch result
            {
            case .success(let message):
                if let message = message as? String{
                    self.makeAlert(title: "알림", message: message, okAction: {_ in
                        let nextSB = UIStoryboard(name: "Home", bundle: nil)
                        let nextVC = nextSB.instantiateViewController(identifier: "Home") as! HomeTableViewController
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: true, completion: nil)
                        
                    }, completion: nil)
                }
            case .requestErr(let message):
                if let message = message as? String{
                    self.makeAlert(title: "알림",
                                   message: message)
                }
            default :
                print("ERROR")
            }
        }
    }
}

