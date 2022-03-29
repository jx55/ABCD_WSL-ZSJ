#include <iostream>

#include <cstdio>

extern int yylex();

int main(int argc, char **argv) {
  const char* sFile="file.txt";//打开要读取的文本文件
  FILE* fp=fopen(sFile, "r");
  extern FILE* yyin;    //yyin和yyout都是FILE*类型
  yyin=fp;//yacc会从yyin读取输入，yyin默认是标准输入，这里改为磁盘文件。yacc默认向yyout输出，可修改yyout改变输出目的

  printf("-----begin parsing %s\n", sFile);
  for (int i = 0; i < 23; i++)
  {
    printf("%d\n", yylex());
  }
  printf("-----end parsing\n");

  fclose(fp);
  return 0;
}