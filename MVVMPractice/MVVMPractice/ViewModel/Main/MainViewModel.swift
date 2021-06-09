//
//  MainViewModel.swift
//  MVVMPractice
//
//  Created by 한상진 on 2021/06/04.
//

import Foundation
import RxSwift
import RxRelay

struct MainViewModel {
    let emailObserver = BehaviorRelay<String>(value: "")
    let passwordObserver = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailObserver, passwordObserver)
            .map { email, password in
                return !email.isEmpty && password.count > 0
            }
    }
}
