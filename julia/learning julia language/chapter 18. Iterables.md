# 18. Iterables

Syntax
- start(itr)
- next(itr, s)
- done(itr, s)
- take(itr, n)
- drop(itr, n)
- cycle(itr)
- Base.product(xs, ys)
---

iterable한 객체라는건 단순히 iterator로 변환 가능한 객체를 의미한다.
그리고 iterator로 변환이 가능하다는 말은, 값을 한 개씩 순차적으로 접근이 가능하도록 만들 수 있다는 뜻이다. (list, dictionary 등)
>https://itholic.github.io/python-iterable-iterator/



## Examples
### New iterable type
줄리아의 ```for``` syntax는 다음과 같다.
```julia
for i = I # or "for i in I"
    # body
end
```
```while```은 다음과 같으며, ```start```, ```next```를 정의해 주어야 하고 ```done```의 방법과 타입을 정의 해 주어야 한다.
```julia
state = start(I)
while !done(I, state)
    (i, state) = next(I, state)
    # body
end
```
- type은 Foo이고, array를 포함하는 코드는 다음과 같다.
> ~~type~~ 함수는 더이상 사용되지 않고 struct로 정의함

```julia
struct Foo
    bar::Array{Int,1}
end
I = Foo([1,2,3])
I.bar

for i in I.bar
    println(i)
end
```

### Combining Lazy Iterables
Lazy Iterables을 함께 사용하면 좀 더 강력하다고 한다.

## Lazily slice an iterable

Array는 슬라이스될 수 있다. 하지만 이 슬라이스 notation은 모든 iterable에 적용되지 않는다. 예를들면 generator 표현은 슬라이스 못한다.
```julia
(i^2 for i in 1:10)[3:5]

#result
ERROR: MethodError: no method matching getindex(::Base.Generator{UnitRange{Int64},##1#2},
::UnitRange{Int64})
```
string도 unicode error가 발생한다.

따라서 ```lazysub (itr, range::UnitRange)``` 함수를 정의해 주는데, 이는 임의의 iterable을 ```take```and ```drop```을 사용해서 슬라이싱할 수 있게 한다.
 

```julia
lazysub(itr, r::UnitRange) = take(drop(itr, first(r) - 1), last(r) - first(r) + 1)
```
이 코드는 돌아가는데, 이유는 UnitRange 값이 a:b이기 때문이다. 자세하게는 다음 step을 따라간다.
- a-1요소를 drop한다.
- 그리고 a번째 요소를 take한다. 이렇게 a+1번째도, 그 뒤도 이 프로세스를 따르게 한다. a+(b-a)=b가 될 때 까지.

그러면 결론적으로 b-a 요소를 취하게 되게된다.

```julia
import Base.Iterators: take, drop, cycle

lazysub(itr, r::UnitRange) = take(.drop(itr, first(r) - 1), last(r) - first(r) + 1)

collect(lazysub("abcde", 2:3))
```
>Julia 1.0에서는 Base.Iterators에 함수들이 들어있음! 

## Lazily shift an iterable circularly
Array에 적용되는 ```circshift```오퍼레이터는 array를 마치 원처럼 shift하고 그걸 다시 선형형태로 만든다. 
```julia
circshift(1:10, 3)
```
이걸 lazily, iterable하게 만든다면 ```cycle```, ```drop```, ```take```를 사용하게 된다.

```julia
import Base.Iterators: take, drop, cycle

lazycircshift(itr, n) = take(drop(cycle(itr), length(itr) - n), length(itr))

String(collect(lazycircshift("Hello, World!", 3)))
```
많은 경우에 circshift가 작동하시 않아 lazy한 함수를 만들어 주어야 한다!

## Making a multiplication table
lazy iterable 함수로 "multiplication table"을 만들어 보자.

- ```Base.product``` : Cartesian product를 해줌
- ```prod```: regular product (as in multiplication)을 해줌
- ```:``` : range를 만듦
- ```map```: 고차함수이며, 모아진 요소들 요소요소마다 함수를 적용해줌

정답은 다음 코드이다.
```julia
map(prod, Base.product(1:10, 1:10))
```

### Lazily-Evaluated Lists

```julia
import Base: getindex
struct Lazy
    thunk
    value
    Lazy(thunk) = new(thunk)    
end 
evaluate!(lazy::Lazy) = (lazy.value = lazy.thunk(); lazy.value)
getindex(lazy::Lazy) = isdefined(lazy, :value) ? lazy.value : evaluate!(lazy)

import Base: first, tail, start, next, done, IteratorSize, HasLength, SizeUnknown
abstract type List end
mutable struct Cons <: List
    head
    tail::Lazy
end 
mutable struct Nil <: List end

macro cons(x, y)
    quote
        Cons($(esc(x)), Lazy(() -> $(esc(y))))
    end
end

first(xs::Cons) = xs.head
tail(xs::Cons) = xs.tail[]
start(xs::Cons) = xs
next(::Cons, xs) = first(xs), tail(xs)
done(::List, ::Cons) = false
done(::List, ::Nil) = true
IteratorSize(::Nil) = HasLength()
IteratorSize(::Cons) = SizeUnknown()

#result
xs = @cons(1, ys)
ys = @cons(2, xs)
```

하.. 최신버전으로 다 바꿔서 코드를 다시 짰는데...

Lazy.jl이라는 패키지가 있단다... ㅂㄷㅂㄷ 이걸 쓰자!

