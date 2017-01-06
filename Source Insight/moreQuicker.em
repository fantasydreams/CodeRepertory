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
	szlineWhite = GetBlankSpace(szline,0)
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

macro GetBlankSpace(szline,Blank)
{
    ichFrist = 0
    ichLast = strlen(szline)
    if(0 == ichLast)
    {
    	return ""
    }
    chBlack = CharFromAscii(32)
    chEnter = CharFromAscii(13)
    chTab = CharFromAscii(9)
    while(chBlack == szline[ichFrist] || chEnter == szline[ichFrist] || chTab == szline[ichFrist])
    {
    	ichFrist = ichFrist + 1 
    }
    if(0 == Blank)
    {
    	return strmid(szline,0,ichFrist)
    }
    return strmid(szline,ichFrist,ichLast)
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




macro AddLineComment(hbuf,line,PreFlag,LastFlag)
{
	str = GetBufLine(hbuf,line);
	if(0 != Preflag)
	{
		BlackSpace = GetBlankSpace(str,0)
		BlackSpace = cat(BlackSpace, "/*") 
		str = GetBlankSpace(str,1)
		str = cat(BlackSpace,str)
	}
	if(0 != LastFlag)
	{
		str = cat(str,"*/") 
	}
	DelBufLine(hbuf, line)
        InsBufLine(hbuf, line, str)
}

macro AddMultiComment()
{   
    hbuf = GetCurrentBuf();
    hwnd = GetCurrentWnd();
    sel = GetWndSel(hwnd);

    if (sel.fExtended == FALSE)
    {
    	curLn = GetBufLnCur(hbuf)
    	AddLineComment(hbuf,curLn,1,1)
    	stop
    }

    lnFirst = sel.lnFirst;
    lnLast = sel.lnLast;
    AddLineComment(hbuf,lnFirst,1,0)
    AddLineComment(hbuf,lnLast,0,1)
    SetWndSel(hwnd, sel);
}

macro DelMultiCommet()
{
	hbuf = getCurrentBuf()
	hwnd = getCurrentWnd()
	sel = GetWndSel(hwnd)
	line = getBuflnCur(hbuf)
	if(false == sel.fExtended)
	{
		DelLineComment(hbuf,line)
	}
	DelLineComment(hbuf,sel.lnFirst)
	DelLineComment(hbuf,sel.lnLast)
}


macro DelLineComment(hbuf,line)
{
	szline = GetBufLine(hbuf,line)
	strButBlank = GetBlankSpace(szline,1)
	strBlank = GetBlankSpace(szline,0)
	lnlen = strlen(strButBlank)
	if("" != strButBlank &&  lnlen>= 2)
	{
		if("/" == strButBlank[0] && "*" == strButBlank[1])
		{
			strDeletedComment = strmid(strButBlank,2,strlen(strButBlank))
			strDeletedComment = cat(strBlank,strDeletedComment)
			DelBufLine(hbuf,line)
			InsBufLine(hbuf,line,strDeletedComment)
			
		}
		lnlen = strlen(strButBlank)
		if(lnlen >=2 && "*" == strButBlank[lnlen-2] && "/" == strButBlank[lnlen-1])
		{
			strDeletedComment = strmid(strButBlank,0,strlen(strButBlank)-2)
			DelBufLine(hbuf,line)
			InsBufLine(hbuf,line,strDeletedComment)
		}
	}
}
