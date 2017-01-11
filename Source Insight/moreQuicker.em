/**
* @brief
*    source insight expand macro interface
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
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
* @li   123, 2017/1/11, create new function
*/
macro ExpandPorc(Lang)
{
	hbuf = GetCurrentBuf()
	curLnNum = GetBufLnCur(hbuf)
	szline   = GetBufLine(hbuf,curLnNum)
	commond  = GetCurLncmd(szline)
	szlineWhite = GetBlankSpace(szline,0)
	szlineWhiteWhitTab = "@szlineWhite@" # "    "

	if("{" == commond)
	{
		InsBufLine(hbuf,curLnNum+1,"@szlineWhiteWhitTab@")
		InsBufLine(hbuf,curLnNum+2,"@szlineWhite@" # "}")
		SetBufIns (hbuf,curLnNum+1,strlen(szlineWhiteWhitTab))
		return
	}
	if("dfunc" == commond || "df" == commond)
	{
		DFuncComment(hbuf,curLnNum,0)
		return
	}
	if("dfuncdef" == commond || "dfd" == commond)
	{
		DFuncComment(hbuf,curLnNum,1)
		return
	}




	else if("config" == commond || "conf" == commond)
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
* @li   123, 2017/1/11, create new function
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
    chTab = CharFromAscii(9)
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
* @li   123, 2017/1/11, create new function
*/
macro GetCurLncmd(szline)
{
	cmd = strTrim(szline)
	return cmd;
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
* @li   123, 2017/1/11, create new function
*/
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
* @li   123, 2017/1/11, create new function
*/
macro GSAutherEMail(setFlag)
{
	strEMail = getreg(AutherEMail)
	if(0 == strlen(strEMail) || 1==setFlag)
	{
		strEMail = Ask("Please enter your name:")
		setreg(AutherEMail,strEMail);
	}
	return strEMail
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
* @li   123, 2017/1/11, create new function
*/
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


/**
* @brief
*    reset the author name and email,reset the language enviroment
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
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
* @li   123, 2017/1/11, create new function
*/
macro delCurLine()
{
	hbuf = GetCurrentBuf()
	curLnNum = GetBufLnCur(hbuf)
	DelBufLine(hbuf,curLnNum)
}



/**
* @brief
*    add C++ style comment in line(comment line)
*
* @author  sharwen
* 
* @param   hbuf   handle buffer
* @param   line   ln in handle buffer
* @param   PreFlag   bool value,if it not equal 0, "/*" will be added in front of a line
* @param   LastFlag  bool value,if it not equal 0, "*" and "/" will be added in front of a line together
*
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
*/
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


/**
* @brief
*    add C++ style comment in selected block
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
*/
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


/**
* @brief
*    delete C++ style comment in selected block
*
* @author  sharwen
* 
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
*/
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


/**
* @brief
*    delete C++ style comment in line
*
* @author  sharwen
* 
* @param   hbuf   handle buffer
* @param   line   ln in handle buffer
*
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
*/
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


/**
* @brief
*    get rid of blankspace in front of a string
*
* @author  sharwen
* 
* @param   szline   a string
*
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
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
* @param   szline   a string
*
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
*/
macro strTrimRight(szline)
{
	ichFrist = 0
    ichLast  = strlen(szline) -1 
    if(0 > ichLast)
    {
    	return ""
    }
	chBlank = CharFromAscii(32)
    chTab   = CharFromAscii(9)
	while(ichLast > ichFrist)
    {
    	if((chBlank != szline[ichLast]) && (chTab != szline[ichLast]))
    	{
    		break
    	}
    	ichLast = ichLast - 1
    }
    if(0 > ichLast)
	{
		return ""
	}
    return strmid(szline,ichFrist,ichLast+1)
}


/**
* @brief
*    get rid of blankspace both begin and end
*
* @author  sharwen
* 
* @param   szline   a string
*
* @return
*    
* @par  revise
* @li   123, 2017/1/11, create new function
*/
macro strTrim(szline)
{
	strLeft = strTrimLeft(szline)
	str     = strTrimRight(strLeft)
	return str;
}


/**
* @brief
*    get rid of comment both begin and end
*
* @author  sharwen
* 
* @param   szline   a string
*
* @return
*    	string
* @par  revise
* @li   123, 2017/1/11, create new function
*/
macro GetLineWithoutComment(szline)
{	
	RetStr = ""
	if(0 == strlen(szline))
	{
		return RetStr;
	}
	szline = strTrim(szline)
	fInx = 0;
	lInx = strlen(szline)
	/*skip comment block*/
	if(fInx >= 1)
	{
		if("/" == szline[fInx] && "*" == szline[fInx+1])
		{
			while(fInx < lInx - 1)
			{
				if("*" == szline[fInx] && "/" == szline[fInx+1])
				{
					fInx = fInx + 2;
					break;
				}
				fInx = fInx + 1;
			}
		}
	}
	if(lInx >= 2)
	{
		if("*" == szline[lInx-2] && "/" == szline[lInx-1])
		{
			while(0 < lInx - 2)
			{
				if("/" == szline[lInx-2] && "*" == szline[lInx-1])
				{
					lInx = lInx - 3;
					break;
				}
				lInx = lInx - 1;
			}
		}
	}
	if(fInx <= lInx)
	{
		return strmid(szline,fInx,lInx);
	}
	return RetStr;
}



/**
* @brief
*    get last word from a string
*
* @author  sharwen
* 
* @param   szline   a string
*
* @return
*    	string
* @par  revise
* @li   123, 2017/1/11, create new function
*/
macro GetLastKey(szline)
{
	ichLast  = strlen(szline)
	ichFrist = ichLast - 1
	if(0 == ichLast)
	{
		return ""
	}
	chBlack = CharFromAscii(32)
    chTab   = CharFromAscii(9)
    
	while(0 <= ichFrist)
	{
		if(chBlack == szline[ichFrist] || chTab == szline[ichFrist])
		{
			break;
		}
		ichFrist = ichFrist - 1
	}

	return strmid(szline,ichFrist+1,ichLast)
}


/**
* @brief
*    spilit words from string
*
* @author  sharwen
* 
* @param   szline   a string
* @param   hbuf     a handle buffer
* @param   chBegin  a char in line,and need spilt starts here
* @param   separater  separater char
* @param   chEnd    a char in line,and need spilt ends here
*
* @return
*    	
* @par  revise
* @li   123, 2017/1/11, create new function
*/
macro SplitString(szline,hbuf,chBegin,separater,chEnd)
{
	ichFrist = 0;
	ichLast  = strlen(szline)
	if(0 == ichLast)
	{
		return ""
	}

	while(ichFrist < ichLast)/**< locate the begion of string*/
	{
		if(chBegin == szline[ichFrist])
		{
			break;
		}
		ichFrist = ichFrist + 1
	}
	ichFrist = ichFrist + 1

	while(ichFrist < ichLast)/**< locate the end of string*/
	{
		if(chEnd == szline[ichLast])
		{
			break;
		}
		ichLast = ichLast - 1
	}
	
	while(ichFrist < ichLast)/**<extract para list from string*/
	{
		tmpInx = ichFrist
		while((separater != szline[tmpInx]) && (tmpInx < ichLast))
		{
			tmpInx = tmpInx + 1
		}
		
		if(ichFrist == tmpInx) /**<avoid continuous separater*/
		
{
			ichFrist = ichFrist + 1
			continue
		}
		word = strmid(szline,ichFrist,tmpInx)
		word = strTrim(word)

		if("void" != word && "VOID" != word && nil != word)
		{
			AppendBufLine(hbuf,word)
		}
		ichFrist = tmpInx + 1
	}
}


/**
* @brief
*    spilit words from string
*
* @author  sharwen
* 
* @param   hbuf     a handle buffer
* @param   FuncListBuf  a handle buf,it include function para list when it excute finish
* @param   symbol  use GetCurSymbol function get
*
* @return
*    	
* @par  revise
* @li   123, 2017/1/11, create new function
*/
macro GetFuncParaList(hbuf,FuncListBuf,symbol)
{
	funcDef = ""
	lnFrist = symbol.lnFirst
	lnLast  = symbol.lnLim
	while(lnFrist < lnLast)/**< get define of a function*/
	{
		szline  = GetBufLine(hbuf,lnFrist)
		line    = GetLineWithoutComment(szline)  /**< Get rid of Comment block in one line*/
		line    = strTrim(line)				     /**< Get rid of BlackSpace block in one line*/
		LInx    = strlen(line) - 1
		funcDef = cat(funcDef,line)
		lnFrist = LnFrist + 1
		if(0 > LInx)
		{
			LInx = 0
		}
		if("{" == line[0] || "{" == line[LInx] || ";" == line[0] || ";" == line[LInx])/*function define finished*/
		{
			ichLast = strlen(funcDef)
			funcDef = strmid(funcDef,0,ichLast-1)
			break;
		}
	}
	SplitString(funcDef,FuncListBuf,"(",",",")")
}


/**
* @brief
*    SearchForward word
*
* @author  sharwen
* 
* @param   word  word need to search
*
* @return
*    	
* @par  revise
* @li   123, 2017/1/11, create new function
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
* @param   word  word need to search
*
* @return
*    	
* @par  revise
* @li   123, 2017/1/11, create new function
*/
macro SearchBackward()
{
    LoadSearchPattern("#", 1, 0, 1);
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
* @li   123, 2017/1/11, create new function
*/
macro GetCurTime()
{	
	CurTime = GetSystime(1)
	year   = CurTime.year
	month  = CurTime.month
	day    = CurTime.day
	Retval = "@year@/@month@/@day@"
	return Retval
}


/**
* @brief
*    comment a function
*
* @author  sharwen
* 
* @param   hbuf  a handle
* @param   line  function define line number
* @param   booldef  boo value ,when it equal 1,function defination;0,function realizaton
*
* @return
*    	
* @par  revise
* @li   123, 2017/1/11, create new function
*/
macro DFuncComment(hbuf,line,booldef)
{
	if(0 != booldef && 1 != booldef)
	{
		return
	}
	DelBufline(hbuf,line)      /**<delete current line*/
	symbol = GetCurSymbol()
	brief  = ask("please intput brief of this function:")
	brief  = cat("*    ",brief)
	author = GSAutherName(0)
	paraNum = 0
	FuncListBuf = hnil
	if(0 != strlen(symbol))
	{
		FuncListBuf = NewBuf("__FuncListBuf__")   /*use a temp buf to save para list*/
	    if(hNil == FuncListBuf)
	    {
	        stop
	    }
		symbol = GetSymbolLocationFromLn(hbuf, line)
		GetFuncParaList(hbuf,FuncListBuf,symbol)
		paraNum = GetbufLineCount(FuncListBuf)
	}
	
	InsBufLine(hbuf,line,"/**")
	InsBufLine(hbuf,line+1,"* \@brief")
	InsBufLine(hbuf,line+2,brief)
	InsBufLine(hbuf,line+3,"*")
	InsBufLine(hbuf,line+4,"* \@author  @author@")
	InsBufLine(hbuf,line+5,"*")
	newLine = line + 6
	InsParaListLn = newline
	if(0 != strlen(symbol))
	{
		Inx = 0
		while(Inx < paraNum)
		{
			szline = GetBufLine(FuncListBuf,Inx)
			key    = GetLastKey(szline)
			InsBufLine(hbuf,newline + Inx,"* \@param   @key@")
			Inx = Inx + 1
		}
		newline = newline + Inx
		closeBuf(FuncListBuf)
	}

	StrCurtime = GetCurTime()
	InsBufLine(hbuf,newline,"*")
	InsBufLine(hbuf,newline+1,"* \@return")
	InsBufLine(hbuf,newline+2,"*    ")
	InsBufLine(hbuf,newline+3,"* \@par  revise")
	InsBufLine(hbuf,newline+4,"* \@li   @author@, @StrCurtime@, create new function")
	InsBufLine(hbuf,newline+5,"*/")
	newline = newline + 6

	if(0 == strlen(symbol))  /**<new function*/
	{
		retType = ask("please input return type:")
		func    = ask("please input function name:")
		if(0 < strlen(func))
		{
			if(0 == booldef)  /**<new function realization*/
			{
				InsBufline(hbuf,newline,"@retType@ @func@( # )")
				InsBufline(hbuf,newline + 1,"{")
				InsBufline(hbuf,newline + 2,"    ")
				InsBufline(hbuf,newline + 3,"}")
				newline = newline + 3
				rightbracket = ")"
			}
			else   /**<new function define*/
			{
				InsBufline(hbuf,newline,"@retType@ @func@( # );")
				newline = newline + 1
				rightbracket = ");"
			}
			SearchForward("#")

			frist_time = 1
			curBufLn   = GetBufLnCur(hbuf)
			while(true)
			{
				
				szline   = GetBufLine(hbuf,curBufLn)
				szlnLen  = strlen(szline)
				if(0 == frist_time)
				{
					szline = strmid(szline,0,szlnLen - booldef -1)
					szline = cat(szline,", ")
				}
				else
				{
					szline = strmid(szline,0,szlnLen - booldef - 3)
					frist_time = 0
				}

				
				newParam = ask("please intput paraName:")
				newParam = strTrim(newParam)
				szline   = cat(szline,"@newParam@")
				szline   = cat(szline,rightbracket)
				putBufLine(hbuf,curBufLn,szline)
				InsBufLine(hbuf,InsParaListLn,"* \@param   @newParam@")
				InsParaListLn = InsParaListLn + 1
				curBufLn = curBufLn + 1
			}
			
		}
	}
	
}
