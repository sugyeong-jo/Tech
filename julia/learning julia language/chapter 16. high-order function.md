# Chapter 16. High-Order Function
Syntax
- foreach(f, xs)
- map(f, xs)
- filter(f, xs)
- reduce(f,xs)
- foldl(f, v0, xs)
- foldr(f, v0, xs)
---
## Functions as arguments

- "Functions"들은 Julia의 객체이다. 다른 객체와 마찬가지로 다른 함수에 인수로 전달할 수 있다. 
- **고차 함수 (Higer-order function)** : 함수를받는 함수

standard library의 ```foreach``` 함수를 함수 f로 구현해보자. 
- ```foreach```란 끝을 정해주는 반복문과는 달리 인자로 들어온 내부 인스턴스들을 거내서 알아서 순환해주는 반복문이다.


``` julia
function myforeach(f, xs)
    for x in xs
    f(x)
    end
end
```
- 위와 같이 function안에 function을 호출하는 구문을 만들었다. ```println```함수를 ```f```로 지정해주면, 들어오는 인자를 print하는 함수가 된다.

```julia
myforeach(println, ["a", "b", "c"])
```

- ```println(x^x)```을 ```f```함수로 지정해주고싶다면 다음과 같이 do로 *anonymous function*을 사용하면 된다. 

```julia
myforeach([1, 2, 3]) do x
    println(x^x)
end
```

고차함수들은 꽤 파워풀하다.
고차함수를 사용할때는 정확한 작업 수행이 덜 중요하고, 프로그램이 꽤 추상적일 때이다. *combinators*는 고도로 추상적 인 고차 함수 시스템의 예이다.

## Map, filter, and reduce

- 대표적인 고차함수로 ```map```과 ```filter```가 있다.
- array 계산에 적합하다.

다음과 같은 데이터베이스를 가정해보자.
>참고문헌은 julia version이 0.7이었고, 현재 version은 1.0이상이다. immuable 한수가 mutate struct로 수정된 듯

```julia
mutable struct School
    subject::Symbol
    nclasses::Int
    nstudents::Int # average no. of students per class    
end

dataset = [School(:math, 3, 30), School(:math, 5, 20), School(:science, 10, 5)]
```

*수학수업을 신청한 총 학생수는 몇 몇 인가?*

이 질문에 답하기 위해 다음과 같은 스텝이 필요하다.

- 수학을 가르치는 학교로만 데이터셋을 줄여야 한다. (```filter```)
- 각 학교의 학생들 숫자를 계산해야 한다. (```map```)
- 리스트의 모든 값을 더해서 하나의 값으로 줄여야 한다. (```reduce```)

```julia
function nmath(data)
    maths = filter(x -> x.subject === :math, data)
    students = map(x -> x.nclasses * x.nstudents, maths)
    reduce(+, students) #version 0.7이랑 다름!
end

nmath(dataset) #190
```
> ```foldl```이랑 ```foldr```은 reduce order 의 특정 강조 순서를 강제하는데 사용된다. (나는 잘 모르겠다..)













