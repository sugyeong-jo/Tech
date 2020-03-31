# Jason

줄리아에서는 jason파일을 dictionary로 쓰기도 한다.
JSON 객체에서 키-값 쌍의 순서에 의존하지 않는 것이 가장 좋다.
## Example
```julia
using Pkg
#Pkg.add("JSON")
Pkg.test("JSON")
using JSON
JSON.parse("""{
    "this": ["is", "json"],
    "numbers": [85, 16, 12.0],
    "and": [true, false, null]
    }""")

```
- JSON 유형은 Julia의 합리적인 유형에 매핑된다. Object는 Dict가되고, array는 Vector가되고, 숫자는 Int64 또는 Float64가되고, boolean은 Bool이되고, null은 none :: Void가 된다.
- JSON은 형식이 지정되지 않은 컨테이너 형식이다. 따라서 반환 된 Julia 벡터는 Vector {Any} 유형이고 반환 된 dictionary는 Dict {String, Any} 유형이다.
- JSON 표준은 정수와 10 진수를 구별하지 않지만 JSON.jl은 구별한다. 소수점이없는 숫자 나 과학적 표기법은 Int64로 구문 분석되고 소수점이있는 숫자는 Float64로 구문 분석된다. 이것은 다른 많은 언어에서 JSON 파서의 동작과 밀접하게 일치한다.

### Serializing JSON
다음과 같이 serialization 사전을 만들 수 있음

```julia
JSON.json(Dict(:a => :b, :c => [1, 2, 3.0], :d => nothing))
"{\"c\":[1.0,2.0,3.0],\"a\":\"b\",\"d\":null}"
println(ans)
```

julia 타입으로는 다음과같이 만들 수 있음
```julia
mutable struct Point3D
    x::Float64
    y::Float64
    z::Float64
end

JSON.print(Point3D(1.0, 2.0, 3.0), 4)
```
