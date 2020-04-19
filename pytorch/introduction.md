임성빈 교수님의 수업자료를 바탕으로 정리합니다.

# Pytorch Tutorials

- Custom Dataset
- Data Preprocessing
- Custom Fuctions and AutoGrad
- Layers, Modules and Sequential Blocks
- Pytorch and multi-GPU
- Checkpoints
- Visualization

## Deep Leaning with Data
- 보통 딥러닝 학습시 데이터를 읽을 때는 CPU를, 연산할 때는 GPU를 사용
- 사이즈가 크지 않은 일반적인 tabular 데이터들은 CPU상에서 학습시키는게 훨씬 빠르고 효과적일 떄가 있다.
- GPU가 아무리 좋아도 데이터가 작으면 오버스펙이다.

## Deep Leaning with Big Data
- ImageNet처럼 사이즈가 큰 데이터를 한번에 올리려고 하면 GPU 메모리에 다 올라가지 않아 out-of-memory가 발생 (full-batch)
- mini-batch SGD
    - 해당하는 데이터들만 준비해서 업로드하고 다음 데이터의 index가 무엇인지만 주어짐
    - CPU가 이를 통해 미리 읽고 준비만 하고있으면 효율적으로 학습을 진행
    - 파이썬에서 ```generator```로 구현 가능

# Custom Dataset
- How can I prepare my data?
    - How to create a Dataset?


$$
\begin{align*}
\qquad Z^* = \min \quad & \mathbf{c}^\top \mathbf{x} \\
\text{s.t.} \quad & \mathbf{A} \mathbf{x} = \mathbf{b} \\
&{D} \mathbf{x} \leq {e} \\
&{x}  \geq 0, \text{ Integer}.
\end{align*}
$$
