# chapter 20. Metaprogramming

Syntax
- macro name(ex) ... end
- quote ... end
- :(...)
- $x
- Meta.quot(x)
- QuoteNode(x)
- esc(x)
---

## 메타 프로그래밍이란?
나는 처음 접하는 개념이라 여기저기에서 개념을 조금 긁어와봤다.
- 메타 프로그래밍이란 자기 자신 혹은 다른 컴퓨터 프로그램을 데이터로 취급하며 프로그램을 작성·수정하는 것을 말한다. 넓은 의미에서, 런타임에 수행해야 할 작업의 일부를 컴파일 타임 동안 수행하는 프로그램을 말하기도 한다.
> https://ko.wikipedia.org/wiki/%EB%A9%94%ED%83%80%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D

- 한 가지 재미있는 사실은어떠한 C++ 코드도 템플릿 메타 프로그래밍 코드로 변환할 수 있다는 점입니다(물론 엄청나게 코드가 길어지겠지만요). 게다가 템플릿 메타 프로그래밍으로 작성된 코드는 모두 컴파일 타임에 모든 연산이 끝나기 때문에 프로그램 실행 속도를 향상 시킬 수 있다는 장점이 있습니다 (당연히도 컴파일 시간은 엄청 늘어나게 됩니다).
>https://modoocode.com/221

아무튼 되게 사용하기 까다로운거 같긴 하다..

줄리아의 메타프로그래밍은 LISP와 비슷한 언어체계를 가진다고 한다.
>LISP: LISP은 LIST Programming의 약자로, 1958년 MIT에서 개발된 역사 깊은 함수형 언어이다. 모든 자료는 연결 리스트로 처리하며, 컴파일 개념 없이 인터프리터 상에서 동작한다.
>https://lynlab.co.kr/blog/6, https://m.blog.naver.com/PostView.nhn?blogId=1ilsang&logNo=220676115496&proxyReferer=https%3A%2F%2Fwww.google.com%2F

제대로만 쓴다면 간결하고 읽기 쉬운 코드가 된다고 한다.

- ```quote ... end```는 준따옴표 구문(?) (quasiquote syntax) 이다. ```quote ... end``` 값은 Abstract Syntax Tree를 표현한다.

- ```:(...)``` 구문은 ```quote ... end```와 비슷하지만 좀 더 가벼운가중치를 가진다. 

- quasiquoute안의 ```$``` 오퍼레이터는 AST에 특별하게, 그리고 보간하는 (interpolates) 구문이다.

- ```Meta.quot (x)```함수는 인수를 인용한다. 이건 ```$```와 함께 보간하는 용도로 사용된다.

---
## Example
### Reimplementing the @show macro
줄리아에서 ```@show``` 매크로는 디버깅에 유용하게 사용된다. 이 기능은 계산과정을 표현하고, 결과를 표현한다. 그리고 최종 결과값도 알려준다.

```julia
@show 1 + 1
```

```@show```는 우리 입맛에 맞게 만들기도 쉽다.

```julia
macro myshow(expression)
    quote
        value = $expression
        println($(Meta.quot(expression)), " = ", value)
        value
    end
end

x = @myshow 1+1
x
```

while 구문을 종종 쓰는데, 이것은 body 가 true가 될 때 까지 계속 실행한다. 만약에 until 루프를 원한다면, @until 매크로를 사용하면 된다.

```julia
global i = 0 ;

@until i == 10 begin
    println(i)
    global i += 1
end
```

>ERROR: UndefVarError: i not defined 에 대한 에러는 global을 지정 안해주어서 생기는 문제이다. 





