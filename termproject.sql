-- DDL --

CREATE TABLE COMPANY(
    C_NAME VARCHAR2(100) PRIMARY KEY,
    C_CONTACT VARCHAR2(20) NOT NULL
);

CREATE TABLE ALBUM(
    A_ID NUMBER(20) PRIMARY KEY,
    A_NAME VARCHAR2(200) NOT NULL,
    A_COMPANYNAME VARCHAR2(100) NOT NULL,
    A_RELEASEDATE VARCHAR2(20) NOT NULL,
    A_DESCRIPTION VARCHAR2(1000),
    A_PLAYTIME VARCHAR2(10) CHECK (A_PLAYTIME LIKE '%:%'),
    A_NUMOFSONGS NUMBER(10),
    FOREIGN KEY(A_COMPANYNAME) REFERENCES COMPANY(C_NAME) ON DELETE CASCADE
);

CREATE TABLE ALBUMGENRE(
    AG_AID NUMBER(20),
    AG_GENRE VARCHAR2(20),
    FOREIGN KEY(AG_AID) REFERENCES ALBUM(A_ID) ON DELETE CASCADE,
    PRIMARY KEY(AG_AID, AG_GENRE)
);

CREATE TABLE MUSIC(
    M_AID NUMBER(20),
    M_TRACKID NUMBER(20),
    M_NAME VARCHAR(200) NOT NULL,
    M_PLAYTIME VARCHAR2(10) NOT NULL CHECK (M_PLAYTIME LIKE '%:%'),
    M_LYRICS VARCHAR(3000),
    M_SOUNDQUALITY VARCHAR2(20),
    M_REALTIMERANKING NUMBER(10),
    M_PRICE NUMBER(10) NOT NULL,
    FOREIGN KEY(M_AID) REFERENCES ALBUM(A_ID) ON DELETE CASCADE,
    PRIMARY KEY(M_AID, M_TRACKID)
);

CREATE TABLE MUSICGENRE(
    MG_AID NUMBER(20),
    MG_MTRACKID NUMBER(20),
    MG_GENRE VARCHAR2(20),
    FOREIGN KEY(MG_AID, MG_MTRACKID) REFERENCES MUSIC(M_AID, M_TRACKID) ON DELETE CASCADE,
    PRIMARY KEY(MG_AID, MG_MTRACKID, MG_GENRE)
);

CREATE TABLE ARTIST(
    AT_NAME VARCHAR2(50) PRIMARY KEY,
    AT_COMPANY VARCHAR2(100) NOT NULL,
    AT_DEBUTDATE VARCHAR2(10),
    AT_ENTERTAINMENT VARCHAR(100) NOT NULL,
    FOREIGN KEY(AT_COMPANY) REFERENCES COMPANY(C_NAME) ON DELETE CASCADE
);

CREATE TABLE ARTISTBELONG(
    AT_MEMBERNAME VARCHAR2(50),
    AT_GROUPNAME VARCHAR2(50),
    FOREIGN KEY(AT_MEMBERNAME) REFERENCES ARTIST(AT_NAME) ON DELETE CASCADE,
    FOREIGN KEY(AT_GROUPNAME) REFERENCES ARTIST(AT_NAME) ON DELETE CASCADE,
    PRIMARY KEY(AT_MEMBERNAME, AT_GROUPNAME)
);

CREATE TABLE ARTISTGENRE(
    ATG_ATNAME VARCHAR2(50),
    ATG_GENRE VARCHAR2(20),
    FOREIGN KEY(ATG_ATNAME) REFERENCES ARTIST(AT_NAME) ON DELETE CASCADE,
    PRIMARY KEY(ATG_ATNAME, ATG_GENRE)
);

CREATE TABLE ARTISTTYPE(
    ATT_ATNAME VARCHAR2(50),
    ATT_TYPE VARCHAR2(30),
    FOREIGN KEY(ATT_ATNAME) REFERENCES ARTIST(AT_NAME) ON DELETE CASCADE,
    PRIMARY KEY(ATT_ATNAME, ATT_TYPE)
);

CREATE TABLE MUSICPRODUCT(
    MP_ATNAME VARCHAR2(50),
    MP_AID NUMBER(20),
    MP_MTRACKID NUMBER(20),
    FOREIGN KEY(MP_ATNAME) REFERENCES ARTIST(AT_NAME) ON DELETE CASCADE,
    FOREIGN KEY(MP_AID, MP_MTRACKID) REFERENCES MUSIC(M_AID, M_TRACKID) ON DELETE CASCADE,
    PRIMARY KEY(MP_ATNAME, MP_AID, MP_MTRACKID)
);

CREATE TABLE LISTENER(
    L_ID VARCHAR2(20) PRIMARY KEY,
    L_PW VARCHAR2(20) NOT NULL,
    L_NICKNAME VARCHAR2(50) NOT NULL,
    L_GENDER CHAR(2),
    L_AGE NUMBER(3),
    L_TICKET VARCHAR2(20)
);

CREATE TABLE PREFERALBUM(
    PA_LID VARCHAR2(20),
    PA_AID NUMBER(20),
    FOREIGN KEY(PA_LID) REFERENCES LISTENER(L_ID) ON DELETE CASCADE,
    FOREIGN KEY(PA_AID) REFERENCES ALBUM(A_ID) ON DELETE CASCADE,
    PRIMARY KEY(PA_LID, PA_AID)
);

CREATE TABLE EVALALBUM(
    EA_LID VARCHAR2(20),
    EA_AID NUMBER(20),
    EA_SCORE NUMBER(1) CHECK (EA_SCORE<=5),
    FOREIGN KEY(EA_LID) REFERENCES LISTENER(L_ID) ON DELETE CASCADE,
    FOREIGN KEY(EA_AID) REFERENCES ALBUM(A_ID) ON DELETE CASCADE,
    PRIMARY KEY(EA_LID, EA_AID)
);

CREATE TABLE BUYMUSIC(
    BM_LID VARCHAR2(20),
    BM_AID NUMBER(20),
    BM_MTRACKID NUMBER(20),
    BM_BUYTIME VARCHAR2(10) NOT NULL CHECK (BM_BUYTIME LIKE '%:%'),
    FOREIGN KEY(BM_LID) REFERENCES LISTENER(L_ID) ON DELETE CASCADE,
    FOREIGN KEY(BM_AID, BM_MTRACKID) REFERENCES MUSIC(M_AID, M_TRACKID) ON DELETE CASCADE,
    PRIMARY KEY(BM_LID, BM_AID, BM_MTRACKID)
);

CREATE TABLE PLAYMUSIC(
    PM_LID VARCHAR2(20),
    PM_AID NUMBER(20),
    PM_MTRACKID NUMBER(20),
    PM_PLAYYTIME VARCHAR2(10) NOT NULL CHECK (PM_PLAYYTIME LIKE '%:%'),
    FOREIGN KEY(PM_LID) REFERENCES LISTENER(L_ID) ON DELETE CASCADE,
    FOREIGN KEY(PM_AID, PM_MTRACKID) REFERENCES MUSIC(M_AID, M_TRACKID) ON DELETE CASCADE,
    PRIMARY KEY(PM_LID, PM_AID, PM_MTRACKID)
);

CREATE TABLE PREFERMUSIC(
    PFM_LID VARCHAR2(20),
    PFM_AID NUMBER(20),
    PFM_MTRACKID NUMBER(20),
    FOREIGN KEY(PFM_LID) REFERENCES LISTENER(L_ID) ON DELETE CASCADE,
    FOREIGN KEY(PFM_AID, PFM_MTRACKID) REFERENCES MUSIC(M_AID, M_TRACKID) ON DELETE CASCADE,
    PRIMARY KEY(PFM_LID, PFM_AID, PFM_MTRACKID)
);

CREATE TABLE PREFERARTIST(
    PAT_LID VARCHAR2(20),
    PAT_ATNAME VARCHAR2(50),
    FOREIGN KEY(PAT_LID) REFERENCES LISTENER(L_ID) ON DELETE CASCADE,
    FOREIGN KEY(PAT_ATNAME) REFERENCES ARTIST(AT_NAME) ON DELETE CASCADE,
    PRIMARY KEY(PAT_LID, PAT_ATNAME)
);

CREATE TABLE PLAYLIST(
    PL_ID NUMBER(20) PRIMARY KEY,
    PL_NAME VARCHAR2(200) NOT NULL,
    PL_PLAYTIME VARCHAR2(10) NOT NULL CHECK (PL_PLAYTIME LIKE '%:%'),
    PL_LID VARCHAR2(20),
    FOREIGN KEY(PL_LID) REFERENCES LISTENER(L_ID) ON DELETE CASCADE
);

CREATE TABLE PLAYLISTCONFIG(
    PLC_PLID NUMBER(20),
    PLC_AID NUMBER(20),
    PLC_MTRACKID NUMBER(20),
    FOREIGN KEY(PLC_PLID) REFERENCES PLAYLIST(PL_ID) ON DELETE CASCADE,
    FOREIGN KEY(PLC_AID, PLC_MTRACKID) REFERENCES MUSIC(M_AID, M_TRACKID) ON DELETE CASCADE,
    PRIMARY KEY(PLC_PLID, PLC_AID, PLC_MTRACKID)
);

CREATE TABLE ALBUMCOMMENT(
    AC_ID NUMBER(30) PRIMARY KEY,
    AC_AID NUMBER(20),
    AC_LID VARCHAR2(20),
    AC_CONTENT VARCHAR2(1000) NOT NULL,
    AC_WRITEDATE VARCHAR2(20) NOT NULL,
    FOREIGN KEY(AC_AID) REFERENCES ALBUM(A_ID) ON DELETE CASCADE,
    FOREIGN KEY(AC_LID) REFERENCES LISTENER(L_ID) ON DELETE CASCADE
);


-- DML --

INSERT INTO COMPANY VALUES('카카오엔터테인먼트', '02-2280-7700');
INSERT INTO COMPANY VALUES('Dreamus', '1577-5557');
INSERT INTO COMPANY VALUES('비스킷 사운드', '070-4457-3085');

INSERT INTO ALBUM VALUES(10743453, 'strawberry moon', '카카오엔터테인먼트', '2021.10.19', 
'포토샵으로 만든 것 같은 6월 밤하늘의 딸기 색깔 달보다, 사랑에 빠졌을 때 내 안에서 일어나는 일들이 더 믿기 힘든 판타지에 가깝다.
자주 오지 않더라도, 다시 오지 않더라도 누구나 한 번쯤 경험한 적 있을 그 신비한 순간을, 이 곡을 들으면서 떠올렸으면 좋겠다.', '03:25', 1);
INSERT INTO ALBUMGENRE VALUES(10743453, '록/메탈');
INSERT INTO MUSIC VALUES(10743453, 1, 'strawberry moon', '03:25',
'달이 익어가니 서둘러 젊은 피야
민들레 한 송이 들고
사랑이 어지러이 떠다니는 밤이야
날아가 사뿐히 이루렴

팽팽한 어둠 사이로
떠오르는 기분
이 거대한 무중력에 혹 휘청해도
두렵진 않을 거야

푸르른 우리 위로
커다란 strawberry moon 한 스쿱
나에게 너를 맡겨볼래 eh-oh

바람을 세로질러
날아오르는 기분 so cool
삶이 어떻게 더 완벽해 ooh

다시 마주하기 어려운 행운이야
온몸에 심장이 뛰어
Oh 오히려 기꺼이 헤매고픈 밤이야
너와 길 잃을 수 있다면

맞잡은 서로의 손으로
출입구를 허문
이 무한함의 끝과 끝 또 위아래로
비행을 떠날 거야

푸르른 우리 위로
커다란 strawberry moon 한 스쿱
나에게 너를 맡겨볼래 eh-oh
바람을 세로질러
날아오르는 기분 so cool
삶이 어떻게 더 완벽해 ooh

놀라워 이보다
꿈같은 순간이 또 있을까 (더 있을까)
아마도 우리가 처음 발견한
오늘 이 밤의 모든 것, 그 위로 날아

푸르른 우리 위로
커다란 strawberry moon 한 스쿱
세상을 가져보니 어때 eh-oh

바람을 세로질러
날아오르는 기분 so cool
삶이 어떻게 더 완벽해 ooh',
'Flac 16/24bit', 6, 1800);
INSERT INTO MUSICGENRE VALUES(10743453, 1, '록/메탈');
INSERT INTO ARTIST VALUES('아이유', '카카오엔터테인먼트', '2018.09.18', 'EDAM엔터테인먼트');
INSERT INTO ARTISTGENRE VALUES('아이유', '발라드');
INSERT INTO ARTISTGENRE VALUES('아이유', '댄스');
INSERT INTO ARTISTGENRE VALUES('아이유', '록/메탈');
INSERT INTO ARTISTGENRE VALUES('아이유', '국내드라마');
INSERT INTO ARTISTGENRE VALUES('아이유', '알앤비/소울');
INSERT INTO ARTISTGENRE VALUES('아이유', '포크/블루스');
INSERT INTO ARTISTGENRE VALUES('아이유', '국내영화');
INSERT INTO ARTISTGENRE VALUES('아이유', '일렉트로니카');
INSERT INTO ARTISTTYPE VALUES('아이유', '솔로');
INSERT INTO ARTISTTYPE VALUES('아이유', '여성');
INSERT INTO MUSICPRODUCT VALUES('아이유', '10743453', '1');


INSERT INTO ALBUM VALUES(10421113, 'Spring to Spring', 'Dreamus', '2020.04.22', 
'자연의 온기에 더해진 따뜻한 위로
격정을 다스리는 사랑의 메시지
새롭게 수록된 4곡의 공통된 특징은 ‘투보컬-첼로-어쿠스틱기타’라는 독특한 밴드 편성의 장점을 극대화했다는 점이다. 
이러한 호피폴라 특유의 화학적 결합은 두 가지의 특별함으로 귀결된다.', '25:20', 6);
INSERT INTO ALBUMGENRE VALUES(10421113, '발라드');
INSERT INTO MUSIC VALUES(10421113, 1, 'Opfern', '02:18',
'No matter how far
I’ll be there where you go
I’m always by your side
So would you hold my hand
I’ll be there oh
No matter how far
I’ll be there where you go
I’m always by your side
So would you hold my hand
I’ll be there oh
Oh everywhere you go
Remember us she said when you’re',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 1, '발라드');
INSERT INTO MUSIC VALUES(10421113, 2, 'About Time', '05:29',
'She said when you are by my side
불안한 새벽도
다시 밝아온 댔죠
마지막 날 그날엔
비가 내렸나요
그랬던 것 같은데
Oh everywhere I go
I look around
내 눈엔 그대가
너무 선명해서
Oh everywhere you go
remember us
널 놓친 그 순간
멈춰 버린 시간
어릴 적 마지막 추억
우리 숨바꼭질 속
날 찾긴 했을까요
너무 깊게 숨어버려
슬프게 한 걸까
난 불안했었죠
Oh everywhere I go
I look around
내 눈엔 그대가
너무 선명해요
Oh everywhere you go
remember us
널 놓친 그 순간
멈춰 버린 시간
Oh everywhere I go
I look around
심장이 터질 듯
달려가고 있죠
Oh everywhere you go
remember us
저 문이 열리면
날 꼭 안아주세요',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 2, '발라드');
INSERT INTO MUSIC VALUES(10421113, 3, '동화 (M?rchen)', '05:44',
NULL, 'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 3, '발라드');
INSERT INTO MUSIC VALUES(10421113, 4, '그거면 돼요', '04:06',
'다른 누군갈 사랑하란 말
내겐 너무 어렵죠
내일 보잔 말 이젠 불안할 뿐인 걸요
내겐 어젯밤 그 순간보다
맘 아픈 건 없었죠
사랑한단 말 그 말은 듣고 싶지 않죠
사랑한단 말은 하지 마요
안심시키려 거짓은 말아요
노력할 필요 없이
그냥 지금 내가 필요했단 말
그거면 돼요
그거면 돼요
외면은 내게 남기고 간 게
참 많은 것 같아요
내 맘은 이제
기억의 무게로 무너지죠
나의 사랑은 많은 진심을
바라진 않아요
하지만 이건 단 한 줌의 거짓인 걸요
사랑한단 말은 하지 마요
안심시키려 거짓은 말아요
노력할 필요 없이
그냥 지금 내가 필요했단 말
그거면 돼요
그거면 돼요
사랑한단 말은 하지 마요
나의 사랑을 속이려 말아요
그냥 아무 말 없이 나를 안아줘요
나의 마음은 그거면 돼요
사랑한단 말 그 말은 듣고 싶지 않죠',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 4, '발라드');
INSERT INTO MUSIC VALUES(10421113, 5, 'Our Song', '04:40',
'I’m losing my way
나만 이런 건지
아닐 거라고 생각했죠
그런 줄 알고 있던 거죠
Maybe I’m afraid
눈물에 젖은 밤들도
이제는 셀 수 없을 만큼 오래된 거죠
Hold me now
Hold me tight
희미해지는 마음과
아파했던 기억들도
잠시만 내려놓고 서 서
So open up your eyes and see
수없이 많은 아픔이
우리의 눈을 가려도
잠깐이죠 늦지 않죠
So open up your eyes and see
Don’t be afraid to walk alone
아주 잠시만
흘러가도 좋다고
Like we never fall apart
I don’t wanna blame
맺히는 기억들이 날
자꾸 놓아주지 않았던 날도
있었지
Hold me now
Hold me tight
희미해지는 마음과
아파했던 기억들도
잠시만 내려놓고 서 서
So open up your eyes and see
수없이 많은 아픔이
우리의 눈을 가려도
잠깐이지 늦지 않아
So open up your eyes and see
Don’t be afraid to walk alone
아주 잠시만
흘러가도 좋다고
Like we never fall apart
So open up your eyes and see
수없이 많은 아픔이
우리의 눈을 가려도
잠깐이지 늦지 않아
So open up your eyes and see
Don’t be afraid to walk alone
나란히 서 서
걸어갈 나의 노래
Like we never fall apart',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 5, '발라드');
INSERT INTO MUSIC VALUES(10421113, 6, '소랑', '03:09',
'차가웠던 공기 그리고 저 강물 소리
그때나 지금이나 내겐 버거운 당신
음 참 향기롭군요
비릿한 물 냄새 그 옆에 미소 띤 당신
그때나 지금이나 내겐 버거운 당신
음 난 바보 같군요
여기 이 기쁨과 슬픔을
내 품 안에 꼭 안고서
아쉬운 그대 뒷모습이
조금씩 희미해질 때까지
여기 이 기쁨과 슬픔을
내 품 안에 꼭 안고서
아쉬운 그대 뒷모습이
조금씩 희미해질 때까지
조금씩 희미해질 때까지
조금씩 희미해질 때까지',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 6, '발라드');
INSERT INTO ARTIST VALUES('호피폴라', 'Dreamus', '2019.11.16', '모스뮤직');
INSERT INTO ARTISTGENRE VALUES('호피폴라', '발라드');
INSERT INTO ARTISTGENRE VALUES('호피폴라', '록/메탈');
INSERT INTO ARTISTGENRE VALUES('호피폴라', '댄스');
INSERT INTO ARTISTGENRE VALUES('호피폴라', '포크/블루스');
INSERT INTO ARTISTGENRE VALUES('호피폴라', '뉴에이지');
INSERT INTO ARTISTTYPE VALUES('호피폴라', '그룹');
INSERT INTO ARTISTTYPE VALUES('호피폴라', '남성');
INSERT INTO MUSICPRODUCT VALUES('호피폴라', 10421113, 1);
INSERT INTO MUSICPRODUCT VALUES('호피폴라', 10421113, 2);
INSERT INTO MUSICPRODUCT VALUES('호피폴라', 10421113, 3);
INSERT INTO MUSICPRODUCT VALUES('호피폴라', 10421113, 4);
INSERT INTO MUSICPRODUCT VALUES('호피폴라', 10421113, 5);
INSERT INTO MUSICPRODUCT VALUES('호피폴라', 10421113, 6);

INSERT INTO ALBUM VALUES(10786723, '입만 열면 거짓말', 'Dreamus', '2021.11.23', 
'오는 12월 15일 발매되는 아일의 첫 번째 EP ‘Kiwi Mixtape’의 선공개 곡 ‘입만 열면 거짓말’
그리고 연 이어12월3일 두 번째 선공개 곡을 예고하며 첫 EP에 대한 기대감을 높여간다', '03:31', 1);
INSERT INTO ALBUMGENRE VALUES(10786723, '알앤비/소울');
INSERT INTO MUSIC VALUES(10786723, 1, '입만 열면 거짓말', '03:31',
'Red lips 난 너 밖엔 없지
다 새빨간 거짓말 거짓말
떨린 your eyes your eyes
Oh please 애써보는 몸짓
입만 열면 거짓말 거짓말
이젠 goodbye goodbye
Liar
그래 뭔가 일이 있겠지
밤새 연락해 봐도
의심하냐 화내면
난 미안해만 계속 외쳐 대 미안해
뭘 해도 Beautiful
너만 보였고
좋아 하긴 했었나 봐
I can’t deny it
내가 미쳤지 아직 끝나진 않았잖아
생각해 봤자 넘치는 거짓
그 속에 담긴 의미가 없네
You liar
Red lips 난 너 밖엔 없지
다 새빨간 거짓말 거짓말
떨린 your eyes your eyes
Oh please 애써보는 몸짓
입만 열면 거짓말 거짓말
이젠 goodbye goodbye
Liar
하나 둘 셋 넷
다 세어봐
어떻게 멍든 내 마음만
더 아파와 어쨌든 너와
보냈던 시간 때문에
넌 늘 말했지
Oh you’re so selfish
친구는 마치 독인 듯했지
내게 가르친 것들도 역시
다 남김없이
by yourself
Red lips 난 너 밖엔 없지
다 새빨간 거짓말 거짓말
떨린 your eyes your eyes
Oh please 애써보는 몸짓
입만 열면 거짓말 거짓말
이젠 goodbye goodbye
Liar
이런 얘길 해봤자
아무도 믿질 않고
이제 와 빌어봤자
내 이야긴 다 거짓말 거짓말
Oh I’m the liar
My lips 난 너 밖엔 없지
다 새빨간 거짓말 거짓말
떨린 my eyes my eyes
Oh please 애써보는 몸짓
입만 열면 거짓말 거짓말
Don’t say goodbye goodbye
Liar
Oh I’m a liar
Oh I’m a liar
Oh I’m a liar
Oh I’m a liar
Don’t say goodbye goodbye',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10786723, 1, '알앤비/소울');
INSERT INTO ARTIST VALUES('I’ll (아일)', 'Dreamus', '2017.11.01', '엠제이드림시스');
INSERT INTO ARTISTBELONG VALUES('I’ll (아일)', '호피폴라');
INSERT INTO ARTISTGENRE VALUES('I’ll (아일)', '록/메탈');
INSERT INTO ARTISTGENRE VALUES('I’ll (아일)', '국내드라마');
INSERT INTO ARTISTGENRE VALUES('I’ll (아일)', '발라드');
INSERT INTO ARTISTGENRE VALUES('I’ll (아일)', '알앤비/소울');
INSERT INTO ARTISTGENRE VALUES('I’ll (아일)', '포크/블루스');
INSERT INTO ARTISTTYPE VALUES('I’ll (아일)', '솔로');
INSERT INTO ARTISTTYPE VALUES('I’ll (아일)', '남성');
INSERT INTO MUSICPRODUCT VALUES('I’ll (아일)', 10786723, 1);

INSERT INTO ALBUM VALUES(10495943, '영웅 수집가', '비스킷 사운드', '2020.09.25', 
'함부로 누군가를 상징으로 만들고 영웅으로 둔갑시키고 깃발에 이름을 새겨 흔들다가 원치 않는 모습을 발견하는 즉시 내치는. 그만하면 다행이련만 짓밟아 버리는. 
나중엔 그랬다는 사실은 망각한 채 누군가의 비극을 다시 상징으로 삼아 깃발로 흔들고 결국 내가 하고 싶은 말을 덧대는.', '09:16', 2);
INSERT INTO ALBUMGENRE VALUES(10495943, '인디음악');
INSERT INTO ALBUMGENRE VALUES(10495943, '록/메탈');
INSERT INTO MUSIC VALUES(10495943, 1, '영웅 수집가', '04:13', 
'그토록 찾아 헤맨 사람을 만난 것 같아
아마도 나의 영웅이야
어쩌면 저렇게도 올곧고 위대한 건지
끝까지 나는 따를 거야
다만 내가 원할 말만 영원히 하면 돼
걸음걸이도 한치도
어긋나지만 않으면 돼
나의 진열장에 놓을 영웅이야 손대지 마
이런 조금 바랜 흔적이 있잖아
부숴도 좋아
이제야 찾아 헤맨 사람을 만난 것 같아
마지막 나의 영웅이야
원하지 않는대도 어쩔 수가 없는 거야
시대가 원하고 있잖아
표정과 말투 하나까지 이유가 있을 걸
잠꼬대와 죽음까지 모두 상징일 거야
나의 진열장에 놓을 영웅이야 손대지마
이런 조금 바랜 흔적이 있잖아
부숴도 좋아
우릴 위해서 부서진
영웅을 위해 묵념 한번 하고선
관짝을 뜯어서 깃발을 만들어
힘껏 흔들며 승리의 축배를
무덤 위에다 조금 쏟아부으면
다 완성이야
전설이 탄생했단 걸
우리에게 감사해야 할 걸 너는 그냥
왕관을 쓰고나서 무덤 아래서
잠이나 자면 될 거야
아무런 의미 없는 널
완성 시켜 놓아 준 건
나니까 전리품은 전부 내 진열장에다
네 자리는 없어 너는 거기까지야
그러게 흠집 없이 완벽하지 그랬어
나의 진열장에 놓을 영웅이야 손대지마
이런 조금 바랜 흔적이 있잖아
부숴도 좋아', 
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10495943, 1, '인디음악');
INSERT INTO MUSICGENRE VALUES(10495943, 1, '록/메탈');
INSERT INTO MUSIC VALUES(10495943, 2, '시적 허용', '05:03', 
'고요를 깨지 않는 것보다
적절한 말을 몰라
그냥 입술을 뜯고만 있었던 거죠 그땐
시적 허용 속에서 부유하는
꿈들은 고요해
시적 허영 속에서만 살고있는
마음은 불안해요
어수선한 밤 거리엔
가야 한다고 새겼던 주소들이 없어요
소란한 내 일기장 속엔
새까만 새까만 구멍이 났어요
시적 허용 속에서 부유하는
꿈들은 고요해
시적 허영 속에서만 살고있는
말들은 초라해요
어수선한 밤 거리엔
가야 한다고 새겼던 주소들이 없어요
소란한 내 일기장 속엔
새까만 새까만 구멍이 났어요', 
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10495943, 2, '인디음악');
INSERT INTO MUSICGENRE VALUES(10495943, 2, '록/메탈');
INSERT INTO ARTIST VALUES('이승윤', '비스킷 사운드', '2016.06.16', '쇼플레이엔터테인먼트');
INSERT INTO ARTISTGENRE VALUES('이승윤', '록/메탈');
INSERT INTO ARTISTGENRE VALUES('이승윤', '인디음악');
INSERT INTO ARTISTGENRE VALUES('이승윤', '발라드');
INSERT INTO ARTISTGENRE VALUES('이승윤', '국내드라마');
INSERT INTO ARTISTGENRE VALUES('이승윤', '알앤비/소울');
INSERT INTO ARTISTGENRE VALUES('이승윤', '포크/블루스');
INSERT INTO ARTISTTYPE VALUES('이승윤', '솔로');
INSERT INTO ARTISTTYPE VALUES('이승윤', '남성');
INSERT INTO MUSICPRODUCT VALUES('이승윤', 10495943, 1);
INSERT INTO MUSICPRODUCT VALUES('이승윤', 10495943, 2);


INSERT INTO LISTENER VALUES('abc123', '1234', '가나다', 'W', 21, '스트리밍클럽');
INSERT INTO LISTENER VALUES('qwe520', '1207', '뮤직라이프', 'M', 32, 'MP3 30 정기결제');
INSERT INTO LISTENER VALUES('good7', '0102', 'Ilovemusic', 'W', 18, NULL);

INSERT INTO PREFERALBUM VALUES('abc123', 10421113);
INSERT INTO PREFERALBUM VALUES('qwe520', 10743453);
INSERT INTO PREFERALBUM VALUES('good7', 10495943);

INSERT INTO EVALALBUM VALUES('abc123', 10743453, 4);
INSERT INTO EVALALBUM VALUES('abc123', 10421113, 5);
INSERT INTO EVALALBUM VALUES('abc123', 10786723, 4);
INSERT INTO EVALALBUM VALUES('abc123', 10495943, 3);
INSERT INTO EVALALBUM VALUES('qwe520', 10743453, 5);
INSERT INTO EVALALBUM VALUES('qwe520', 10421113, 4);
INSERT INTO EVALALBUM VALUES('qwe520', 10786723, 3);
INSERT INTO EVALALBUM VALUES('qwe520', 10495943, 2);
INSERT INTO EVALALBUM VALUES('good7', 10743453, 4);
INSERT INTO EVALALBUM VALUES('good7', 10421113, 4);
INSERT INTO EVALALBUM VALUES('good7', 10786723, 3);
INSERT INTO EVALALBUM VALUES('good7', 10495943, 5);

ALTER TABLE BUYMUSIC MODIFY BM_BUYTIME VARCHAR2(20);
INSERT INTO BUYMUSIC VALUES('abc123', 10421113, 4, '2021.12.01 13:22');
INSERT INTO BUYMUSIC VALUES('abc123', 10421113, 5, '2021.11.03 15:01');
INSERT INTO BUYMUSIC VALUES('qwe520', 10743453, 1, '2021.10.28 01:24');
INSERT INTO BUYMUSIC VALUES('qwe520', 10421113, 4, '2021.11.25 11:33');
INSERT INTO BUYMUSIC VALUES('qwe520', 10786723, 1, '2021.12.06 23:55');

ALTER TABLE PLAYMUSIC RENAME COLUMN PM_PLAYYTIME TO PM_PLAYTIME; --오타 수정
ALTER TABLE PLAYMUSIC MODIFY PM_PLAYTIME VARCHAR2(20);
INSERT INTO PLAYMUSIC VALUES('abc123', 10743453, 1, '2021.11.01 00:01');
INSERT INTO PLAYMUSIC VALUES('abc123', 10421113, 5, '2021.11.02 18:01');
INSERT INTO PLAYMUSIC VALUES('abc123', 10421113, 4, '2021.11.31 18:05');
INSERT INTO PLAYMUSIC VALUES('qwe520', 10743453, 1, '2021.10.28 00:20');
INSERT INTO PLAYMUSIC VALUES('qwe520', 10421113, 4, '2021.11.21 12:34');
INSERT INTO PLAYMUSIC VALUES('qwe520', 10786723, 1, '2021.12.01 18:52');

INSERT INTO PREFERMUSIC VALUES('abc123', 10743453, 1);
INSERT INTO PREFERMUSIC VALUES('abc123', 10421113, 1);
INSERT INTO PREFERMUSIC VALUES('abc123', 10421113, 2);
INSERT INTO PREFERMUSIC VALUES('abc123', 10421113, 3);
INSERT INTO PREFERMUSIC VALUES('abc123', 10421113, 4);
INSERT INTO PREFERMUSIC VALUES('abc123', 10421113, 5);
INSERT INTO PREFERMUSIC VALUES('abc123', 10421113, 6);
INSERT INTO PREFERMUSIC VALUES('qwe520', 10743453, 1);
INSERT INTO PREFERMUSIC VALUES('qwe520', 10421113, 4);
INSERT INTO PREFERMUSIC VALUES('qwe520', 10421113, 5);
INSERT INTO PREFERMUSIC VALUES('good7', 10743453, 1);
INSERT INTO PREFERMUSIC VALUES('good7', 10495943, 1);

INSERT INTO PREFERARTIST VALUES('abc123', '호피폴라');
INSERT INTO PREFERARTIST VALUES('abc123', 'I’ll (아일)');
INSERT INTO PREFERARTIST VALUES('qwe520', '아이유');
INSERT INTO PREFERARTIST VALUES('good7', '이승윤');

INSERT INTO PLAYLIST VALUES(12346, '호피폴라 노래 모음', '28:51', 'abc123');
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 1);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 2);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 3);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 4);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 5);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 6);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10786723, 1);

INSERT INTO PLAYLIST VALUES(15342, '밴드 음악', '23:31', 'good7');
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10421113, 2);
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10421113, 4);
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10421113, 5);
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10495943, 1);
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10495943, 2);

INSERT INTO ALBUMCOMMENT VALUES(111, 10421113, 'abc123', '노래 너무 좋아요 명반ㅠㅠ 호피폴라 최고!!', '2021.12.05');
INSERT INTO ALBUMCOMMENT VALUES(21, 10495943, 'qwe520', '앨범이 전달하고자 하는 의미가 인상 깊네요. 잘 듣고 갑니다.', '2021.12.03');
INSERT INTO ALBUMCOMMENT VALUES(2198, 10743453, 'good7', '역시 아이유! 이번 노래도 너무 좋네요~', '2021.12.07');


-- 테이블 내용 확인
SELECT * FROM COMPANY;
SELECT * FROM ALBUM;
SELECT * FROM ALBUMGENRE;
SELECT * FROM MUSIC;
SELECT * FROM MUSICGENRE;
SELECT * FROM ARTIST;
SELECT * FROM ARTISTBELONG;
SELECT * FROM ARTISTGENRE;
SELECT * FROM ARTISTTYPE;
SELECT * FROM MUSICPRODUCT;

SELECT * FROM LISTENER;
SELECT * FROM PREFERALBUM;
SELECT * FROM EVALALBUM;
SELECT * FROM BUYMUSIC;
SELECT * FROM PLAYMUSIC;
SELECT * FROM PREFERMUSIC;
SELECT * FROM PREFERARTIST;
SELECT * FROM PLAYLIST;
SELECT * FROM PLAYLISTCONFIG;
SELECT * FROM ALBUMCOMMENT;

-- 수록곡이 1개인 앨범의 이름과 유통사명, 재생시간을 검색
SELECT A_NAME, A_COMPANYNAME, A_PLAYTIME FROM ALBUM WHERE A_NUMOFSONGS = 1;

-- 수록곡이 2개 이상인 앨범의 이름과 유통사명, 재생시간을 검색
SELECT A_NAME, A_COMPANYNAME, A_PLAYTIME FROM ALBUM WHERE A_NUMOFSONGS >= 2;

-- 모든 앨범 장르를 중복 없이 검색
SELECT DISTINCT AG_GENRE FROM ALBUMGENRE;

-- 모든 음원 장르를 중복 없이 검색
SELECT DISTINCT MG_GENRE FROM MUSICGENRE;

-- 모든 아티스트를 아티스트이름순(오름차순)으로 검색
SELECT AT_NAME FROM ARTIST ORDER BY AT_NAME;

-- 아티스트 '아이유'의 아티스트 장르를 모두 검색
SELECT * FROM ARTISTGENRE
WHERE ATG_ATNAME = '아이유';

-- 아티스트 유형이 '그룹'이 아닌 모든 아티스트의 이름을 검색
SELECT ATT_ATNAME FROM ARTISTTYPE
MINUS
SELECT ATT_ATNAME FROM ARTISTTYPE WHERE ATT_TYPE = '그룹';

-- 아티스트 '호피폴라'가 직접 제작한 음원의 제목을 검색
SELECT M_NAME FROM MUSICPRODUCT MP, MUSIC M 
WHERE MP.MP_ATNAME = '호피폴라' AND MP.MP_AID = M.M_AID AND MP.MP_MTRACKID = M.M_TRACKID;

-- 모든 감상자를 닉네임 내림차순으로 정렬하여 검색
SELECT * FROM LISTENER ORDER BY L_NICKNAME DESC;

-- 각 앨범의 앨범고유번호와 평점을 검색
SELECT EA_AID, AVG(EA_SCORE) FROM EVALALBUM GROUP BY EA_AID;

-- 앨범 평점이 4점 이상인 앨범의 고유번호, 이름, 앨범 장르, 평점을 검색
SELECT EA_AID, A_NAME, AG_GENRE, EA.AVGSCR FROM
(SELECT A_ID, A_NAME, AG_GENRE
FROM ALBUM, ALBUMGENRE
WHERE A_ID = AG_AID) AF
INNER JOIN
(SELECT EA_AID, AVG(EA_SCORE) AS AVGSCR FROM EVALALBUM GROUP BY EA_AID HAVING AVG(EA_SCORE) >= 4) EA
ON AF.A_ID = EA.EA_AID;

-- 2회 이상 구매된 음원의 이름, 가격을 검색
SELECT M_NAME, M_PRICE FROM 
(SELECT BM_AID, BM_MTRACKID, COUNT(BM_MTRACKID) FROM BUYMUSIC GROUP BY BM_AID, BM_MTRACKID
HAVING COUNT(BM_AID) >= 2 AND COUNT(BM_MTRACKID) >= 2) BM, MUSIC M
WHERE BM.BM_AID = M.M_AID AND BM.BM_MTRACKID = M.M_TRACKID;

-- 감상자가 재생한 각 음원의 제목과, 제작에 참여한 아티스트, 그리고 감상자에 의해 재생된 횟수를 검색
SELECT M_NAME, MP_ATNAME, FPM.M_CNT FROM 
(SELECT M_AID, M_TRACKID, M_NAME, MP_ATNAME 
FROM MUSICPRODUCT MP INNER JOIN MUSIC M
ON MP.MP_AID = M.M_AID AND MP.MP_MTRACKID = M.M_TRACKID) FM,
(SELECT PM_AID, PM_MTRACKID, COUNT(PM_AID), COUNT(PM_MTRACKID) AS M_CNT FROM PLAYMUSIC 
GROUP BY PM_AID, PM_MTRACKID) FPM
WHERE FM.M_AID = FPM.PM_AID AND FM.M_TRACKID = FPM.PM_MTRACKID;

-- 모든 플레이리스트의 이름과, 각 플레이리스트에 수록된 곡의 개수를 검색
SELECT PL_NAME, PLC.CNT FROM PLAYLIST,
(SELECT PLC_PLID, COUNT(PLC_PLID) AS CNT FROM PLAYLISTCONFIG GROUP BY PLC_PLID) PLC
WHERE PL_ID = PLC_PLID;

-- 아이디가 'good7'인 감상자의 댓글 삭제 후 확인
DELETE FROM ALBUMCOMMENT WHERE AC_LID = 'good7';
SELECT * FROM ALBUMCOMMENT;

