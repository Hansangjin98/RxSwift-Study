# 📕Traits란?

RxSwift는 Observable을 사용할 때 명확한 이벤트 발생 규칙을 가질 수 있도록 Traits를 지원합니다.

Traits는 RxSwift를 사용할 때 코드를 명확하고 직관성 있게 가지고자 할 때 선택적으로 사용할 수 있으며, 코드의 의도를 확실히 보여줄 수 있다는 장점이 있습니다.

RxSwift의 Traits는 다음과 같은 3가지 종류를 갖고 있습니다.

1. Single : 항상 단일 요소 또는 에러를 방출하도록 보장하는 시퀀스
2. Completable : 이벤트에 대해 완료 또는 에러를 방출하고, 요소는 아무것도 방출하지 않는 것을 보장하는 시퀀스
3. Maybe : Single과 Completable의 중간 특성을 가지는 시퀀스

<br>

## 📌Single

Single은 Observable이 변형된 것으로, **항상 단일 요소** 또는 **오류**만을 방출하기 때문에 주로 HTTP 요청을 처리하는데 사용됩니다.

Single은 Observable과 다르게 onSuccess, onFailure만 처리하면 됩니다.<br>또한 Single은 기본적으로 Observable이기 때문에, 기타 Observable 연산자들을 사용할 수 있습니다.

**코드 예시**

```
func getRequest(url: String?) -> Single<Bool> {
    return Single<Bool>.create { single in
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

getRequest(url: "https://www.github.com")
    .subscribe(onSuccess: { success in
        print("url 판별: ", success)
    }, onFailure: { error in
        print("Error: ", error)
    })
    .dispose()



**출력 결과**
url 판별: false
```

<br>

## 📌Completable

Completable은 completed, error 두 가지 이벤트를 방출할 수 있으며, 아무 요소도 방출하지 않기 때문에 단순 완료 여부만 알고 싶을 때 사용합니다. (완료에 따른 요소에 대해 신경쓰지 않아도 되는 경우)

**코드 예시**

```
func completable() -> Completable {
    return Completable.create { completable in 
    // Store some data locally
    
        guard success else { 
            completable(.error(CacheError.failedCaching)) 
            return Disposables.create {} 
            } 
        completable(.completed)     
        return Disposables.create {} 
    } 
} 

completable().subscribe(
    onCompleted: { print("Completed with no error") 
    }, 
    
    onError: { error in print("Completed with an error: \(error.localizedDescription)") 
    } 
).disposed(by: disposeBag)

//사용법
getRepo("ReactiveX/RxSwift")
    .subscribe { event in
        switch event {
            case .success(let json):
                print("JSON: ", json)
            case .error(let error):
                print("Error: ", error)
        }
    }
    .disposed(by: disposeBag)
```

## 📌Maybe

Maybe는 Success, completed, error로 3가지 이벤트를 방출할 수 있습니다.<br>또한 Maybe는 Single과 Completable 사이에 있는 Observable의 변형으로, 단일 요소를 방출하거나 요소를 방출하지 않고 완료할 수 있습니다.

**코드 예시**
```
func maybe() -> Maybe<String> {
    return Maybe<String>.create { maybe in 
        maybe(.success("RxSwift")) 
        // or
        maybe(.completed) 
        // or 
        maybe(.error(error)) 
        
        return Disposables.create {} 
        } 
} 

maybe().subscribe( 
    onSuccess: { 
        element in print("Completed with element \(element)") 
    }, 
    onError: { error in print("Completed with an error \(error.localizedDescription)") 
    }, 
    onCompleted: { print("Completed with no element") 
} ).disposed(by: disposeBag
```