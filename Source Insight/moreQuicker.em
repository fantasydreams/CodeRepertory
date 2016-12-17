macro AutoExpand()
{
	hwnd = GetCurrentWnd()
	if(0 == hwnd)
		stop
	sel = GetWndSel(hwnd)/*获取当前被选中块 或者当前行*/
	GSAutherName(0)
	GSAutherEMail(0)
	if(sel.lnfirst != sel.lnLast)/*多行块*/
	{
		CommandProc()/*命令处理*/
	}
	if(0 == sel.ichFirst)/*当前行没有字符或者内容*/
	{
		stop
	}
	/*当前行有字符命令*/

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
		while("0" != strLang || "1" != strLang)
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