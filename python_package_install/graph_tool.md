나는 도커환경에서 설치함



# graph_tool install
1. visit https://graph-tool.skewed.de/ --> go to --> https://git.skewed.de/count0/graph-tool/-/wikis/installation-instructions
2. 설치!
리눅스와 친하지 못해 설치까지 오래걸렸다. 일단 나는 Debian & Ubuntu docker를 사용하고 있다. 

```bash
echo "deb [ arch=amd64 ] https://downloads.skewed.de/apt DISTRIBUTION main" >> /etc/apt/sources.list  
apt-key adv --keyserver keys.openpgp.org --recv-key 612DEFB798507F25
apt-get install python3-graph-tool
```
- `[ arch=amd64 ]`  이건 암드 프로세스 사용하면 넣어주는 옵션인 듯 하다. 
- `DISTRIBUTION`은 bullseye, buster, sid, bionic, eoan, focal, groovy 중 하나
- `DISTRIBUTION`은 리눅스 버전에 따른 별명 같은것 같은데.. 최신 우분투는 bullseye 이다.
- `deb`, `sources.list`에 대해 잘 몰라 찾아봄
    - `sources.list`란 apt가 패키지를 가져 올 수 있는 위치 정보를 담고 있는 것
    - `sources.list` 파일 내 `deb`와 `deb-src`는 archive 타입을 나타냄
    - 일부 특정 데비안 패키지 프로그램의 설치를 위해서는 `sources.list` 파일에 위치 정보를 추가해 줘야 하는 경우가 있음

DISTRIBUTION을 잘 맞춰 주지 못하면 다음과 같은 에러가 발생한다.
```bash
E: Invalid operation python3-graph-tool
```
또는

```bash
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
python3-matplotlib is already the newest version (3.3.4-1).
python3-cairo is already the newest version (1.16.2-4+b2).
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 python3-graph-tool : Depends: libboost-context1.65.1 but it is not installable
                      Depends: libboost-iostreams1.65.1 but it is not installable
                      Depends: libboost-python1.65.1 but it is not installable
                      Depends: libboost-regex1.65.1 but it is not installable
                      Depends: libpython3.6 (>= 3.6.5) but it is not installable
                      Recommends: libgv-python but it is not installable
                      Recommends: python-matplotlib but it is not installable
                      Recommends: python-cairo but it is not installable
                      Recommends: python-gi-cairo but it is not installable
                      Recommends: python-gi but it is not installable
E: Unable to correct problems, you have held broken packages.
```

내 경우는 다음과 같이 해결함
어쩌다 찾다보니 `deb http://deb.debian.org/debian bullseye main` 관련해서 두개를 넣으라는 게시글을 봐서 넣었더니.. 돌아가길래 그냥 넣음 ㅎㅎ
#### solution
```bash
echo "deb http://deb.debian.org/debian bullseye main" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian bullseye main" >> /etc/apt/sources.list
echo "deb https://downloads.skewed.de/apt DISTRIBUTION main" >> /etc/apt/sources.list 
apt-key adv --keyserver keys.openpgp.org --recv-key 612DEFB798507F25
apt-get install python3-graph-tool python3-cairo python3-matplotlib
```

#### reference
- https://colab.research.google.com/github/count0/colab-gt/blob/master/colab-gt.ipynb#scrollTo=GQ18Kd5F3uKe

# graph_tool import
1. path error
```bash
Python 3.9.7 (default, Sep  3 2021, 20:10:26) 
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from graph_tool.all import *
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ModuleNotFoundError: No module named 'graph_tool'
```
하... 분명 다 설치했는데 import 가 되지 않았다. ISSUE를 찾아보니 PATH 문제 라고 함을 알 수 있었다. (https://git.skewed.de/count0/graph-tool/-/issues/438)
해결방법은 PATH를 적절히 맞춰주는것!

내 개발환경은 Debian GNU/Linux 11 (`$cat/etc/issue`)의 기본 Python 버전인 Python 3.9.7.이나 graph-tool은 python3에 설치되어있다. 구체적인 설치 경로는 /usr/lib/python3/dist-packages 이다.
이것이 virtualenv에 있거나 pyenv를 사용하여 설치된 다른 버전의 Python이 그래프 도구를 찾을 수 없는 이유입니다.

#### solution
```bash
cd /path/to/env/<version_name>/lib/python3.7/site-packages
touch dist-packages.pth
echo "/usr/lib/<default_version>/dist-packages" >> dist-packages.pth
```

내 경우는 다음과 같이 해결함
```bash
cd /usr/local/lib/python3.9/site-packages
touch dist-packages.pth
echo "/usr/lib/python3/dist-packages" >> dist-packages.pth
```

#### reference
- https://git.skewed.de/count0/graph-tool/-/issues/438
- https://jolo.xyz/blog/2018/12/07/installing-graph-tool-with-virtualenv


2. gtk error
```bash
Python 3.9.7 (default, Sep  3 2021, 20:10:26) 
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import graph_tool
>>> from graph_tool.all import *
/usr/lib/python3/dist-packages/graph_tool/draw/cairo_draw.py:1501: RuntimeWarning: Error importing Gtk module: No module named 'gi'; GTK+ drawing will not work.
  warnings.warn(msg, RuntimeWarning)
```
GTK(Gimp ToolKit)은 리눅스에서 GUI를 다루기 위한 가장 대표적인 라이브러리 중 하나이다. 잘은 모르겠지만 gtk관련 모듈이 없었나보다.
#### Solution
```bash
//Installing the system provided PyGObject:
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0

//Installing from PyPI with pip:
sudo apt install libgirepository1.0-dev gcc libcairo2-dev pkg-config python3-dev gir1.2-gtk-3.0
pip3 install pycairo
pip3 install PyGObject
```
#### reference
- https://stackoverflow.com/questions/31021989/error-importing-gtk-module-no-module-named-repository-with-graph-tool
- https://pygobject.readthedocs.io/en/latest/getting_started.html#macosx-getting-started
- https://gist.github.com/goweiting/b3a8c67c0f7ad376d3ce73f2c7729224


3. no error!
```bash
Python 3.9.7 (default, Sep  3 2021, 20:10:26) 
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import graph_tool
>>> from graph_tool.all import *
Unable to init server: Could not connect: Connection refused
Unable to init server: Could not connect: Connection refused
```
이건 에러가 아니라고 한다 ㅎㅎ (진짜 빡칠뻔)

#### reference
- https://archives.skewed.de/hyperkitty/list/graph-tool@skewed.de/thread/DWBHKQZDD4BV7RA2OERR7PI24NVB472V/
