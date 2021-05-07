# 📕Subject란?

Subject는 Observable, Observer의 역할을 모두 할 수 있습니다.

이전에 배운 Observable은 unicast방식이지만, Subject는 multicast방식으로, 여러개의 observer를 subscribe 할 수 있습니다.

**📌Subject와 Observable의 차이**

|Observable|Subject|
|:------:|:------:|
| 단지 함수이며 state가 없음 | state가 있으며, data를 메모리에 저장함 |
| 각각의 옵저버에 대해 코드가 실행| 같은 코드 실행, 모든 옵저버에 대해 오직 한번만 |
| Data Producer | Date Producer and Consumer |
| <용도><br>하나의 Observer에 대한 간단한 Observable이 필요할 때 | <용도><br>1. 자주 데이터를 저장하고 수정할때<br>2. Observable과 Observer 사이의 Proxy 역할 |

<br>

# 📕Subject의 종류

### 📌PublishSubject

- 구독한 뒤에 Observable이 보낸 이벤트를 전달받는다.
- Element 없이 빈 상태로 생성되며 subscribe한 시점 이후에 발생되는 이벤트만 전달받는다.

**코드 예시**

<pre>
<code>
        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()
        
        subject.onNext("Hi")
        
        let o1 = subject.subscribe {print (">>1",$0)}
        o1.disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")

        let o2 = subject.subscribe{print(">>2",$0)}
        o2.disposed(by: disposeBag)
        
        subject.onNext("c")
        subject.onNext("d")
</code>
</pre>

**출력 결과**

<pre>
<code>
>>1 next(a)
>>1 next(b)
>>1 next(c)
>>2 next(c)
>>1 next(d)
>>2 next(d)
</code>
</pre>

**설명**

PublishSubject는 구독한 시점 이후에 발생한 이벤트만 전달받는다.<br>따라서 o1이 구독한 시점 이전에 발생한 "Hi"는 전달되지 않으며,<br>o2가 구독한 시점 이전에 발생한 "Hi", "a", "b"는 전달되지 않는다.

<br>

### 📌BehaviorSubject

- 구독이 발생한 시점을 기준으로, 최근 발생한 이벤트 중 가장 최신의 이벤트를 전달 받는다.
- PublicSubject와 유사하지만, 반드시 초기값을 가지고 생성된다는 점이 BehaviorSubject의 특징이다.

**코드 예시**

<pre>
<code>
        let disposeBag = DisposeBag()
        
        let subject = BehaviorSubject<String>(value: "start") //observer
        
        subject.onNext("Hi")
        
        let o1 = subject.subscribe {print (">>1",$0)}
        o1.disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")

        let o2 = subject.subscribe{print(">>2",$0)}
        o2.disposed(by: disposeBag)
        
        subject.onNext("c")
        subject.onNext("d")
</code>
</pre>

**출력 결과**

<pre>
<code>
>>1 next(Hi)
>>1 next(a)
>>1 next(b)
>>2 next(b)
>>1 next(c)
>>2 next(c)
>>1 next(d)
>>2 next(d)
</code>
</pre>

**설명**

BehaviorSubject는 PublicSubject와 다르게 초기값을 가지고 생성된다.<br>따라서 o1이 구독한 시점 이전에 발생한 "Hi"를 전달받으며,<br>o2가 구독한 시점 이전에 발생한 "b"를 전달받는다.

<br>

### 📌ReplaySubject

- 구독 전에 발생한 이벤트를 버퍼에 넣고, 버퍼에 있던 이벤트를 구독 후에 전달한다.
- 미리 버퍼 사이즈를 정해줘야한다. 만약 버퍼 크기가 0이라면, PublishSubject와 같은 역할을 한다.
- 버퍼 사이즈만큼 최신 이벤트를 전달받는다.

**코드 예시**

<pre>
<code>
        let disposeBag = DisposeBag()
        let rsubject = ReplaySubject<String>.create(bufferSize : 3)

        rsubject.onNext("First")
        rsubject.onNext("Second")
        rsubject.onNext("Third")

        rsubject.subscribe { event in
            print(event)
        }
        rsubject.disposed(by: disposeBag)

        rsubject.onNext("Fourth")
        rsubject.onNext("Fifth")
</code>
</pre>

**출력 결과**

<pre>
<code>
"First"
"Second"
"Third"
"Fourth"
"Fifth"
</code>
</pre>

**설명**

ReplySubject는 구독 전에 발생한 이벤트를 버퍼 사이즈만큼 버퍼에 저장한다.<br>따라서 구독 이후 버퍼에 있던 3개의 이벤트(First, Second, Thrid)가 전달되고, disposed로 인해 버퍼에 저장된 것들이 처분되므로 이후 Fourth, Fifth가 전달된다.

<br>

<br>

# 📕Relay란?

Relay는 RxCocoa 클래스를 이용합니다.

RxSwift는 Cocoa, UIKit에 대해선 알지 못합니다. 따라서 이를 사용하기 위해선 RxCocoa를 이용합니다.

Relay의 종류에는 PublishRelay, BehaviorRelay, ReplayRelay가 있으며 Wrapper 클래스입니다.<br>(Wrapper 클래스란 data->객체로 포장해주는 클래스를 의미합니다.)

**📌Relay와 Subject의 차이**

- onNext 대신 accept를 사용한다.
- error, completed는 전달(발생)하지 않는다. 따라서 Dispose되기 전까지 계속 작동하기 때문에 UI Event에서 사용하기 적절하다.

|Relay|Subject|
|:------:|:------:|
| emit: accept 사용 | emit: onNext 사용 |
| Dispose 되어야 종료 | .completed 또는 .error 이벤트 발생 시 구독 종료 |
| next만 이벤트 전달 | next, error, completed 이벤트 전달 |

**코드 예시**

<pre>
<code>
        var BR = BehaviorRelay(value: " ")
        var observable : Observable<String>{
            return BR.asObservable()
        }

        BR.accept("event")
</code>
</pre>

<br>

<br>

# 🔥실습🔥

이번 2주차 스터디 세미나에서는 실습으로 Subject와 RxCocoa를 알아보는 시간을 가졌습니다.

<br>

**📌Subject와 Observable의 차이 실감하기**

<img src="https://user-images.githubusercontent.com/70688424/117419393-77b07280-af57-11eb-93dc-001bcfa8357c.gif" width="50%">

위의 Label 3개는 Observable을 통해 생성된 랜덤 숫자이고, 아래의 Label 3개는 Subject를 통해 생성된 랜덤 숫자입니다.

Observable은 각각의 옵저버에 대해 코드가 독립적으로 실행되는 반면에, Subject는 같은 코드가 모두 동일하게 실행되기 때문에 Obervable의 Label들은 각각 랜덤한 숫자를 나타냈고, Subject의 Label들은 모두 동일한 숫자를 나타냈습니다.

<pre>
<code>
     @IBAction func RoleBtnClicked(_ sender: Any) {
        let randomNumGenerator1 = Observable< Int >.create{ observer in
            observer.onNext(Int.random(in: 0 ..< 100))
            return Disposables.create()
        }
        
        randomNumGenerator1.subscribe(onNext: { (element) in
            self.ob1.text = "\(element)"
        }).dispose()
        randomNumGenerator1.subscribe(onNext: { (element) in
            self.ob2.text = "\(element)"
        })
        randomNumGenerator1.subscribe(onNext: { (element) in
            self.ob3.text = "\(element)"
        })
        
 
        let randomNumGenerator2 = BehaviorSubject(value: 0)
        randomNumGenerator2.onNext(Int.random(in: 0..< 100))
        
        randomNumGenerator2.subscribe(onNext: { (element) in
            self.sub1.text = "\(element)"
        })
        randomNumGenerator2.subscribe(onNext: { (element) in
            self.sub2.text = "\(element)"
        })
        randomNumGenerator2.subscribe(onNext: { (element) in
            self.sub3.text = "\(element)"
        })

    }
</code>
</pre>

<br>

**📌RxCocoa 실감하기**

<img src="https://user-images.githubusercontent.com/70688424/117419387-767f4580-af57-11eb-8a04-dfddfe86dbc3.gif" width="50%">

switch의 On/Off 상태에 따라 Label을 변경시켰습니다.

RxCocoa는 RxSwift와 다르게 UIKit와 연결할 수 있기 때문에, UIKit의 switch의 상태에 따라 이벤트를 발생시킬 수 있습니다.


<pre>
<code>
    var BR = BehaviorRelay(value: " ")
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var rxSwitch: UISwitch!

    rxSwitch.rx.isOn.subscribe { (enable) in
        self.switchLabel.text = enable.element! ? "On" : "Off"
        self.BR.accept(self.switchLabel.text ?? " ")
    }.disposed(by: disposebag)
</code>
</pre>
