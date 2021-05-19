//
//  ViewController.swift
//  RxSingle
//
//  Created by 한상진 on 2021/05/13.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        useSingle()
    }
    
    enum DataError: Error {
        case cantParseJSON
    }

    
    // MARK: - JSON 데이터 불러오기
    
//    func getRepo(_ repo: String) -> Single<[String: Any]> {
//        return Single<[String: Any]>.create { single in
//            let task = URLSession.shared.dataTask(
//                with: URL(string: "https://api.github.com/repos/\(repo)")!
//            ){data,_,error in
//                if let error = error {
//                    single(.failure(error))
//                    return
//                }
//                guard let data = data,
//                      let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
//                      let result = json as? [String: Any] else {
//                    single(.failure(DataError.cantParseJSON))
//                    return
//                }
//                single(.success(result))
//            }
//            task.resume()
//
//            return Disposables.create { task.cancel()}
//        }
//    }
//
//    func useSingle() {
//        getRepo("ezidayzi/RxSwift_R4")
//            .subscribe(onSuccess: { json in
//                print("JSON: ", json)
//            },
//            onFailure: { error in
//                print("Error: ", error)
//            })
//
//    }
    
    // MARK: - URL 불러오기
    
    func getRequest(url: String?) -> Single<Bool> {
        return Single.create { single in
            guard let url = url else {
                single(.failure(NSError.init(domain: "error", code: -1, userInfo: nil)))
                return Disposables.create()
            }

            if url == "https://www.google.com" {
                single(.success(true))
            } else {
                single(.success(false))
            }

            return Disposables.create()
        }
    }

    func useSingle() {
        getRequest(url: "https://www.github.com")
            .subscribe(onSuccess: { success in
                print("url 판별: ", success)
            }, onFailure: { error in
                print("Error: ", error)
            })
            .dispose()
    }
}
