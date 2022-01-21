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

INSERT INTO COMPANY VALUES('īī���������θ�Ʈ', '02-2280-7700');
INSERT INTO COMPANY VALUES('Dreamus', '1577-5557');
INSERT INTO COMPANY VALUES('��Ŷ ����', '070-4457-3085');

INSERT INTO ALBUM VALUES(10743453, 'strawberry moon', 'īī���������θ�Ʈ', '2021.10.19', 
'���伥���� ���� �� ���� 6�� ���ϴ��� ���� ���� �޺���, ����� ������ �� �� �ȿ��� �Ͼ�� �ϵ��� �� �ϱ� ���� ��Ÿ���� ������.
���� ���� �ʴ���, �ٽ� ���� �ʴ��� ������ �� ���� ������ �� ���� �� �ź��� ������, �� ���� �����鼭 ���÷����� ���ڴ�.', '03:25', 1);
INSERT INTO ALBUMGENRE VALUES(10743453, '��/��Ż');
INSERT INTO MUSIC VALUES(10743453, 1, 'strawberry moon', '03:25',
'���� �;�� ���ѷ� ���� �Ǿ�
�ε鷹 �� ���� ���
����� �������� ���ٴϴ� ���̾�
���ư� ����� �̷��

������ ��� ���̷�
�������� ���
�� �Ŵ��� ���߷¿� Ȥ ��û�ص�
�η��� ���� �ž�

Ǫ���� �츮 ����
Ŀ�ٶ� strawberry moon �� ����
������ �ʸ� �ðܺ��� eh-oh

�ٶ��� ��������
���ƿ����� ��� so cool
���� ��� �� �Ϻ��� ooh

�ٽ� �����ϱ� ����� ����̾�
�¸��� ������ �پ�
Oh ������ �Ⲩ�� ��Ű��� ���̾�
�ʿ� �� ���� �� �ִٸ�

������ ������ ������
���Ա��� �㹮
�� �������� ���� �� �� ���Ʒ���
������ ���� �ž�

Ǫ���� �츮 ����
Ŀ�ٶ� strawberry moon �� ����
������ �ʸ� �ðܺ��� eh-oh
�ٶ��� ��������
���ƿ����� ��� so cool
���� ��� �� �Ϻ��� ooh

���� �̺���
�ް��� ������ �� ������ (�� ������)
�Ƹ��� �츮�� ó�� �߰���
���� �� ���� ��� ��, �� ���� ����

Ǫ���� �츮 ����
Ŀ�ٶ� strawberry moon �� ����
������ �������� � eh-oh

�ٶ��� ��������
���ƿ����� ��� so cool
���� ��� �� �Ϻ��� ooh',
'Flac 16/24bit', 6, 1800);
INSERT INTO MUSICGENRE VALUES(10743453, 1, '��/��Ż');
INSERT INTO ARTIST VALUES('������', 'īī���������θ�Ʈ', '2018.09.18', 'EDAM�������θ�Ʈ');
INSERT INTO ARTISTGENRE VALUES('������', '�߶��');
INSERT INTO ARTISTGENRE VALUES('������', '��');
INSERT INTO ARTISTGENRE VALUES('������', '��/��Ż');
INSERT INTO ARTISTGENRE VALUES('������', '�������');
INSERT INTO ARTISTGENRE VALUES('������', '�˾غ�/�ҿ�');
INSERT INTO ARTISTGENRE VALUES('������', '��ũ/��罺');
INSERT INTO ARTISTGENRE VALUES('������', '������ȭ');
INSERT INTO ARTISTGENRE VALUES('������', '�Ϸ�Ʈ�δ�ī');
INSERT INTO ARTISTTYPE VALUES('������', '�ַ�');
INSERT INTO ARTISTTYPE VALUES('������', '����');
INSERT INTO MUSICPRODUCT VALUES('������', '10743453', '1');


INSERT INTO ALBUM VALUES(10421113, 'Spring to Spring', 'Dreamus', '2020.04.22', 
'�ڿ��� �±⿡ ������ ������ ����
������ �ٽ����� ����� �޽���
���Ӱ� ���ϵ� 4���� ����� Ư¡�� ��������-ÿ��-����ƽ��Ÿ����� ��Ư�� ��� ���� ������ �ش�ȭ�ߴٴ� ���̴�. 
�̷��� ȣ������ Ư���� ȭ���� ������ �� ������ Ư�������� �Ͱ�ȴ�.', '25:20', 6);
INSERT INTO ALBUMGENRE VALUES(10421113, '�߶��');
INSERT INTO MUSIC VALUES(10421113, 1, 'Opfern', '02:18',
'No matter how far
I��ll be there where you go
I��m always by your side
So would you hold my hand
I��ll be there oh
No matter how far
I��ll be there where you go
I��m always by your side
So would you hold my hand
I��ll be there oh
Oh everywhere you go
Remember us she said when you��re',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 1, '�߶��');
INSERT INTO MUSIC VALUES(10421113, 2, 'About Time', '05:29',
'She said when you are by my side
�Ҿ��� ������
�ٽ� ��ƿ� ����
������ �� �׳���
�� ���ȳ���
�׷��� �� ������
Oh everywhere I go
I look around
�� ���� �״밡
�ʹ� �����ؼ�
Oh everywhere you go
remember us
�� ��ģ �� ����
���� ���� �ð�
� �� ������ �߾�
�츮 ���ٲ��� ��
�� ã�� �������
�ʹ� ��� �������
������ �� �ɱ�
�� �Ҿ��߾���
Oh everywhere I go
I look around
�� ���� �״밡
�ʹ� �����ؿ�
Oh everywhere you go
remember us
�� ��ģ �� ����
���� ���� �ð�
Oh everywhere I go
I look around
������ ���� ��
�޷����� ����
Oh everywhere you go
remember us
�� ���� ������
�� �� �Ⱦ��ּ���',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 2, '�߶��');
INSERT INTO MUSIC VALUES(10421113, 3, '��ȭ (M?rchen)', '05:44',
NULL, 'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 3, '�߶��');
INSERT INTO MUSIC VALUES(10421113, 4, '�װŸ� �ſ�', '04:06',
'�ٸ� ������ ����϶� ��
���� �ʹ� �����
���� ���� �� ���� �Ҿ��� ���� �ɿ�
���� ������ �� ��������
�� ���� �� ������
����Ѵ� �� �� ���� ��� ���� ����
����Ѵ� ���� ���� ����
�Ƚɽ�Ű�� ������ ���ƿ�
����� �ʿ� ����
�׳� ���� ���� �ʿ��ߴ� ��
�װŸ� �ſ�
�װŸ� �ſ�
�ܸ��� ���� ����� �� ��
�� ���� �� ���ƿ�
�� ���� ����
����� ���Է� ��������
���� ����� ���� ������
�ٶ��� �ʾƿ�
������ �̰� �� �� ���� ������ �ɿ�
����Ѵ� ���� ���� ����
�Ƚɽ�Ű�� ������ ���ƿ�
����� �ʿ� ����
�׳� ���� ���� �ʿ��ߴ� ��
�װŸ� �ſ�
�װŸ� �ſ�
����Ѵ� ���� ���� ����
���� ����� ���̷� ���ƿ�
�׳� �ƹ� �� ���� ���� �Ⱦ����
���� ������ �װŸ� �ſ�
����Ѵ� �� �� ���� ��� ���� ����',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 4, '�߶��');
INSERT INTO MUSIC VALUES(10421113, 5, 'Our Song', '04:40',
'I��m losing my way
���� �̷� ����
�ƴ� �Ŷ�� ��������
�׷� �� �˰� �ִ� ����
Maybe I��m afraid
������ ���� ��鵵
������ �� �� ���� ��ŭ ������ ����
Hold me now
Hold me tight
��������� ������
�����ߴ� ���鵵
��ø� �������� �� ��
So open up your eyes and see
������ ���� ������
�츮�� ���� ������
������� ���� ����
So open up your eyes and see
Don��t be afraid to walk alone
���� ��ø�
�귯���� ���ٰ�
Like we never fall apart
I don��t wanna blame
������ ������ ��
�ڲ� �������� �ʾҴ� ����
�־���
Hold me now
Hold me tight
��������� ������
�����ߴ� ���鵵
��ø� �������� �� ��
So open up your eyes and see
������ ���� ������
�츮�� ���� ������
������� ���� �ʾ�
So open up your eyes and see
Don��t be afraid to walk alone
���� ��ø�
�귯���� ���ٰ�
Like we never fall apart
So open up your eyes and see
������ ���� ������
�츮�� ���� ������
������� ���� �ʾ�
So open up your eyes and see
Don��t be afraid to walk alone
������ �� ��
�ɾ ���� �뷡
Like we never fall apart',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 5, '�߶��');
INSERT INTO MUSIC VALUES(10421113, 6, '�Ҷ�', '03:09',
'�������� ���� �׸��� �� ���� �Ҹ�
�׶��� �����̳� ���� ���ſ� ���
�� �� ���ӱ���
���� �� ���� �� ���� �̼� �� ���
�׶��� �����̳� ���� ���ſ� ���
�� �� �ٺ� ������
���� �� ��ݰ� ������
�� ǰ �ȿ� �� �Ȱ�
�ƽ��� �״� �޸����
���ݾ� ������� ������
���� �� ��ݰ� ������
�� ǰ �ȿ� �� �Ȱ�
�ƽ��� �״� �޸����
���ݾ� ������� ������
���ݾ� ������� ������
���ݾ� ������� ������',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10421113, 6, '�߶��');
INSERT INTO ARTIST VALUES('ȣ������', 'Dreamus', '2019.11.16', '�𽺹���');
INSERT INTO ARTISTGENRE VALUES('ȣ������', '�߶��');
INSERT INTO ARTISTGENRE VALUES('ȣ������', '��/��Ż');
INSERT INTO ARTISTGENRE VALUES('ȣ������', '��');
INSERT INTO ARTISTGENRE VALUES('ȣ������', '��ũ/��罺');
INSERT INTO ARTISTGENRE VALUES('ȣ������', '��������');
INSERT INTO ARTISTTYPE VALUES('ȣ������', '�׷�');
INSERT INTO ARTISTTYPE VALUES('ȣ������', '����');
INSERT INTO MUSICPRODUCT VALUES('ȣ������', 10421113, 1);
INSERT INTO MUSICPRODUCT VALUES('ȣ������', 10421113, 2);
INSERT INTO MUSICPRODUCT VALUES('ȣ������', 10421113, 3);
INSERT INTO MUSICPRODUCT VALUES('ȣ������', 10421113, 4);
INSERT INTO MUSICPRODUCT VALUES('ȣ������', 10421113, 5);
INSERT INTO MUSICPRODUCT VALUES('ȣ������', 10421113, 6);

INSERT INTO ALBUM VALUES(10786723, '�Ը� ���� ������', 'Dreamus', '2021.11.23', 
'���� 12�� 15�� �߸ŵǴ� ������ ù ��° EP ��Kiwi Mixtape���� ������ �� ���Ը� ���� ��������
�׸��� �� �̾�12��3�� �� ��° ������ ���� �����ϸ� ù EP�� ���� ��밨�� ��������', '03:31', 1);
INSERT INTO ALBUMGENRE VALUES(10786723, '�˾غ�/�ҿ�');
INSERT INTO MUSIC VALUES(10786723, 1, '�Ը� ���� ������', '03:31',
'Red lips �� �� �ۿ� ����
�� ������ ������ ������
���� your eyes your eyes
Oh please �ֽẸ�� ����
�Ը� ���� ������ ������
���� goodbye goodbye
Liar
�׷� ���� ���� �ְ���
��� ������ ����
�ǽ��ϳ� ȭ����
�� �̾��ظ� ��� ���� �� �̾���
�� �ص� Beautiful
�ʸ� ������
���� �ϱ� �߾��� ��
I can��t deny it
���� ������ ���� ������ �ʾ��ݾ�
������ ���� ��ġ�� ����
�� �ӿ� ��� �ǹ̰� ����
You liar
Red lips �� �� �ۿ� ����
�� ������ ������ ������
���� your eyes your eyes
Oh please �ֽẸ�� ����
�Ը� ���� ������ ������
���� goodbye goodbye
Liar
�ϳ� �� �� ��
�� �����
��� �۵� �� ������
�� ���Ŀ� ��·�� �ʿ�
���´� �ð� ������
�� �� ������
Oh you��re so selfish
ģ���� ��ġ ���� ������
���� ����ģ �͵鵵 ����
�� �������
by yourself
Red lips �� �� �ۿ� ����
�� ������ ������ ������
���� your eyes your eyes
Oh please �ֽẸ�� ����
�Ը� ���� ������ ������
���� goodbye goodbye
Liar
�̷� ��� �غ���
�ƹ��� ���� �ʰ�
���� �� �������
�� �̾߱� �� ������ ������
Oh I��m the liar
My lips �� �� �ۿ� ����
�� ������ ������ ������
���� my eyes my eyes
Oh please �ֽẸ�� ����
�Ը� ���� ������ ������
Don��t say goodbye goodbye
Liar
Oh I��m a liar
Oh I��m a liar
Oh I��m a liar
Oh I��m a liar
Don��t say goodbye goodbye',
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10786723, 1, '�˾غ�/�ҿ�');
INSERT INTO ARTIST VALUES('I��ll (����)', 'Dreamus', '2017.11.01', '�����̵帲�ý�');
INSERT INTO ARTISTBELONG VALUES('I��ll (����)', 'ȣ������');
INSERT INTO ARTISTGENRE VALUES('I��ll (����)', '��/��Ż');
INSERT INTO ARTISTGENRE VALUES('I��ll (����)', '�������');
INSERT INTO ARTISTGENRE VALUES('I��ll (����)', '�߶��');
INSERT INTO ARTISTGENRE VALUES('I��ll (����)', '�˾غ�/�ҿ�');
INSERT INTO ARTISTGENRE VALUES('I��ll (����)', '��ũ/��罺');
INSERT INTO ARTISTTYPE VALUES('I��ll (����)', '�ַ�');
INSERT INTO ARTISTTYPE VALUES('I��ll (����)', '����');
INSERT INTO MUSICPRODUCT VALUES('I��ll (����)', 10786723, 1);

INSERT INTO ALBUM VALUES(10495943, '���� ������', '��Ŷ ����', '2020.09.25', 
'�Ժη� �������� ��¡���� ����� �������� �а���Ű�� ��߿� �̸��� ���� ���ٰ� ��ġ �ʴ� ����� �߰��ϴ� ��� ��ġ��. �׸��ϸ� �����̷ø� ����� ������. 
���߿� �׷��ٴ� ����� ������ ä �������� ����� �ٽ� ��¡���� ��� ��߷� ���� �ᱹ ���� �ϰ� ���� ���� �����.', '09:16', 2);
INSERT INTO ALBUMGENRE VALUES(10495943, '�ε�����');
INSERT INTO ALBUMGENRE VALUES(10495943, '��/��Ż');
INSERT INTO MUSIC VALUES(10495943, 1, '���� ������', '04:13', 
'����� ã�� ��� ����� ���� �� ����
�Ƹ��� ���� �����̾�
��¼�� �����Ե� �ð�� ������ ����
������ ���� ���� �ž�
�ٸ� ���� ���� ���� ������ �ϸ� ��
�������̵� ��ġ��
��߳����� ������ ��
���� �����忡 ���� �����̾� �մ��� ��
�̷� ���� �ٷ� ������ ���ݾ�
�ν��� ����
������ ã�� ��� ����� ���� �� ����
������ ���� �����̾�
������ �ʴ´뵵 ��¿ ���� ���� �ž�
�ô밡 ���ϰ� ���ݾ�
ǥ���� ���� �ϳ����� ������ ���� ��
�Ჿ��� �������� ��� ��¡�� �ž�
���� �����忡 ���� �����̾� �մ�����
�̷� ���� �ٷ� ������ ���ݾ�
�ν��� ����
�츱 ���ؼ� �μ���
������ ���� ���� �ѹ� �ϰ�
��¦�� �� ����� �����
���� ���� �¸��� ��踦
���� ������ ���� ��ƺ�����
�� �ϼ��̾�
������ ź���ߴ� ��
�츮���� �����ؾ� �� �� �ʴ� �׳�
�հ��� ������ ���� �Ʒ���
���̳� �ڸ� �� �ž�
�ƹ��� �ǹ� ���� ��
�ϼ� ���� ���� �� ��
���ϱ� ����ǰ�� ���� �� �����忡��
�� �ڸ��� ���� �ʴ� �ű������
�׷��� ���� ���� �Ϻ����� �׷���
���� �����忡 ���� �����̾� �մ�����
�̷� ���� �ٷ� ������ ���ݾ�
�ν��� ����', 
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10495943, 1, '�ε�����');
INSERT INTO MUSICGENRE VALUES(10495943, 1, '��/��Ż');
INSERT INTO MUSIC VALUES(10495943, 2, '���� ���', '05:03', 
'��並 ���� �ʴ� �ͺ���
������ ���� ����
�׳� �Լ��� ��� �־��� ���� �׶�
���� ��� �ӿ��� �����ϴ�
�޵��� �����
���� �㿵 �ӿ����� ����ִ�
������ �Ҿ��ؿ�
������� �� �Ÿ���
���� �Ѵٰ� ����� �ּҵ��� �����
�Ҷ��� �� �ϱ��� �ӿ�
��� ��� ������ �����
���� ��� �ӿ��� �����ϴ�
�޵��� �����
���� �㿵 �ӿ����� ����ִ�
������ �ʶ��ؿ�
������� �� �Ÿ���
���� �Ѵٰ� ����� �ּҵ��� �����
�Ҷ��� �� �ϱ��� �ӿ�
��� ��� ������ �����', 
'Flac 16/24bit', NULL, 1800);
INSERT INTO MUSICGENRE VALUES(10495943, 2, '�ε�����');
INSERT INTO MUSICGENRE VALUES(10495943, 2, '��/��Ż');
INSERT INTO ARTIST VALUES('�̽���', '��Ŷ ����', '2016.06.16', '���÷��̿������θ�Ʈ');
INSERT INTO ARTISTGENRE VALUES('�̽���', '��/��Ż');
INSERT INTO ARTISTGENRE VALUES('�̽���', '�ε�����');
INSERT INTO ARTISTGENRE VALUES('�̽���', '�߶��');
INSERT INTO ARTISTGENRE VALUES('�̽���', '�������');
INSERT INTO ARTISTGENRE VALUES('�̽���', '�˾غ�/�ҿ�');
INSERT INTO ARTISTGENRE VALUES('�̽���', '��ũ/��罺');
INSERT INTO ARTISTTYPE VALUES('�̽���', '�ַ�');
INSERT INTO ARTISTTYPE VALUES('�̽���', '����');
INSERT INTO MUSICPRODUCT VALUES('�̽���', 10495943, 1);
INSERT INTO MUSICPRODUCT VALUES('�̽���', 10495943, 2);


INSERT INTO LISTENER VALUES('abc123', '1234', '������', 'W', 21, '��Ʈ����Ŭ��');
INSERT INTO LISTENER VALUES('qwe520', '1207', '����������', 'M', 32, 'MP3 30 �������');
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

ALTER TABLE PLAYMUSIC RENAME COLUMN PM_PLAYYTIME TO PM_PLAYTIME; --��Ÿ ����
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

INSERT INTO PREFERARTIST VALUES('abc123', 'ȣ������');
INSERT INTO PREFERARTIST VALUES('abc123', 'I��ll (����)');
INSERT INTO PREFERARTIST VALUES('qwe520', '������');
INSERT INTO PREFERARTIST VALUES('good7', '�̽���');

INSERT INTO PLAYLIST VALUES(12346, 'ȣ������ �뷡 ����', '28:51', 'abc123');
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 1);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 2);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 3);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 4);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 5);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10421113, 6);
INSERT INTO PLAYLISTCONFIG VALUES(12346, 10786723, 1);

INSERT INTO PLAYLIST VALUES(15342, '��� ����', '23:31', 'good7');
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10421113, 2);
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10421113, 4);
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10421113, 5);
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10495943, 1);
INSERT INTO PLAYLISTCONFIG VALUES(15342, 10495943, 2);

INSERT INTO ALBUMCOMMENT VALUES(111, 10421113, 'abc123', '�뷡 �ʹ� ���ƿ� ��ݤФ� ȣ������ �ְ�!!', '2021.12.05');
INSERT INTO ALBUMCOMMENT VALUES(21, 10495943, 'qwe520', '�ٹ��� �����ϰ��� �ϴ� �ǹ̰� �λ� ��׿�. �� ��� ���ϴ�.', '2021.12.03');
INSERT INTO ALBUMCOMMENT VALUES(2198, 10743453, 'good7', '���� ������! �̹� �뷡�� �ʹ� ���׿�~', '2021.12.07');


-- ���̺� ���� Ȯ��
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

-- ���ϰ��� 1���� �ٹ��� �̸��� ������, ����ð��� �˻�
SELECT A_NAME, A_COMPANYNAME, A_PLAYTIME FROM ALBUM WHERE A_NUMOFSONGS = 1;

-- ���ϰ��� 2�� �̻��� �ٹ��� �̸��� ������, ����ð��� �˻�
SELECT A_NAME, A_COMPANYNAME, A_PLAYTIME FROM ALBUM WHERE A_NUMOFSONGS >= 2;

-- ��� �ٹ� �帣�� �ߺ� ���� �˻�
SELECT DISTINCT AG_GENRE FROM ALBUMGENRE;

-- ��� ���� �帣�� �ߺ� ���� �˻�
SELECT DISTINCT MG_GENRE FROM MUSICGENRE;

-- ��� ��Ƽ��Ʈ�� ��Ƽ��Ʈ�̸���(��������)���� �˻�
SELECT AT_NAME FROM ARTIST ORDER BY AT_NAME;

-- ��Ƽ��Ʈ '������'�� ��Ƽ��Ʈ �帣�� ��� �˻�
SELECT * FROM ARTISTGENRE
WHERE ATG_ATNAME = '������';

-- ��Ƽ��Ʈ ������ '�׷�'�� �ƴ� ��� ��Ƽ��Ʈ�� �̸��� �˻�
SELECT ATT_ATNAME FROM ARTISTTYPE
MINUS
SELECT ATT_ATNAME FROM ARTISTTYPE WHERE ATT_TYPE = '�׷�';

-- ��Ƽ��Ʈ 'ȣ������'�� ���� ������ ������ ������ �˻�
SELECT M_NAME FROM MUSICPRODUCT MP, MUSIC M 
WHERE MP.MP_ATNAME = 'ȣ������' AND MP.MP_AID = M.M_AID AND MP.MP_MTRACKID = M.M_TRACKID;

-- ��� �����ڸ� �г��� ������������ �����Ͽ� �˻�
SELECT * FROM LISTENER ORDER BY L_NICKNAME DESC;

-- �� �ٹ��� �ٹ�������ȣ�� ������ �˻�
SELECT EA_AID, AVG(EA_SCORE) FROM EVALALBUM GROUP BY EA_AID;

-- �ٹ� ������ 4�� �̻��� �ٹ��� ������ȣ, �̸�, �ٹ� �帣, ������ �˻�
SELECT EA_AID, A_NAME, AG_GENRE, EA.AVGSCR FROM
(SELECT A_ID, A_NAME, AG_GENRE
FROM ALBUM, ALBUMGENRE
WHERE A_ID = AG_AID) AF
INNER JOIN
(SELECT EA_AID, AVG(EA_SCORE) AS AVGSCR FROM EVALALBUM GROUP BY EA_AID HAVING AVG(EA_SCORE) >= 4) EA
ON AF.A_ID = EA.EA_AID;

-- 2ȸ �̻� ���ŵ� ������ �̸�, ������ �˻�
SELECT M_NAME, M_PRICE FROM 
(SELECT BM_AID, BM_MTRACKID, COUNT(BM_MTRACKID) FROM BUYMUSIC GROUP BY BM_AID, BM_MTRACKID
HAVING COUNT(BM_AID) >= 2 AND COUNT(BM_MTRACKID) >= 2) BM, MUSIC M
WHERE BM.BM_AID = M.M_AID AND BM.BM_MTRACKID = M.M_TRACKID;

-- �����ڰ� ����� �� ������ �����, ���ۿ� ������ ��Ƽ��Ʈ, �׸��� �����ڿ� ���� ����� Ƚ���� �˻�
SELECT M_NAME, MP_ATNAME, FPM.M_CNT FROM 
(SELECT M_AID, M_TRACKID, M_NAME, MP_ATNAME 
FROM MUSICPRODUCT MP INNER JOIN MUSIC M
ON MP.MP_AID = M.M_AID AND MP.MP_MTRACKID = M.M_TRACKID) FM,
(SELECT PM_AID, PM_MTRACKID, COUNT(PM_AID), COUNT(PM_MTRACKID) AS M_CNT FROM PLAYMUSIC 
GROUP BY PM_AID, PM_MTRACKID) FPM
WHERE FM.M_AID = FPM.PM_AID AND FM.M_TRACKID = FPM.PM_MTRACKID;

-- ��� �÷��̸���Ʈ�� �̸���, �� �÷��̸���Ʈ�� ���ϵ� ���� ������ �˻�
SELECT PL_NAME, PLC.CNT FROM PLAYLIST,
(SELECT PLC_PLID, COUNT(PLC_PLID) AS CNT FROM PLAYLISTCONFIG GROUP BY PLC_PLID) PLC
WHERE PL_ID = PLC_PLID;

-- ���̵� 'good7'�� �������� ��� ���� �� Ȯ��
DELETE FROM ALBUMCOMMENT WHERE AC_LID = 'good7';
SELECT * FROM ALBUMCOMMENT;

