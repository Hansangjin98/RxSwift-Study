# 📕RxSwift란?

RxSwift는 Reactive extension + Swift의 합성어로, 비동기 프로그래밍을 관찰 가능한 흐름으로 지원해주는 API입니다.

비동기는 RxSwift의 핵심이라고도 할 수 있는데, '한 가지 일을 처리하는 동시에 다른 일도 함께 처리하는 것'을 의미합니다.

**📌iOS 에서 비동기 처리를 하는 경우**

>버튼을 눌렀을 때의 이벤트 반응<br>텍스트필드에 포커스가 잡힌 경우<br>인터넷에서 크기가 큰 이미지 파일을 받는 경우<br>디스크에 데이터를 저장하는 경우<br>오디오를 실행하는 경우<br>기타 등등

<br>

비동기 처리는 RxSwift를 사용하지 않아도 PromiseKit, DispatchQueue, Bolts 등의 방법으로도 할 수 있습니다.

또한 UIKit를 이용하며 자연스럽게 비동기 처리를 경험하기도 합니다.

**📌UIKit에서 비동기 처리를 경험하는 경우**

>NotificationCenter : 백그라운드 진입 후 몇초 있다가 메시지 알림<br>Delegate pattern : tableView의 didSelectRowAt과 같은 메소드<br>Closure

<br>

# 📕RxSwift을 사용하는 이유

### 📌다수의 비동기 이벤트를 처리하는데 용이함

RxSwift를 사용하는 주된 이유입니다.

만약 일반적인 명령형 프로그래밍으로 다수의 비동기 이벤트들을 처리하려면 여러 콜백을 중첩시키거나 플래그 변수나 if문을 여러번 사용해야합니다.

하지만 RxSwift를 사용한다면 별도로 제공되는 라이브러리 함수를 사용하기 때문에, 콜백 중첩으로 표현하는 구문보다 훨씬 간결하게 처리할 수 있습니다.

더불어, 일관된 Rx 코드로 깔끔하고 간결한 코드 작성이 가능하여 다른 방식의 비동기 처리들보다 코드의 가독성이 좋습니다.

<br>

### 📌Side Effects를 통해 state 파악

Side Effect를 통해 코드의 현재 흐름을 확인하고, 메소드가 실행되기 전의 작업을 직접 지정해줄 수 있다는 장점이 있습니다.

<br>

### 📌MVVM 디자인 패턴과의 궁합

Microsoft의 MVVM 아키텍처는 데이터 바인딩을 제공하는 플랫폼에서 만들어진 이벤트 중심 프로그램을 위해 특별히 개발되었기 때문에, RxSwift와 함께 사용했을 때 아주 간편하게 MVVM 디자인 패턴을 구현할 수 있습니다.

또한 Rx로 설계가 된 아키텍처 영역(ReactorKit, RxFlow 등)과 서비스 영역(MoyaSugar, RxBus, RxStarscream 등)의 기능도 활용할 수 있습니다.

<br>

# 📕Observables

RxSwift에서는 Observables를 활용해 비동기 처리를 구현합니다.

하나 이상의 Observer가 실시간으로 이벤트에 반응하고, UI를 업데이트하거나, 들어오는 데이터를 처리하고 활용할 수 있게 합니다.

observer가 observable을 subscribe하는 형태입니다.

어떤 이벤트를 관찰하다 응답이 있을 시 반응을 해주는 구조인데, Observable이라는 레퍼런스 타입을 이용해서 값을 관찰합니다.

<br>

### 📌Observable event의 종류

>next : 최신/다음 데이터를 방출하는 이벤트<br>completed : 성공적으로 next 이벤트가 완료되었을 때, complete 이벤트가 방출되며 종료<br>error : Observable이 값을 방출하다 에러가 발생하면 error 이벤트를 방출하고 종료

<br>

# 📕Disposable

Disposable은 이벤트 취소를 ‘처리’한다는 개념입니다.

간단하게 말해서 Disposable은 작업 취소에 쓰이는 프로토콜이라고 할 수 있습니다.

Observable의 subscribe을 사용하면 모두 Disposable을 return하는데, 이를 이용하여 작업이 끝난 후 처분을 할 수 있으며, 작업 도중에 하던 작업을 취소하는 것도 가능합니다.

한편 돌아가고 있는 여러 개의 비동기 작업을 한꺼번에 취소하고 싶을 땐 DisposeBag을 이용할 수 있습니다.

DisposeBag은 각각의 Disposable을 모아 담는다는 개념입니다.

<br>

### 📌Disposable의 주요 event

>Disposables.create : disposable을 생성합니다. 클로저를 활용해 dispose 시점에서 처리할 동작을 추가할 수 있습니다.<br>BooleanDisposable : dispose 상태 여부를 확인할 수 있습니다.<br>CompositeDisposable : disposable을 묶어서 처리할 수 있습니다.key값을 이용해 개별적으로도 처리할 수 있습니다.

<br>

<br>

# 🔥실습🔥

<img src="https://user-images.githubusercontent.com/70688424/116653241-bd05fa80-a9c1-11eb-8b3b-a052f78a6e29.png" width="80%">

RxSwift는 외부 라이브러리이기 때문에, Xcode 프로젝트 폴더에서 CocoaPods로 install 해줘야하며, RxSwift가 사용되는 Swift파일에서도 import 해줘야합니다.

<pre>
<code>
pod 'RxSwift', '6.1.0'
</code>
</pre>

<br>

이번 1주차 스터디 세미나에서는 실습으로 Observable과 Disposable을 적용해보는 시간을 가졌습니다.

<img src="https://user-images.githubusercontent.com/70688424/116653666-a3b17e00-a9c2-11eb-93b1-f8f557c0d8c3.gif" width="50%">

취소하기 버튼을 클릭하면 작동하던 타이머가 멈추는 형식입니다.

<pre>
<code>
    // MARK: - Observable 생성 함수
    func rxCountNumber() -> Observable<Bool> {
        return Observable.create { [weak self] o in
            self?.countNumber{ (result) in
                // 데이터가 발생했을 때
                o.onNext(result ?? false)
                // 모든 이벤트가 완료되었을 때
                o.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - 옵저버 생성 함수(Observable subscribe)
    func isCompletedCount() {
    disposable = rxCountNumber()
        .observe(on: MainScheduler.instance)
        .subscribe({[weak self] _ in
            self?.completedLabel.text = "Completed!"
        })
    }
</code>
</pre>

rxCountNumber라는 Observable을 생성하는 함수를 만들어 보았고, 생성된 Observable을 subscribe 하는 옵저버도 생성해봤습니다.

Observable을 subscribe하는 과정에서 Disposables를 return 받기 위해 disposable이라는 변수에 담았습니다.

<pre>
<code>
    @IBAction func stopBtn(_ sender: Any) {
        disposable?.dispose()
        timer?.invalidate()
        completedLabel.text = "취소되었습니다"
    }
</code>
</pre>

취소하기 버튼을 클릭하면, 아까 생성한 disposable 변수가 dispose되어 이벤트 취소를 처리합니다.