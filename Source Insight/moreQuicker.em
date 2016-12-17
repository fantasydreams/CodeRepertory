macro AutoExpand()
{
	hwnd = GetCurrentWnd()
	if(0 == hwnd)
		stop
	sel = GetWndSel(hwnd)/*��ȡ��ǰ��ѡ�п� ���ߵ�ǰ��*/
	GSAutherName(0)
	GSAutherEMail(0)
	strLang = GSEnvLanguage(0)
	if(sel.lnfirst != sel.lnLast)/*���п�*/
	{
		//CommandProc()/*�����*/
	}
	if(0 == sel.ichFirst)/*��ǰ��û���ַ���������*/
	{
		stop
	}
	
	/*��ǰ�����ַ������ExpandProx���н��������*/
	ExpandPorc(strLang)
}

macro ExpandPorc(Lang)
{
	hbuf = GetCurrentBuf()
	curLnNum = GetBufLnCur(hbuf)
	szline = GetBufLine(hbuf,curLnNum)
	strCMD = GetCurLnCMD(szline)
	szlineWhite = GetIchBackSpace(szline)
	szlineWhiteWhitTab = "@szlineWhite@" # "    "


	if("{" == strCMD)
	{
		InsBufLine(hbuf,curLnNum+1,"@szlineWhiteWhitTab@")
		InsBufLine(hbuf,curLnNum+2,"@szlineWhite@" # "}")
		SetBufIns (hbuf,curLnNum+1,strlen(szlineWhiteWhitTab))
	}






	else if("config" == strCMD || "conf" == strCMD)
	{
		configSystem()
	}
	
}

macro GetIchBackSpace(szline) /*��ȡ��ǰ�У�ǰ���һƬ�հ�*/
{
	ichLast = strlen(szline)
	if(0 == ichLast)
		stop
	ichFirst = 0
	chTab = CharFromAscii(9)
	chSpace = CharFromAscii(32) /*space*/
	while(chSpace == szline[ichFirst] || chTab == szline[ichFirst])
	{
		ichFirst = ichFirst + 1
	}
	return strmid(szline,0,ichFirst)
}

macro GetCurLnCMD(szline)  /*��ȡ��ǰ�е�������*/
{
	ichLast = strlen(szline)
	if(0 == ichLast)
		stop
	ichFirst = 0
	chTab = CharFromAscii(9) /*tab*/
	chSpace = CharFromAscii(32) /*space*/
	chEnter = CharFromAscii(13) /*enter*/
	while(chEnter == szline[ichFirst] || chTab == szline[ichFirst] || chSpace == szline[ichFirst])
	{
		ichFirst = ichFirst + 1
	}
	while(chEnter == szline[ichLast] || chTab == szline[ichLast] || chSpace == szline[ichLast])
	{
		ichLast = ichLast -1
	}
	return strmid(szline,ichFirst,ichLast)
}


/*������ߵ�����,���Ϊ��������*/
macro GSAutherName(setFlag)
{
	strName = getreg(AuthorName)
	if(0 == strlen(strName)|| 1==setFlag)
	{
		strName = Ask("Please enter your name:")
		setreg(AuthorName,strName);
	}
	return strName
}

macro GSAutherEMail(setFlag)/*setFlag Ϊ1ʱ����д*/
{
	strEMail = getreg(AutherEMail)
	if(0 == strlen(strEMail) || 1==setFlag)
	{
		strEMail = Ask("Please enter your name:")
		setreg(AutherEMail,strEMail);
	}
	return strEMail
}

macro GSEnvLanguage(setflag)
{
	strLang = getreg(ENVLang)
	if(0 == strLang || 1 == setflag)
	{
		while("0" != strLang && "1" != strLang)
		{
			strLang = ask("Please select language: 0 Chinese, 1 English");
		}
		setreg(ENVLang,strLang)
	}
	return strLang
}

macro configSystem()  /*�������û���*/
{
	GSAutherName(1)
	GSAutherEMail(1)
	GSEnvLanguage(1)
}


macro delCurLine()��/*ɾ����ǰ��macro*/
{
	hbuf = GetCurrentBuf()
	curLnNum = GetBufLnCur(hbuf)
	DelBufLine(hbuf,curLnNum)
}


