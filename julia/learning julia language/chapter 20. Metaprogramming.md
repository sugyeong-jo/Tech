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

### QuoteNode, Meta.quot, and Expr(:quote)

줄리아에는 quote를 하는 세가지 방법이 있다.
```julia
QuoteNode(:x)
Meta.quot(:x)
Expr(:quote, :x)
```

*"quoting"의 의미와 좋은점은 무엇일까?*
- quoting은 줄리아의 특별한 form으로서 해석할 수 있게 해주는 설명을 보호하게 한다. 
- 보통 expressions를 다룰대 사용되며, 이것은 계산할 어떤 심볼을 포함해야 한다.
    - 예를 들면 macro는 심볼로 평가되는 expression을 반환해야 한다. 단순히 기호를 반환하는 것은 작동하지 않는다.


```julia
macro mysym(); :x; end

@mysym
#result: ERROR: UndefVarError: x not defined

macroexpand(:(@mysym))
```
밑에 경우는 또 결과가 잘 나오는데, 그 이유는 ```Meta.quot(:x)```가 함수의 symbol을 보여준다.

```julia
macro mysym2(); Meta.quot(:x); end

@mysym2
```

## The difference between Meta.quot and QuoteNode, explained

```Meta.quot(:x)```와 ```QuoteNode``` 함수는 거의 같고, 때때로 QuoteNode가 좀 더 안정적이라 한다. 

- interpolation 기능을 지원받고자 한다면 ```Meta.quot;```
- interpolation을 사용 못한다면 ```QuotNode```

interpolation은 ```$```으로 표현되는 중요한 기능이다. 이런 표현들은 escaping을 위한 것이다. 
예를 들면, 다음과 같다. 
```julia
ex = :( x = 1; :($x + $x) )
quote
    x = 1
    $(Expr(:quote, :($(Expr(:$, :x)) + $(Expr(:$, :x)))))
end

eval(ex)
```
이를 표현을 자세히 보면, x에 1을 대입하여 ```_+_```로 묶이게 된다. 그러면 표현은 ```1+1```이 된다. 이건 아직 평가된건 아니다. 따라서 ```2```와는 차별된다.

이제, 매크로를 이러한 종류의 표현으로 나타내보자!
우리의 매크로는 ex의 1을 대체하는 구문을 취할 것이다. 이 구문은 어떤 표현이 될 수 있다. 다음은 우리가 완벽히 원하는 것은 아닌데, 한 번 보자. 
```julia
macro makeex(arg)
    quote
        :( x = $(esc($arg)); :($x + $x) )
    end
end

@makeex 1
#result
quote
    x = $(Expr(:escape, 1))
    $(Expr(:quote, :($(Expr(:$, :x)) + $(Expr(:$, :x)))))
end

@makeex 1 + 1
#result
quote
    x = $(Expr(:escape, 2))
    $(Expr(:quote, :($(Expr(:$, :x)) + $(Expr(:$, :x)))))
end

```

두번째 케이스는 ```1+1```을 value로 계산을 못하므로 틀렸다. 이 부분을 ```Meta.quot``` 구문으로 바꿔줌으로써 고쳤다.

```julia
macro makeex2(arg)
    quote
        :( x = $$(Meta.quot(arg)); :($x + $x) )
    end
end

@makeex2 1 + 1
```
Macro hygiene은 quote의 컨텐츠들을 적용시키지 않아 escaping이 필요하지 않다. 
앞서 언급한 ```Meta.quot```는 interpolation을 허용한다. 그래서 다음과 같이 할 수 있다.
```julia
@makeex2 1 + $(sin(1))

let q = 0.5
    @makeex2 1 + $q
end
```
첫번째 예제에 따르면 sin(1)을 문장으로가 아닌 표현으로 허용하는걸 볼 수 있다. 두번째 예제에서 interpolation이 매크로 자체 범위가 아니라 매크로 호출 범위에서 수행됨을 보여준다.
매크로가 실제로 코드를 평가하지 않았기 때문에, 코드를 생성하기 만 하면된다. 코드의 evaluation은 (표현식으로 전환) the expression the macro generate들이 실제로 동작할때 이다. 


*QuoteNode를 대신 사용하한다면?*

짐작할 수 있듯이 QuoteNode는 interpolation (보간) 이 전혀 발생하지 않기 때문에 작동하지 않는다.

```julia
macro makeex3(arg)
    quote
        :( x = $$(QuoteNode(arg)); :($x + $x) )
    end
end
@makeex3 1 + $(sin(1))

let q = 0.5
    @makeex3 1 + $q
end

eval(@makeex3 $(sin(1)))
```
위 예제들로부터 ```Meta.quot```가 더 유연하게 적용된다는 걸 알 수 있다.

*```QuotNode```는 언제 사용하는 걸까?*

```$```가 문자 그대로 표현식에 사용되기 원할 때 사용한다. 이런경우는 언제일까? @makeex에 추가된 구문들이 왼쪽과 오른쪽에 + 사인으로 결합할 수 있는 구문을 만들어보자. 

```julia
macro makeex4(expr, left, right)
    quote
        quote
            $$(Meta.quot(expr))
            :($$$(Meta.quot(left)) + $$$(Meta.quot(right)))
        end
    end
end
@makeex4 x=1 x x
eval(ans)
```
@makeex4의 한계는 interpolate를 취하기 때문에 왼쪽이나 오른쪽 표현을 바로 표현할 수 없다는 것이다. 다른말로는 표현들이 보간을 평가해서 취한다는 것인데, 우리는 이런 것들로부터 피하고 싶다. (그러므로 많은 레벨의 quoting과 평가가 있고, 우리는 이를 명확히 해야한다. 우리의 macro generate 코드는 다른 표현을 다루기 위해 표현 구조를 또! 만듭니다. 휴... )

```julia
@makeex4 x=1 x/2 x
eval(ans)
```

보간이 발생하는 시간과 그렇지 않은 시간을 사용자가 지정할 수 있도록해야하는데, 이론적으로 이것은 쉬운 수정이다. 응용 프로그램에서 $ 기호 중 하나를 제거하고 사용자가 스스로 있게 하는 것이다. 이것이 의미하는 것은 사용자가 입력 한 quoted version의 표현식을 보간한다는 것이다. (이미 한 번 인용하고 보간했다). 이로 인해 다음과 같은 코드가 생성되는데, 이는 여러 개의 중첩 된 quoting 및 quoting 해제 수준으로 인해 처음에는 약간 혼란 스러울 수 있다. 각 escape의 목적을 읽고 이해해야 한다.

```julia
macro makeex5(expr, left, right)
    quote
        quote
            $$(Meta.quot(expr))
            :($$(Meta.quot($(Meta.quot(left)))) + $$(Meta.quot($(Meta.quot(right)))))
        end
    end
end

@makeex5 x=1 1/2 1/4
eval(ans)
#result: :(1 / 2 + 1 / 4)
@makeex5 y=1 $y $y
#result: ERROR: UndefVarError: y not defined
```
대충 돌아가기는 하는데 약간 틀렸다. 매크로의 generated code는 호출범위에서 y의 복사본을 보간으로 사용하려 한다. 하지만 실제로는 복사본 사용을 못했다. 우리의 에러는 보간이 두번째와 세번째 구문에서 허용되게 한다는 것이다. 따라서 ```QuoteNode```를 사용해야 한다. 

```julia
macro makeex6(expr, left, right)
    quote
        quote
            $$(Meta.quot(expr))
            :($$(Meta.quot($(QuoteNode(left)))) + $$(Meta.quot($(QuoteNode(right)))))
        end
    end
end

@makeex6 y=1 1/2 1/4
eval(ans)
@makeex6 y=1 $y $y
eval(ans)
@makeex6 y=1 1+$y $y
eval(ans)
@makeex6 y=1 $y/2 $y
eval(ans)
```
```QuoteNode```는 추가 보호의 효과만 있으므로 보간을 원하지 않는 한 QuoteNode를 사용하는 것은 결코 해롭지 않다. 그러나 차이점을 이해하면 Meta.quot가 더 나은 선택이 될 수있는 때와 이유를 이해할 수 있다.

## What about Expr(:quote)?

```Expr(:quote)```은 ```Meta.quot(x)```와 같다. 그러나 후자가 좀 더 관용적이고 선호된다. 큰 사이즈의 메타프로그래밍에서 ```using Base.Meta```라인을 좀 더 사용하며, 이는 ```Meta.quot```를 간단하게 ```quot```로 사용할 수 있게 한다.

---

## Interpolation and assert macro
```@assert```가 뭔지 제일 궁금했다!!!!
일단 정의는 다음과 같다.
```julia
macro assert(ex)
    return :( $ex ? nothing : throw(AssertionError($(string(ex)))) )
end

@assert 1 == 1.0
@assert 1 == 0

#원래는 다음과 같은 정의라고 한다.
macro assert(ex, msgs...)
    msg_body = isempty(msgs) ? ex : msgs[1]
    msg = string(msg_body)
    return :($ex ? nothing : throw(AssertionError($msg)))
end

#확장된 assert 예시는 다음과 같다.
@macroexpand @assert a == b
@macroexpand @assert a==b "a should equal b!"
@assert a==b "a ($a) should equal b ($b)!"


```
@assert는 논리 오류를 해결하는 또다른 방법이다. assert 문은 예외를 일으킨다는 점에서 raise 문과 비슷한 명령이다. 하지만 언제·어떤 예외를 발생시키는지가 raise 문과 다르다. assert는 상태 검증용도이고, 검증식이 거짓일 때만 예외를 일으킨다. raise는 예외의 발생에 사용되며, 항상 예외를 일으킨다.
>정확한 오류 정보를 전달하기 위해서는 assert 문보다 raise 문을 이용하는 것이 좋다. 







