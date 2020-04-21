# MPS 파일 read 및 solve

## 1. 단순히 mps를 읽고, 시간 제약만 주어 풀기

```bash
cbc cbc -import R100701005_2.mps -sec 600 -solve
```

- ```-import```는 생략 가능
- CBC의 계산 과정은 크게 다음과 같다.
    - (1) Preprocess (bound strengthen)
    - (2) Feasibility Pump
    - (3) Cut generation (proving -> Gomory -> Knapsack -> Clique -> Mixed integer rounding -> Flow cover -> Two phase mixed integer rounding -> zero half)
    - (4) Rounding 
    - (5) RINS 
    - (6) Branch & Cut

- 전략에 따라 (3)~(6) 과정이 돌 수 있음

## 2. FP 사용하여 first feasibililty 찾고 끝내기

- 원래 CBC 에서 설정되어 있기로는 FP cycle이 30번만 돌고, 이 때 feasible solution을 찾으면 이를 Branch and Cut의 initial 솔루션으로 사용된다. 하지만 주어진 문제같은 경우는 너무 커서 30번은 택도 없고 CBC에서 설정할 수 있는 가장 많은 횟수인 10000을 설정하였지만 feasible solution을 찾지 못했다. 
- 다음은 명령어 이다.

>``` cbc <mps>  -pumpTune 1000043 PASSF 10000 -feas both -doh SEC 600 > <결과저장형식> ```

```
cbc R100701005_2.mps  -pumpTune 1000043 PASSF 10000 -feas both -doh SEC 600 > R100701005_2_result.txt
```

계산과정을 보려면 마지막 결과저장 형식 부분을 빼면 된다.

```
cbc R100701005_2.mps  -pumpTune 1000043 PASSF 10000 -feas both -doh SEC 600
```