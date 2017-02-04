/**
* @brief
*    source insight expand macro interface
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro AutoExpand()
{
	hwnd = GetCurrentWnd()
	if(0 == hwnd)
		stop
	sel = GetWndSel(hwnd)
	GSAutherName(0)
	GSAutherEMail(0)
	strLang = GSEnvLanguage(0)
	if(sel.lnfirst != sel.lnLast)
	{
		//CommandProc()
	}
	if(0 == sel.ichFirst)
	{
		stop
	}
	
	ExpandPorc(strLang)
}


/**
* @brief
*    resolve command and the dispatch relation function do something
*
* @author  sharwen
* 
* @param   Lang   type of language,1 english,0 chinese  default 1 
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
* @li   Sharwen, 2017/1/25, add hbuf nil judge statement
*/
macro ExpandPorc(Lang)
{
	hbuf = GetCurrentBuf()
	if(hnil == hbuf)
	{
		return
	}
	wcurLnNum = GetBufLnCur(hbuf)
	szline    = GetBufLine(hbuf,wcurLnNum)
	szcommand = GetCurLncmd(szline)
	szcommand = toSmallLetter(szcommand)

	if("{" == szcommand)
	{
		szLineBlank = GetBlankSpace(szline,0)
		delBufLine(hbuf,wcurLnNum)
		InsertBracket(hbuf,wcurLnNum,szLineBlank)
		return
	}
	if("dfunc" == szcommand || "df" == szcommand)
	{
		DelBufline(hbuf,wcurLnNum)      /**<delete current line*/
		DFuncComment(hbuf,wcurLnNum,0)
		return
	}
	if("dfuncdef" == szcommand || "dfd" == szcommand)
	{
		DelBufline(hbuf,wcurLnNum)      /**<delete current line*/
		DFuncComment(hbuf,wcurLnNum,1)
		return
	}
	if("#ifdef" == szcommand || "#ifd" == szcommand)/**< #ifdef code block*/
	{
		DefComment(hbuf,wcurLnNum,"#ifdef",nil)
		return
	}
	if("#ifndef" == szcommand || "#ifnd" == szcommand)/**< #ifndef code block*/
	{
		DefComment(hbuf,wcurLnNum,"#ifndef",nil)
		return
	}
	if("#if" == szcommand)/**< #if code block*/
	{
		DefComment(hbuf,wcurLnNum,"#if",nil)
		return
	}
	if("enum" == szcommand || "en" == szcommand)
	{
		ENUMComment(hbuf,wcurLnNum)
		return
	}
	if("hd" == szcommand || "head" == szcommand)
	{
		HeaderFileComment(hbuf,0,wcurLnNum)
		return
	}
	if("hdn" == szcommand || "headn" == szcommand)
	{
		HeaderFileComment(hbuf,1,wcurLnNum)
		return
	}
	if("cpp" == szcommand)
	{
		InsertCPP(hbuf,wcurLnNum)
	}
	if("while" == szcommand)
	{
		InsertWhile(hbuf,wcurLnNum)
		return
	}
	if("li" == szcommand)
	{
		InsertHistory(hbuf,wcurLnNum)
		return
	}
	
	if("config" == szcommand || "conf" == szcommand)
	{
		configSystem()
		return
	}
	
	
}


/**
* @brief
*    get blankspace in front of a line or get a line except for blankspace in head of a line
*
* @author  sharwen
* 
* @param   szline   a string
* @param   Blank    bool value,1 or 0,when it equal 0,this function return blankspace in front of this string ,else,return a string except blanckspace in front of szline
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro GetBlankSpace(szline,Blank)
{
    ichFrist = 0
    ichLast = strlen(szline)
    if(0 == ichLast)
    {
    	return ""
    }
    chBlank = CharFromAscii(32)
    chTab   = CharFromAscii(9)
    while(chBlank == szline[ichFrist] || chTab == szline[ichFrist])
    {
    	ichFrist = ichFrist + 1
    	if(ichFrist == ichLast)
    	{
    		return ""
    	}
    }
    if(0 == Blank)
    {
    	return strmid(szline,0,ichFrist)
    }
    return strmid(szline,ichFrist,ichLast)
}


/**
* @brief
*    get command from szline
*
* @author  sharwen
* 
* @param   szline   a string
*
* @return
*    
* @par  revise
* @li   sharwen, 2017/1/11, create new function
* @li   sharwen, 2017/1/13, support command line add new words except for command
*/
macro GetCurLncmd(szline)
{
	szcmd = strTrim(szline)
	szcmd = GetFristWord(szcmd)
	return szcmd;
}


/**
* @brief
*    get the local author form system,if there not setted,it will be setted
*
* @author  sharwen
* 
* @param   setFlag bool value,when it equal 1,reset author name,otherwise,it will return a sring about author name
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro GSAutherName(setFlag)
{
	szName = getreg(AuthorName)
	if(0 == strlen(szstrName)|| 1==setFlag)
	{
		szName = Ask("Please enter your name:")
		setreg(AuthorName,szName);
	}
	return szName
}


/**
* @brief
*    get the local author email form system,if there not setted,it will be setted
*
* @author  sharwen
* 
* @param   setFlag bool value,when it equal 1,reset author email,otherwise,it will return a sring about author email
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro GSAutherEMail(setFlag)
{
	szEMail = getreg(AutherEMail)
	if(0 == strlen(szEMail) || 1==setFlag)
	{
		strEMail = Ask("Please enter your email:")
		setreg(AutherEMail,szEMail);
	}
	return szEMail
}



/**
* @brief
*    get the local language form system,if there not setted,it will be setted
*
* @author  sharwen
* 
* @param   setFlag bool value,when it equal 1,reset language,otherwise,it will return a sring about language
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro GSEnvLanguage(setflag)
{
	szLang = getreg(ENVLang)
	if(0 == strlen(szLang) || 1 == setflag)
	{
		szLang = ask("Please select language: 0 Chinese, 1 English");
		while("0" != szLang && "1" != szLang)
		{
			szLang = ask("Please select language: 0 Chinese, 1 English");
		}
		setreg(ENVLang,szLang)
	}
	return szLang
}


/**
* @brief
*    reset the author name and email,reset the language enviroment
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro configSystem()
{
	GSAutherName(1)
	GSAutherEMail(1)
	GSEnvLanguage(1)
}



/**
* @brief
*    delete current line from hbuf
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro delCurLine()
{
	hbuf   = GetCurrentBuf()
	wLnNum = GetBufLnCur(hbuf)
	DelBufLine(hbuf,wLnNum)
}



/**
* @brief
*    add C++ style comment in line(comment line)
*
* @author  sharwen
* 
* @param[in]   hbuf   handle buffer
* @param[in]   wline   ln in handle buffer
* @param[in]   dPreFlag   bool value,if it not equal 0, "/*" will be added in front of a line
* @param[in]   dLastFlag  bool value,if it not equal 0, "*" and "/" will be added in front of a line together
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
* @li   Sharwen, 2017/1/17, new requirement for comment,cursor locate at meddle of comment line
*/
macro AddLineComment(hbuf,wline,dPreFlag,dLastFlag)
{
	szstr = GetBufLine(hbuf,wline);
	if(0 != dPreFlag)
	{
		szBlackSpace = GetBlankSpace(szstr,0)
		szBlackSpace = cat(szBlackSpace, "/* ") 
		szstr = GetBlankSpace(szstr,1)
		szstr = cat(szBlackSpace,szstr)
	}
	if(0 != dLastFlag)
	{
		szstr = cat(szstr," */") 
	}
	DelBufLine(hbuf, wline)
	InsBufLine(hbuf, wline, szstr)
	if(dLastFlag)
	{
		SetBufIns(hbuf,wline,strlen(szstr) - 2)
	}
}


/**
* @brief
*    add C++ style comment in selected block
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   Shawen, 2017/1/11, create new function
*/
macro AddMultiComment()
{   
    hbuf = GetCurrentBuf();
    hwnd = GetCurrentWnd();
    sel = GetWndSel(hwnd);

    if (sel.fExtended == FALSE)
    {
    	wcurLn = GetBufLnCur(hbuf)
    	AddLineComment(hbuf,wcurLn,1,1)
    	stop
    }

    wlnFirst = sel.lnFirst;
    wlnLast = sel.lnLast;
    AddLineComment(hbuf,wlnFirst,1,0)
    AddLineComment(hbuf,wlnLast,0,1)
    SetWndSel(hwnd, sel);
}


/**
* @brief
*    delete C++ style comment in selected block
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro DelMultiCommet()
{
	hbuf = getCurrentBuf()
	hwnd = getCurrentWnd()
	sel = GetWndSel(hwnd)
	wline = getBuflnCur(hbuf)
	if(false == sel.fExtended)
	{
		DelLineComment(hbuf,wline)
	}
	DelLineComment(hbuf,sel.lnFirst)
	DelLineComment(hbuf,sel.lnLast)
}


/**
* @brief
*    delete C++ style comment in line
*
* @author  sharwen
* 
* @param[in]   hbuf   handle buffer
* @param[in]   line   ln in handle buffer
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro DelLineComment(hbuf,wline)
{
	szline = GetBufLine(hbuf,line)
	szstrButBlank = GetBlankSpace(szline,1)
	szstrBlank    = GetBlankSpace(szline,0)
	wlnlen = strlen(szstrButBlank)
	if("" != szstrButBlank &&  wlnlen>= 2)
	{
		if("/" == szstrButBlank[0] && "*" == szstrButBlank[1])
		{
			szstrDeletedComment = strmid(szstrButBlank,2,strlen(szstrButBlank))
			szstrDeletedComment = cat(szstrBlank,szstrDeletedComment)
			DelBufLine(hbuf,wline)
			InsBufLine(hbuf,wline,szstrDeletedComment)
			
		}
		wlnlen = strlen(szstrButBlank)
		if(wlnlen >=2 && "*" == szstrButBlank[wlnlen-2] && "/" == szstrButBlank[wlnlen-1])
		{
			szstrDeletedComment = strmid(szstrButBlank,0,strlen(szstrButBlank)-2)
			DelBufLine(hbuf,wline)
			InsBufLine(hbuf,wline,szstrDeletedComment)
		}
	}
}


/**
* @brief
*    get rid of blankspace in front of a string
*
* @author  sharwen
* 
* @param[in]   szline   a string
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro strTrimLeft(szline)
{
	return GetBlankSpace(szline,1);
}


/**
* @brief
*    get rid of blankspace in end of a string
*
* @author  sharwen
* 
* @param[in]   szline   a string
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro strTrimRight(szline)
{
	wichFrist = 0
    wichLast  = strlen(szline) -1 
    if(0 > wichLast)
    {
    	return ""
    }
	chBlank = CharFromAscii(32)
    chTab   = CharFromAscii(9)
	while(wichLast > wichFrist)
    {
    	if((chBlank != szline[wichLast]) && (chTab != szline[wichLast]))
    	{
    		break
    	}
    	wichLast = wichLast - 1
    }
    if(0 > wichLast)
	{
		return ""
	}
    return strmid(szline,wichFrist,wichLast+1)
}


/**
* @brief
*    get rid of blankspace both begin and end
*
* @author  sharwen
* 
* @param[in]   szline   a string
*
* @return
*    
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro strTrim(szline)
{
	szstrLeft = strTrimLeft(szline)
	szstr     = strTrimRight(szstrLeft)
	return szstr;
}


/**
* @brief
*    get rid of comment both begin and end
*
* @author  sharwen
* 
* @param[in]   szline   a string
*
* @return
*    	string
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro GetLineWithoutComment(szline)
{	
	szRetStr = ""
	if(0 == strlen(szline))
	{
		return szRetStr;
	}
	szline = strTrim(szline)
	wfInx = 0;
	wlInx = strlen(szline)
	/*skip comment block*/
	if(wfInx >= 1)
	{
		if("/" == szline[wfInx] && "*" == szline[wfInx+1])
		{
			while(wfInx < wlInx - 1)
			{
				if("*" == szline[wfInx] && "/" == szline[wfInx+1])
				{
					wfInx = wfInx + 2;
					break;
				}
				wfInx = wfInx + 1;
			}
		}
	}
	if(wlInx >= 2)
	{
		if("*" == szline[wlInx-2] && "/" == szline[wlInx-1])
		{
			while(0 < wlInx - 2)
			{
				if("/" == szline[wlInx-2] && "*" == szline[wlInx-1])
				{
					wlInx = wlInx - 3;
					break;
				}
				wlInx = wlInx - 1;
			}
		}
	}
	if(wfInx <= wlInx)
	{
		return strmid(szline,wfInx,wlInx);
	}
	return szRetStr;
}



/**
* @brief
*    get last word from a string
*
* @author  sharwen
* 
* @param[in]   szline   a string
*
* @return
*    	string
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro GetLastWord(szline)
{
	wichLast  = strlen(szline)
	wichFrist = wichLast - 1
	if(0 == wichLast)
	{
		return ""
	}
	chBlack = CharFromAscii(32)
    chTab   = CharFromAscii(9)
    
	while(0 <= wichFrist)
	{
		if(chBlack == szline[wichFrist] || chTab == szline[wichFrist])
		{
			break;
		}
		wichFrist = wichFrist - 1
	}

	return strmid(szline,wichFrist+1,wichLast)
}


/**
* @brief
*    get frist word from a string
*
* @author  sharwen
* 
* @param[in]   szline   a string
*
* @return
*    	string
* @par  revise
* @li   Sharwen, 2017/1/13, create new function
*/
macro GetFristWord(szline)
{
	wichLast  = 0
	wichFrist = 0
	wLen    = strlen(szline)
	if(0 == wLen)
	{
		return ""
	}
	chBlack = CharFromAscii(32)
    chTab   = CharFromAscii(9)
    
	while(wichLast < wLen)
	{
		if(chBlack == szline[wichLast] || chTab == szline[wichLast])
		{
			break;
		}
		wichLast = wichLast + 1
	}

	return strmid(szline,wichFrist,wichLast)
}

/**
* @brief
*    spilit words from string
*
* @author  sharwen
* 
* @param[in]   szline   a string
* @param[in]   hbuf     a handle buffer
* @param[in]   chBegin  a char in line,and need spilt starts here
* @param[in]   separater  separater char
* @param[in]   chEnd    a char in line,and need spilt ends here
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro SplitString(szline,hbuf,chBegin,separater,chEnd)
{
	wichFrist = 0;
	wichLast  = strlen(szline)
	if(0 == wichLast)
	{
		return ""
	}

	while(wichFrist < wichLast)/**< locate the begion of string*/
	{
		if(chBegin == szline[wichFrist])
		{
			break;
		}
		wichFrist = wichFrist + 1
	}
	wichFrist = wichFrist + 1

	while(wichFrist < wichLast)/**< locate the end of string*/
	{
		if(chEnd == szline[wichLast])
		{
			break;
		}
		wichLast = wichLast - 1
	}
	
	while(wichFrist < wichLast)/**<extract para list from string*/
	{
		wtmpInx = wichFrist
		while((separater != szline[wtmpInx]) && (wtmpInx < wichLast))
		{
			wtmpInx = wtmpInx + 1
		}
		
		if(wichFrist == wtmpInx) /**<avoid continuous separater*/
		{
			wichFrist = wichFrist + 1
			continue
		}
		szword = strmid(szline,wichFrist,wtmpInx)
		szword = strTrim(szword)

		if("void" != szword && "VOID" != szword && nil != szword)
		{
			AppendBufLine(hbuf,szword)
		}
		wichFrist = wtmpInx + 1
	}
}


/**
* @brief
*    spilit words from string
*
* @author  sharwen
* 
* @param[in]   hbuf     a handle buffer
* @param[in]   FuncListBuf  a handle buf,it include function para list when it excute finish
* @param[in]   symbol  use GetCurSymbol function get
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro GetFuncParaList(hbuf,FuncListBuf,symbol)
{
	szfuncDef = ""
	wlnFrist = symbol.lnFirst
	wlnLast  = symbol.lnLim
	while(wlnFrist < wlnLast)/**< get define of a function*/
	{
		szline  = GetBufLine(hbuf,wlnFrist)
		szline    = GetLineWithoutComment(szline)  /**< Get rid of Comment block in one line*/
		szline    = strTrim(szline)				     /**< Get rid of BlackSpace block in one line*/
		wLInx    = strlen(szline) - 1
		szfuncDef = cat(szfuncDef,szline)
		wlnFrist = wLnFrist + 1
		if(0 > wLInx)
		{
			wLInx = 0
		}
		if("{" == szline[0] || "{" == szline[wLInx] || ";" == szline[0] || ";" == szline[wLInx])/*function define finished*/
		{
			wichLast  = strlen(szfuncDef)
			szfuncDef = strmid(szfuncDef,0,wichLast-1)
			break;
		}
	}
	SplitString(szfuncDef,FuncListBuf,"(",",",")")
}


/**
* @brief
*    SearchForward word
*
* @author  sharwen
* 
* @param[in]   word  word need to search
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro SearchForward(word)
{
    LoadSearchPattern(word, 1, 0, 1);
    Search_Forward
}


/**
* @brief
*    SearchForward backword
*
* @author  sharwen
* 
* @param[in]   word  word need to search
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro SearchBackward(word)
{
    LoadSearchPattern(word, 1, 0, 1);
    Search_Backward
}


/**
* @brief
*    get current system time
*
* @author  sharwen
* 
* @return
*    	string  like 2017/1/11
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro GetCurTime()
{	
	CurTime = GetSystime(1)
	szyear   = CurTime.year
	szmonth  = CurTime.month
	szday    = CurTime.day
	szRetval = "@szyear@/@szmonth@/@szday@"
	return szRetval
}


/**
* @brief
*    comment a function
*
* @author  sharwen
* 
* @param[in]   hbuf  a handle
* @param[in]   wline  function define line number
* @param[in]   booldef  boo value ,when it equal 1,function defination;0,function realizaton
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
*/
macro DFuncComment(hbuf,wline,booldef)
{
	if(0 != booldef && 1 != booldef)
	{
		return
	}
	symbol = GetCurSymbol()
	szbrief  = ask("please intput brief of this function:")
	szbrief  = cat("*    ",szbrief)
	szauthor = GSAutherName(0)
	wparaNum = 0
	hFuncListBuf = hnil
	if(0 != strlen(symbol))
	{
		hFuncListBuf = NewBuf("__FuncListBuf__")   /*use a temp buf to save para list*/
	    if(hNil == hFuncListBuf)
	    {
	        stop
	    }
		symbol = GetSymbolLocationFromLn(hbuf, wline)
		GetFuncParaList(hbuf,hFuncListBuf,symbol)
		wparaNum = GetbufLineCount(hFuncListBuf)
	}
	
	InsBufLine(hbuf,wline,"/**")
	InsBufLine(hbuf,wline+1,"* \@brief")
	InsBufLine(hbuf,wline+2,szbrief)
	InsBufLine(hbuf,wline+3,"*")
	InsBufLine(hbuf,wline+4,"* \@author  @szauthor@")
	InsBufLine(hbuf,wline+5,"*")
	wnewLine = wline + 6
	wInsParaListLn = wnewline
	if(0 != strlen(symbol))
	{
		wInx = 0
		while(wInx < wparaNum)
		{
			szline = GetBufLine(hFuncListBuf,wInx)
			szkey  = GetLastWord(szline)
			InsBufLine(hbuf,wnewline + wInx,"* \@param[in]  @szkey@")
			wInx = wInx + 1
		}
		wnewline = wnewline + wInx
		closeBuf(hFuncListBuf)
	}

	szStrCurtime = GetCurTime()
	InsBufLine(hbuf,wnewline,"*")
	InsBufLine(hbuf,wnewline+1,"* \@return")
	InsBufLine(hbuf,wnewline+2,"*    ")
	InsBufLine(hbuf,wnewline+3,"* \@par  revise")
	InsBufLine(hbuf,wnewline+4,"* \@li   @szauthor@, @szStrCurtime@, create new function")
	InsBufLine(hbuf,wnewline+5,"*/")
	wnewline = wnewline + 6

	if(0 == strlen(symbol))  /**<new function*/
	{
		szretType = ask("please input return type:")
		szfunc    = ask("please input function name:")
		if(0 < strlen(szfunc))
		{
			if(0 == booldef)  /**<new function realization*/
			{
				InsBufline(hbuf,wnewline,"@szretType@ @szfunc@( # )")
				InsBufline(hbuf,wnewline + 1,"{")
				InsBufline(hbuf,wnewline + 2,"    ")
				InsBufline(hbuf,wnewline + 3,"}")
				wnewline = wnewline + 3
				szrightbracket = ")"
			}
			else   /**<new function define*/
			{
				InsBufline(hbuf,wnewline,"@szretType@ @szfunc@( # );")
				wnewline = wnewline + 1
				szrightbracket = ");"
			}
			SearchForward("#")

			wfrist_time = 1
			wcurBufLn   = GetBufLnCur(hbuf)
			while(true)
			{
				
				szline   = GetBufLine(hbuf,wcurBufLn)
				wszlnLen  = strlen(szline)
				if(0 == wfrist_time)
				{
					szline = strmid(szline,0,wszlnLen - booldef -1)
					szline = cat(szline,", ")
				}
				else
				{
					szline = strmid(szline,0,wszlnLen - booldef - 3)
					wfrist_time = 0
				}

				
				sznewParam = ask("please intput paraName:")
				sznewParam = strTrim(sznewParam)
				szline   = cat(szline,"@sznewParam@")
				szline   = cat(szline,szrightbracket)
				putBufLine(hbuf,wcurBufLn,szline)
				InsBufLine(hbuf,wInsParaListLn,"* \@param[in]  @sznewParam@")
				wInsParaListLn = wInsParaListLn + 1
				wcurBufLn = wcurBufLn + 1
			}
			
		}
	}
	
}


/**
* @brief
*    make up ifdef or ifndef code block automaticly
*
* @author  sharwen
* 
* @param[in]   hbuf  a handle
* @param[in]   wline  function define line number
* @param[in]   func  func name , #ifdef or #ifndef
* @param[in]   szfilename  filename  nil or a string
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/11, create new function
* @li   Sharwen, 2017/1/25, revise function interface
* @li   Sharwen, 2017/2/3,  fix a bug which when there input some blank space in left,the key is nor correct
*/
macro DefComment(hbuf,wline,func,szfilename)
{
	if(("#ifdef" != func) && ("#ifndef" != func) && ("#if" != func))
	{
		return
	}
	szcmdLine = GetBufLine(hbuf,wline)
	szLeftBlanck = GetBlankSpace(szcmdLine,0)
	szPara = GetPara(szcmdLine)
	DelbufLine(hbuf,wline)

	if("#" == szPara)
	{
		if(0 == strlen(szfilename))
		{
			szPara = ask("input key:")
		}
		else
		{
			szPara = szfilename
		}
	}
	szInsertStr = cat(szLeftBlanck,"@func@ @szPara@")
	InsBufline(hbuf,wline,szInsertStr)
	
	if("#ifndef" == func)
	{
		wline = wline + 1
		InsBufline(hbuf,wline,"#define @szPara@")
	}
	InsBufLine(hbuf,wline+1,"@szLeftBlanck@")
	InsBufline(hbuf,wline+2,"@szLeftBlanck@#endif /*@szPara@*/")
	SetBufIns(hbuf,wline+1,strLen(szLeftBlanck))
}



/**
* @brief
*    make up enum code block automaticly
*
* @author  sharwen
* 
* @param[in]   hbuf  a handle
* @param[in]   wline  function define line number
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/14, create new function
* @li   Sharwen, 2017/2/4 , szkey convert into upper letter string
*/
macro ENUMComment(hbuf,wline)
{
	szcmdLine = GetBufLine(hbuf,wline)
	szLeftBlanck = GetBlankSpace(szcmdLine,0)
	szKey = GetPara(szcmdLine)
	DelbufLine(hbuf,wline)
	
	if("#" == szKey)
	{
		szKey = ask("input key:")
	}

	szInsertStr = cat(szLeftBlanck,"typedef enum @szKey@")
	InsBufLine(hbuf,wline,szInsertStr)
	InsBufLine(hbuf,wline+1,"@szLeftBlanck@{")
	InsBufLine(hbuf,wline+2,"    @szLeftBlanck@")
	szKey = ToUpperLetter(szKey)
	InsBufLine(hbuf,wline+3,"@szLeftBlanck@}ENUM_@szKey@;/*ENUM_@szKey@*/")
	SetBufIns(hbuf,wline+2,strlen(szLeftBlanck) + 4)
}


/**
* @brief
*    convert all letter in a string to small letter
*
* @author  sharwen
* 
* @param[in]   szline  a string need to convert
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/14, create new function
*/
macro ToSmallLetter(szline)
{
	dszLen = strlen(szline)
	if(0 >= dszLen)
	{
		return
	}
	dInx = 0
	iAsc = 0
	cch  = ""
	while(dInx < dszLen)
	{
		iAsc = AsciiFromChar(szline[dInx])
		if(65 <= iAsc && 90 >= iAsc)  /*if this char is a upper case,convert it to a small*/
		{
			szline[dInx] = CharFromAscii(iAsc + 32);
		}
		dInx = dInx + 1;
	}
	return szline
}


/**
* @brief
*    convert all letter in a string to upper letter
*
* @author  sharwen
* 
* @param[in]   szline  a string need to convert
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/14, create new function
*/
macro ToUpperLetter(szline)
{
	dszLen = strlen(szline)
	if(0 >= dszLen)
	{
		return
	}
	dInx = 0
	iAsc = 0
	cch  = ""
	while(dInx < dszLen)
	{
		iAsc = AsciiFromChar(szline[dInx])
		if(97 <= iAsc && 122 >= iAsc)  /*if this char is a small case,convert it to a upper*/
		{
			szline[dInx] = CharFromAscii(iAsc - 32);
		}
		dInx = dInx + 1;
	}
	return szline
}


/**
* @brief
*    copy current line content to clipborad
*
* @author  sharwen
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/14, create new function
*/
macro CopyLnToClipBoard()
{
	hbuf = GetCurrentBuf()
	wLn  = GetBufLnCur(hbuf)
	copyBufLine(hbuf,wln)
}

/**
* @brief
*    get filename such as 1.cpp
*
* @author  sharwen
*
* @param[in]  szline  a sring
*
* @return
*    	a string, szname
* @par  revise
* @li   Sharwen, 2017/1/25, create new function
*/
macro GetFileName(szline)
{
	wLen = strlen(szline)
	szname = ""
	if(0 == wLen)
	{
		return szname
	}
	wLoc = wLen
	while(0 <= wLoc)
	{
		if("\\" == szline[wLoc])
		{
			break;
		}
		wLoc = wLoc - 1
	}
	return strmid(szline,wLoc + 1,wLen)
}


/**
* @brief
*    get filename without suffix string
*
* @author  sharwen
*
* @param[in]  szline  a sring
*
* @return
*    	a string, szname
* @par  revise
* @li   Sharwen, 2017/1/25, create new function
*/
macro GetFileNameNoSuffix(szline)
{
	wLen = strlen(szline)
	szname = ""
	wLoc   = 0
	if(0 == wLen)
	{
		return szname
	}

	szline = GetFileName(szline)
	wLen = strlen(szline)
	if(0 == wLen)
	{
		return szname
	}

	while(wLoc <= wLen)
	{
		if("." == szline[wLoc])
		{
			szname = strmid(szline,0,wLoc)
			break;
		}
		wLoc = wLoc + 1
	}
	return szname
}


/**
* @brief
*    insert head file comment automatically
*
* @author  sharwen
*
* @param[in]   hbuf  buffer handle
* @param[in]   wline line number
*
* @return      wline , return line number after insert coment block
*    	
* @par  revise
* @li   Sharwen, 2017/1/25, create new function
*/
macro HeadComment(hbuf,wline)
{
	szfilename = ""
	szauthor   = GSAutherName(0)
	szdate     = GetCurTime()
	szfullname = GetBufName(hbuf)
	szfilename = GetFileName(szfullname)

	InsBufLine(hbuf,wline,"/**")
	InsBufLine(hbuf,wline + 1,"* \@file  @szfilename@")
	InsBufLine(hbuf,wline + 2,"* \@brief")
	InsBufLine(hbuf,wline + 3,"*     @szfilename@ file's header file")
	InsBufLine(hbuf,wline + 4,"* \@author   @szauthor@")
	InsBufLine(hbuf,wline + 5,"* \@date     @szdate@")
	InsBufLine(hbuf,wline + 6,"* \@version  1.0")
	InsBufLine(hbuf,wline + 7,"* \@note")
	InsBufLine(hbuf,wline + 8,"*")
	InsBufLine(hbuf,wline + 9,"* function list")
	InsBufLine(hbuf,wline + 10,"*")
	InsBufLine(hbuf,wline + 11,"* \@par  revise")
	InsBufLine(hbuf,wline + 12,"* \@li   @szauthor@, @szdate@, create file")
	InsBufLine(hbuf,wline + 13,"*/")
	InsBufLine(hbuf,wline + 14,"")
	
	wline = wline + 14
	return wline
}

/**
* @brief
*    insert head file(.h) comment automatically
*
* @author  sharwen
*
* @param[in]   hbuf  buffer handle
* @param[in]   bNew  bool value, 1 means create new buffer .h file,0 means comment in old .h file
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/25, create new function
*/
macro HeaderFileComment(hbuf,bNew,wline)
{
	hbufn  = hbuf
	szline = GetBufLine(hbuf,wline)
	DelBufLine(hbuf,wline)
	
	if(1 == bNew)
	{
		szfilename = GetLastWord(szline)
		if(strlen(szfilename) == strlen(szline))
		{
			szfilename = ask("please input filename:")
		}
		hbufn = newBuf(szfilename)
		SetCurrentBuf(hbufn)
		wline = 0
	}
	else
	{
		szfullname = GetBufName(hbuf)
		szfilename = GetFileName(szfullname)
	}
	
	wline = HeadComment(hbufn,wline)
	
	InsBufLine(hbufn,wline + 1,"/*----------------------------------------------*")
	InsBufLine(hbufn,wline + 2," *                include                       *")
	InsBufLine(hbufn,wline + 3," *----------------------------------------------*/")
	InsBufLine(hbufn,wline + 4,"")
	wline = wline + 4
	
	InsBufLine(hbufn,wline + 1,"/*----------------------------------------------*")
	InsBufLine(hbufn,wline + 2," *                define                        *")
	InsBufLine(hbufn,wline + 3," *----------------------------------------------*/")
	InsBufLine(hbufn,wline + 4,"")
	wline = wline + 4
	
	InsBufLine(hbufn,wline + 1,"/*----------------------------------------------*")
	InsBufLine(hbufn,wline + 2," *                extern                        *")
	InsBufLine(hbufn,wline + 3," *----------------------------------------------*/")
	InsBufLine(hbufn,wline + 4,"")
	wline = wline + 4
	
	InsBufLine(hbufn,wline + 1,"/*----------------------------------------------*")
	InsBufLine(hbufn,wline + 2," *                global                        *")
	InsBufLine(hbufn,wline + 3," *----------------------------------------------*/")
	InsBufLine(hbufn,wline + 4,"")
	wline = wline + 4
	
	InsBufLine(hbufn,wline + 1,"/*----------------------------------------------*")
	InsBufLine(hbufn,wline + 2," *                function                      *")
	InsBufLine(hbufn,wline + 3," *----------------------------------------------*/")
	InsBufLine(hbufn,wline + 4,"")
	wline = wline + 4

	wline = wline + 1

	InsBufLine(hbufn,wline,"")
	szdefKey   = GetFileNameNoSuffix(szfilename)
	szdefKey = cat("__",szdefKey)
	szdefKey = cat(szdefKey,"__")
	DefComment(hbufn,wline,"#ifndef",szdefKey)

	wline = GetBufLnCur(hbufn)
	InsBufLine(hbufn,wline + 1,"")
	InsBufLine(hbufn,wline + 2,"")
	InsBufLine(hbufn,wline + 3,"")
	InsBufLine(hbufn,wline + 4,"")
	SetBufIns(hbufn,wline + 2,0)

	InsertCPP(hbufn,wline + 2)
}


/**
* @brief
*    insert __cplusplus code block
*
* @author  sharwen
*
* @param[in]   hbuf  buffer handle
* @param[in]   wline line bumber
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/1/25, create new function
*/
macro InsertCPP(hbuf,wline)
{
	DefComment(hbuf,wline,"#ifdef",__cplusplus)

	wline = GetBufLnCur(hbuf)
	DefComment(hbuf,wline,"#if",__cplusplus)
	
	wline = GetBufLnCur(hbuf)
	InsBufLine(hbuf,wline,"extern \"C\"{")
	DelBufLine(hbuf,wline + 1)

	wline = wline + 3
	InsBufLine(hbuf,wline,"")
	InsBufLine(hbuf,wline + 1,"")
	InsBufLine(hbuf,wline + 2,"")
	InsBufLine(hbuf,wline + 3,"")

	wline = wline + 3
	DefComment(hbuf,wline,"#ifdef",__cplusplus)
	
	wline = GetBufLnCur(hbuf)
	DefComment(hbuf,wline,"#if",__cplusplus)
	
	wline = GetBufLnCur(hbuf)
	InsBufLine(hbuf,wline,"}")
	DelBufLine(hbuf,wline + 1)
	SetBufIns(hbuf,wline - 4,0)
}



/**
* @brief
*    insert while code block
*
* @author  sharwen
*
* @param[in]   hbuf  buffer handle
* @param[in]   wline line bumber
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/2/3, create new function
* @li   Sharwen, 2017/2/4, extract get para code into a function
*/
macro InsertWhile(hbuf,wline)
{
	szCmdLine    = GetBufLine(hbuf,wline)
	szBlankSpace = GetBlankSpace(szCmdLine,0)
	szPara = GetPara(szCmdLine)
	delBufLine(hbuf,wline)

	szStr = cat(szBlankSpace,"while( ")
	szStr = cat(szStr,szPara)
	szStr = cat(szStr," )")

	InsBufLine(hbuf,wline,szStr)
	InsertBracket(hbuf,wline + 1,szBlankSpace)

	if(false == bKeyFlag)
	{
		SearchBackward("#")
	}
}



/**
* @brief
*    insert while code block
*
* @author  sharwen
*
* @param[in]   hbuf  buffer handle
* @param[in]   wline line bumber
* @param[in]   szBlankSpace left BlankSpace String
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/2/3, create new function
*/
macro InsertBracket(hbuf,wline,szBlankSpace)
{
	InsBufLine(hbuf,wline,"@szBlankSpace@{")
	InsBufLine(hbuf,wline + 1,"@szBlankSpace@    ")
	InsBufLine(hbuf,wline + 2,"@szBlankSpace@}")
	SetBufIns(hbuf,wline + 1,strlen(szBlankSpace) + 4)
}


/**
* @brief
*    insert revise history comment
*
* @author  sharwen
*
* @param[in]   hbuf  buffer handle
* @param[in]   wline line bumber
*
* @return
*    	
* @par  revise
* @li   Sharwen, 2017/2/3, create new function
*/
macro InsertHistory(hbuf,wline)
{
	szCmdLine    = GetBufLine(hbuf,wline)
	szBlankSpace = GetBlankSpace(szCmdLine,0)
	szPara = GetPara(szCmdLine)
	delBufLine(hbuf,wline)

	if("#" == szPara)
	{
		szPara = ask("please input revise brief")
	}

	szAuthor = GSAutherName(0)
	szTime   = GetCurTime()
	InsBufLine(hbuf,wline,"* \@li   @szAuthor@, @szTime@, @szPara@")
}


/**
* @brief
*    Get para string in a cmd line
*
* @author  sharwen
*
* @param[in]   szCmdLine  a string with command and parameter
*
* @return
*    	szkey , a string
* @par  revise
* @li   Sharwen, 2017/2/4, create new function
*/
macro GetPara(szCmdLine)
{
	szBlankSpace = GetBlankSpace(szCmdLine,0)

	szCmd  = GetCurLncmd(szCmdLine)
	szPara = "#"
	wLenWithoutPara = strlen(szCmd) + strlen(szBlankSpace)
	wLineLen = strlen(szCmdLine)
	
	if(wLenWithoutPara + 1 < wLineLen)/**< aleady input key*/
	{
		szPara = strmid(szCmdLine,wLenWithoutPara + 1,wLineLen)
	}
	return szPara
}
