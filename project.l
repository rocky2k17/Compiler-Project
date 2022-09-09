%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include "project.tab.h"
	extern int yyval;
	
%}


variable [a-zA-Z]*
digit [0-9]
header		"import ".*
Comment		[!].*

%%

"IF" 			{return IF;   }
"ELSE" 		   	{return ELSE; }
"{" 		   	{return BS;  }
"}"  		   	{return BE;	}
"FOR" 		   	{return floop;}
"WHILE"		   	{return wloop;}
"SWITCH" 		{return SWITCH;}
"CASE" 			{return CASE;}
"DEFAULT" 		{return DEFAULT;}
"major_function"	{printf("\nMain Function Start\n"); return major; }

"PRINTFUNCTION" 	{return print; } 
"INTEGER"  		{return INT;}
"CHAR" 		     {return CHAR;}
"FLOAT"			 {return FLOAT;}
"ARRAY"			{return array;}

"ODDEVEN"		{return odd_even;}
"FACTORIAL"		{return factorial;}



"CLASS"			{printf("New Class  Name : ");ECHO; return class;}
"FUNCTION"		{ECHO; return function;}
"SIN"		   {return SIN;}
"COS"          {return COS;}
"LOG"		{return LOG;}
"TAN"          {return TAN;}

{digit}+		{yylval.v = atoi(yytext); return NUM; }
{variable}	    {ECHO;printf("\n"); yylval.d = *yytext - 'a'; return	var; }
{Comment}		{printf("\nSingle line Comment found :: ");ECHO;printf("\n");}
{header}  				{printf("\nHeader file found :\n");ECHO;printf("\n");}
[-+/*<>=,():;%^]     {return *yytext;	}


[ ]*	    			{}
[\n]*				{}
[\t]*					{}
.						{printf("\nUnknown Syntax : %s\n",yytext);}


%%

