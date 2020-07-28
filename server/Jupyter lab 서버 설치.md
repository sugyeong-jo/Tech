# Jupyter lab 서버 설치

많은 삽질끝에 정리하는 Html에서 주피터랩/주피터 노트북 열기


## 1. 방화벽 열기
*꼭 시작할때 하자..

    sudo ufw allow <port>

## 2. jupyter_notebook_config.py 생성

각자 '.jupyter'가 깔려있는 폴더로 이동!
보통 다음과 같다. 

    /home/<user_name>/.jupyter

그 후 command 창에 다음을 입력하여 초기화 해준다.

    jupyter notebook --generate-config


## 3. password 설정

command창에 ipython 입력 후 다음을 입력

```Ipython
In [1]: from notebook.auth import passwd 
In [2]: passwd() 
   Enter password: 
   Verify password: 
   Out[2]: 'sha1:f24baff49ac5:863dd2ae747212ede58125302d227f0ca7b12bb3'
```

'sha1:~'부분은 복사해 두고 아래 config파일 수정 시 사용


## 4. jupyter_notebook_config.py 수정

'vi'로 수정해주기

    vi jupyter_notebook_config.py
    
입력 후 다음을 삽입

    c = get_config()
    c.NotebookApp.password ='sha1:7be57~'
    # The IP address the notebook server will listen on. 
    # c.NotebookApp.ip = 'localhost' 
    c.NotebookApp.ip = '<ip>' 
    # c.NotebookApp.port_retries = 50 
    c.NotebookApp.port_retries = <port>

수정 후에는  ':q'로 나오기

## 5. nohup 돌려놓기

    nohup jupyter lab --port <port>
    
nohup 돌리고 난 후 엔터 해주기!

- 출처: https://goodtogreate.tistory.com/entry/IPython-Notebook-설치방법 [GOOD to GREAT]
- 출처: https://webdir.tistory.com/206