macro AutoExpand()
{
	hwnd = GetCurrentWnd()
	if(0 == hwnd)
		stop
	sel = GetWndSel(hwnd)/*��ȡ��ǰ��ѡ�п� ���ߵ�ǰ��*/
	GSAutherName(0)
	GSAutherEMail(0)
	if(sel.lnfirst != sel.lnLast)/*���п�*/
	{
		CommandProc()/*�����*/
	}
	if(0 == sel.ichFirst)/*��ǰ��û���ַ���������*/
	{
		stop
	}
	/*��ǰ�����ַ�����*/

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
		while("0" != strLang || "1" != strLang)
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