%option noyywrap nodefault yylineno
%x COMMENT
%x SINGLELINECOMMENT

UCN (\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})
ILEN ([Uu](L|l|LL|ll)?|(L|l|LL|ll)[Uu]?)

%{
#include <string>

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "parser.hpp"
// #include "ast.h"

union yystype {
  int token;
  std::string* string;
};
#define YYSTYPE union yystype
YYSTYPE yylval;

/*
 * 当lex每识别出一个记号后，是通过变量yylval向yacc传递数据的。默认情况下yylval是int类型，也就是只能传递整型数据。
 * yylval是用YYSTYPE宏定义的，只要重定义YYSTYPE宏，就能重新指定yylval的类型(可参见yacc自动生成的头文件yacc.tab.h)。
 * 在我们的例子里，当识别出标识符后要向yacc传递这个标识符串，yylval定义成整型不太方便
 * (要先强制转换成整型，yacc里再转换回char*)。这里把YYSTYPE重定义为struct Type，可存放多种信息
 */

/* 通常这里面每个成员，每次只会使用其中一个，一般是定义成union以节省空间(但这里用了string等复杂类型造成不可以) */

#define SAVE_TOKEN  yylval.string = new std::string(yytext, yyleng)

int cal8(char *s);
int cal10(char *s);
int cal16(char *s);

%}

%%

"/*"		{BEGIN(COMMENT);}
<COMMENT>"*/"  {BEGIN(INITIAL);}
<COMMENT>([^*]|\n)+|.
<COMMENT><<EOF>>   {printf("Unterminated comment\n"); return 0;}
"//" {BEGIN(SINGLELINECOMMENT);}
<SINGLELINECOMMENT>.*
<SINGLELINECOMMENT>\n {BEGIN(INITIAL);}
<SINGLELINECOMMENT><<EOF>> {BEGIN(INITIAL);}


int 		{ yylval.token = INT; return INT; }
void 		{ yylval.token = VOID; return VOID; }
			 
const 		{ yylval.token = CONST; return CONST; }
			  
break		{ yylval.token = BREAK; return BREAK; }
continue	{ yylval.token = CONTINUE; return CONTINUE; }
if			{ yylval.token = IF; return IF; }
else 		{ yylval.token = ELSE; return ELSE; }
return		{ yylval.token = RETURN; return RETURN; }
while		{ yylval.token = WHILE; return WHILE; }
			  
"starttime"[ \t\n]*"("      { yylval.string = new std::string("_sysy_starttime"); *yy_cp = yy_hold_char; yy_hold_char='(';yy_cp--; yyleng--; yy_c_buf_p--; *yy_c_buf_p='_';yy_c_buf_p--; *yy_c_buf_p='_'; yy_c_buf_p--; *yy_c_buf_p='E';yy_c_buf_p--; *yy_c_buf_p='N'; yy_c_buf_p--; *yy_c_buf_p='I';yy_c_buf_p--; *yy_c_buf_p='L'; yy_c_buf_p--; *yy_c_buf_p='_';yy_c_buf_p--; *yy_c_buf_p='_'; yy_c_buf_p--; return IDENT; }

"stoptime"[ \t\n]*"("       { yylval.string = new std::string("_sysy_stoptime"); *yy_cp = yy_hold_char; yy_hold_char='(';yy_cp--; yyleng--; yy_c_buf_p--; *yy_c_buf_p='_';yy_c_buf_p--; *yy_c_buf_p='_'; yy_c_buf_p--; *yy_c_buf_p='E';yy_c_buf_p--; *yy_c_buf_p='N'; yy_c_buf_p--; *yy_c_buf_p='I';yy_c_buf_p--; *yy_c_buf_p='L'; yy_c_buf_p--; *yy_c_buf_p='_';yy_c_buf_p--; *yy_c_buf_p='_'; yy_c_buf_p--; return IDENT; }

"__LINE__"  { yylval.string = new std::string(std::to_string(yyget_lineno())); yylval.token = yyget_lineno(); return NUMBER; }
"_SYSY_N"   { yylval.string = new std::string(std::to_string(1024)); yylval.token = 1024; return NUMBER; }

"+"			{ yylval.token = ADD; return ADD; }
"-"			{ yylval.token = SUB; return SUB; }
"*"			{ yylval.token = MUL; return MUL; }
"/"			{ yylval.token = DIV; return DIV; }
"%"			{ yylval.token = MOD; return MOD; }
"="			{ yylval.token = ASSIGN; return ASSIGN; }
"=="		{ yylval.token = EQ; return EQ; }
"!="		{ yylval.token = NE; return NE; }
"<"			{ yylval.token = LT; return LT; }
">"			{ yylval.token = GT; return GT; }
"<="		{ yylval.token = LE; return LE; }
">="		{ yylval.token = GE; return GE; }
"!"			{ yylval.token = NOT; return NOT; }
"&&"		{ yylval.token = AND; return AND; }
"||"		{ yylval.token = OR; return OR; }
"["			{ yylval.token = LSQUARE; return LSQUARE; }
"]"			{ yylval.token = RSQUARE; return RSQUARE; }
"("			{ yylval.token = LPAREN; return LPAREN; }
")"			{ yylval.token = RPAREN; return RPAREN; }
"{"			{ yylval.token = LBRACE; return LBRACE; }
"}"			{ yylval.token = RBRACE; return RBRACE; }
","			{ yylval.token = COMMA; return COMMA; }
";"			{ yylval.token = SEMI; return SEMI; }

0[0-7]*{ILEN}?				{ yylval.token = cal8(yytext); return NUMBER; }
[1-9][0-9]*{ILEN}?			{ yylval.token = cal10(yytext); return NUMBER; }
0[Xx][0-9a-fA-F]+{ILEN}?	{ yylval.token = cal16(yytext); return NUMBER; }

([_a-zA-Z]|{UCN})([_a-zA-Z0-9]|{UCN})* { SAVE_TOKEN; return IDENT; }

[ \t\n\r]+ 	{ /*忽略空白符*/ }
.   { printf("mystery chacators in %d lines: %d\n", yylineno, atoi(yytext));}

%%

int cal10(char *s)
{
    int ans=0,len=strlen(s);
    for(int i=0;i<len;i++)ans=ans*10+(s[i]^48);
    return ans;
}

int cal8(char *s)
{
    int ans=0,len=strlen(s);
    for(int i=1;i<len;i++)ans=ans*8+(s[i]^48);
    return ans;
}

int cal16(char *s)
{
    int ans=0,len=strlen(s);
    for(int i=2;i<len;i++)
    {
        if(s[i]<'A')ans=ans*16+(s[i]^48);
        else if(s[i]<'Z')ans=ans*16+10+(s[i]-'A');
        else ans=ans*16+10+(s[i]-'a');
    }
    return ans;
}