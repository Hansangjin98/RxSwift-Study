# 📕Operators란?

- RxSwift에서 Operator(연산자)는 Observable을 다루는 메소드들을 통칭하는 용어입니다.
- 쉽게 Observable을 생성하고, 변형하고, 합치는 등 다양한 연산을 할 수 있도록 도와주는 역할을 합니다.
- [Operators의 종류](http://reactivex.io/documentation/ko/operators.html)는 상당히 많아서, 주로 많이 사용되는 4가지를 뽑아보면 다음과 같습니다.

<br>

# 📕주요 Operators

### 📌just

- 하나의 Element를 Observable로 만드는 역할을 한다.

**코드 예시**

<pre>
<code>
        func exJust1() {
        Observable.just("Hello World")
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
            }
</code>
</pre>

**출력 결과**

<pre>
<code>
Hello World
</code>
</pre>

<br>

### 📌from

- array, dictionary, set 등의 배열 형태를 Observable Sequence로 만드는 역할을 한다.

**코드 예시**

<pre>
<code>
        func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
            }
</code>
</pre>

**출력 결과**

<pre>
<code>
RxSwift
In
4
Hours
</code>
</pre>

<br>

### 📌map

- 위에서 내려온 데이터를 가공하는 역할을 한다.

**코드 예시**

<pre>
<code>
        func exMap1() {
            print("\nexMap1()")
            Observable.just("Hello")
                .map { str in "\(str) RxSwift" }
                .subscribe(onNext: { str in
                    print(str)
                })
                .disposed(by: disposeBag)
        }
</code>
</pre>

**출력 결과**

<pre>
<code>
exMap1()
Hello RxSwift
</code>
</pre>

<br>

### 📌filter

- 위에서 내려온 데이터를 선별하는 역할을 한다.

**코드 예시**

<pre>
<code>
        func exFilter() {
            print("\nexFilter()")
            Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
                .filter { $0 % 2 == 0 }
                .subscribe(onNext: { n in
                    print(n)
                })
                .disposed(by: disposeBag)
        }
</code>
</pre>

**출력 결과**

<pre>
<code>
exFilter()
2
4
6
8
10
</code>
</pre>

Operators는 개념 자체는 어려운게 없지만, 상황에 따라 어떤 Operator를 사용하는 것이 적절한지 판단하는 것과,<br>
Operator 종류 자체가 많기 때문에 자주 사용되는 Operator를 알아두는 것이 중요한 것 같습니다.