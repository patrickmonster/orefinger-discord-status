# orefinger-discord-status
 디스코드 상태 ipc

제작자 : Patrickmonster


# 실행파일 다운로드
[start.bat](https://patrickmonster.github.io/orefinger-discord-status/start.bat)

해당파일은 2차 배포를 금하며,
배포시에 꼭 "[링크](https://patrickmonster.github.io/orefinger-discord-status/)"를 첨부하여 배포 하여 주시기 바랍니다
(2차 변조 및 신뢰성 문제)


# 사용법
윈도우 기반으로 작성하였기에, 윈도우 프로그램 전용입니다.

## 1
[start.bat](https://patrickmonster.github.io/orefinger-discord-status/start.bat)
을 눌러 파일을 다운로드 해 주세요.

## 2
적절한 폴더에 넣고 start.bat 를 더블클릭하여 실행해 줍니다. (관리자 권한 X)

파워쉘이 설치되어 있지 않다면,
자동으로 파워쉘 업데이트 스크립트를 다운로드 하여 설치를 시도합니다

(보통 5.1 버전을 사용중이나, 해당버전에서는 동작하지 않습니다.)


## 3
해당하는 화면이 뜨면 
1 or 2 or 3 을 입력해 주세요.
```
PowerShell 설치됨( C:\~사용자 경로~\AppData\Roaming\..\Local\Microsoft\powershell\pwsh )
원하시는 작업을 입력하세요.
1 : 치지직
2 : SOOP
3 : 종료
```

## 4
```
"치지직을 실행합니다."
방송알리미 {
  "참조코드": "https://github.com/discordjs/RPC/blob/master/src/transports/ipc.js",
  "제작일": "2025-03-18",
  "버전": "1.0.0",
  "테스트 버전": "PowerShell 7.5.0 (MacOS)",
  "현재 실행중인 버전": "7.5.0",
  "제작자": "patrickmonster"
}
PowerShell is up to date.
방송알리미 - 라이브 활동 공유
Enter the Chzzk channel ID:
```
치치직 or SOOP 을 선택하셨다면, 채널아이디를 요구합니다.

치지직은 HASH_ID (e229d18df2edef8c9114ae6e8b20373a)

SOOP은 USER_ID (orefinger) 를 입력해 주세요.

## 5
```
Generated UUID: 07636151-533e-43a9-b245-2d6553f51557
WARNING: Resulting JSON is truncated as serialization has exceeded the set depth of 3.
Sent message: {
  "args": {
    "pid": 14764,
    "activity": {
      "timestamps": {
        "start": 1742302081.0
      },
      "details": "[뉴걸] 오늘 눈왔다며???????????? ฅ^.ʷ̣̫.^ฅ ⊹",
      "buttons": [
        "System.Collections.Hashtable"
      ],
      "instance": false,
      "assets": {
        "large_text": "SOOP 방송중",
        "large_image": "https://profile.img.sooplive.co.kr/LOGO/do/dodam1230/dodam1230.jpg",
        "small_image": "https://play-lh.googleusercontent.com/p9zXgkP4pkCDVR-dQ2HfcHyD5vg9MTjDLFVpckObdHI9dGiiMO9TldFJ7kc5bgEGwYjo=w240-h480-rw"
      }
    }
  },
  "cmd": "SET_ACTIVITY",
  "evt": null,
  "nonce": "07636151-533e-43a9-b245-2d6553f51557"
}
```
위와같은 메세지가 정기적으로 올라온다면,

discord 창을 열고 프로필 상태가 "플레이중" 으로 변경되어 있는지 확인



### 5-1
5번처럼 메세지는 뜨는데, 상태가 변하지 않아요!

-> 설정 - 활동 개인정보 - 활동상태에 들어가

    "감지된 활동을 다른사람들과 공유해보세요" 

가 활성화 되어있는지 확인해 주세요


# 출력
![Image](https://github.com/user-attachments/assets/7d8072ed-e1d0-4717-84fc-7af665a15d69)






# Issu / 개발자 잡담

### 파워쉘 사용한 이유
```
가장흔하고, 기본으로 설치된 프로그램이며

IPC 통신을 지원하기 때문

 뭣보다 이걸로 안하면 사람들이 안쓸거 같았다.
```
### 중간에 이슈가 많았는가?
```
정말 많았음.

powshell 5.1 버전과 7버전 격차가 심하여, 5.1 버전으로 시도했는데, 결과는 나왔으나

인디코딩 문제로 api 데이터 수신이후 기본 문자열 형식이 달라 쓸수 없었어서

결국 파워쉘을 업데이트 하는 방향으로 진행함.
```
### 어떻게 만들게 되었나
```
심심해서?

딱보면 이거 될거 같다...라는 견적이 나와서 진행했다

진행 기간은 2025.03.07 ~ 2025.03.18 정도 걸린거 같다.

이전부터 DISCORD 의 RPC 기능에 대하여 알고는 있었지만,
이를 구현하기 위해서 일렉트론이나 C 언어 레벨까지 생각을 해 보았지만
효율 및 개발/ 유지보수 측면에서 2차 수정이 불가능하다 판단하여
미루고 미루다가

대형프로젝트 powshell 스크립트 작성 작업이 있어
이거면 될거같다... 라는 생각으로 시작했다. 
```

### 커스터마이징
```
알아서 하길 바람.

굳이 안시켜도 알아서 뜯어가지고 2차 개조를 하는 사람들이 나올것 이기 때문에
해킹에만 악용되지 않는다면 환영함.
```