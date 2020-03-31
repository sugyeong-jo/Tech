# Chapter 17. input

Syntax
- readline()
- readlines()
- readstring(STDIN)
- chomp(str)
- open(f, file)
- eachline(io)
- readstring(file)
- read(file)
- readcsv(file)
- readdlm(file)

---

## Reading a String from Standard Input

- 줄리아의 입력은 STDIN 스트림으로 표준입력 (standard input)을 사용한다.

> 스트림 (stream): 실제의 입력이나 출력이 표현된 데이터의 이상화된 흐름을 의미한다. 즉, 스트림은 운영체제에 의해 생성되는 가상의 연결 고리를 의미.

> STDIN: 표준입력스트림

- 이는 대화식 command-line program에 사용자가 입력하거나 redirected된 파일로부터 혹은 pipeline으로 부터 입력을 받을 수 있다. 

```readline``` 함수는 줄 바꾸기가 발생하거나 STDIN 스트림이 파일 끝 상태에 들어갈 때까지 STDIN에서 데이터를 읽는다. \ n 문자로 줄바꿈 함

다음과 같이 인풋을 받을 수 있다.
```julia
function askname()
    print("Enter your name: ")
    readline()
end

askname()
```

```chomp``` 함수는 문자열에서 후행 줄 바꿈을 하나까지 제거하는 데 사용할 수 있어, 다음이 좀 더 적절하다고 한다.

```julia
function askname()
    print("Enter your name: ")
    chomp(readline())
end

askname()
```

```readlines```함수는 여러줄을 입력받을 때 사용
```chomp```를 broadcast하면 각 엔트리마다 /n을 제거할 수 있다.
```julia
chomp.(readlines())
A, B, C, D, E, F, G
H, I, J, K, LMNO, P
Q, R, S
T, U, V
W, X
Y, Z
```
---

## Reading Numbers from Standard Input
표준 입력으로부터 숫자를 읽는 것은 string과 string을 number로 읽는 결합이다.
```parse```함수는 string을 적절한 number type으로 구문분석하는데 사용됨

```julia
parse(Int, "17")
parse(Float32, "-3e6")
```


```readline```과 ```parse```의 결합 함수의 예제는 다음과 같다.
```julia
function asknumber()
    print("Enter a number: ")
    parse(Float64, readline())
end

asknumber()
```

- 부동 소수점 정밀도(floating-point precision)에 대한 일반적인주의 사항이 적용됨.
- ```parse```를 BigInt 및 BigFloat과 함께 사용하여 정밀도 손실을 제거하거나 최소화 할 수 있다.
- 같은 줄에서 둘 이상의 숫자를 읽을때는 보통 공백으로 나눈다.

```julia
function askints()
    print("Enter some integers, separated by spaces: ")
    [parse(Int, x) for x in split(readline())]
end
```
---
## Reading Data from a File
### Reading strings or bytes

파일은 ```open```함수를 *do block syntax*와 함께 사용하여 읽을 수 있다.

```julia
open("./julia/learning julia language/myfile.txt") do f
    for (i, line) in enumerate(eachline(f))
        print("Line $i: $line")
    end
end
```
> ```eachline```보다 ```readlines```가 성능에서 좀 더 낫다.

다음으로도 읽을 수 있다.

```julia
open(readlines, "./julia/learning julia language/myfile.txt")
open(read, "./julia/learning julia language/myfile.txt")
```
>```readstring``` 기능 삭제됨

---
## Reading structured data

```readlm```사용
>```readcsv```은 더이상 사용되지 않음

```julia
using DelimitedFiles

readdlm("./julia/learning julia language/file.csv",',',header=true)
```







