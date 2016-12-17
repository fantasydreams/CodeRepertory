macro AutoExpand()
{
	hwnd = GetCurrentWnd()
	if(0 == hwnd)
		stop
	sel = GetWndSel(hwnd)/*获取当前被选中块 或者当前行*/
	GSAutherName(0)
	GSAutherEMail(0)
	strLang = GSEnvLanguage(0)
	if(sel.lnfirst != sel.lnLast)/*多行块*/
	{
		//CommandProc()/*命令处理*/
	}
	if(0 == sel.ichFirst)/*当前行没有字符或者内容*/
	{
		stop
	}
	
	/*当前行有字符命令，让ExpandProx进行解析和填充*/
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

macro GetIchBackSpace(szline) /*获取当前行，前面的一片空白*/
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

macro GetCurLnCMD(szline)  /*获取当前行的命令字*/
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


/*获得作者的姓名,如果为空则设置*/
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

macro GSAutherEMail(setFlag)/*setFlag 为1时，重写*/
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

macro configSystem()  /*重新设置环境*/
{
	GSAutherName(1)
	GSAutherEMail(1)
	GSEnvLanguage(1)
}


macro delCurLine()　/*删除当前行macro*/
{
	hbuf = GetCurrentBuf()
	curLnNum = GetBufLnCur(hbuf)
	DelBufLine(hbuf,curLnNum)
}


