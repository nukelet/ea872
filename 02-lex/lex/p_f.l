%option noyywrap

%{
    /* we need to track the beginning of a file since the kernel only interprets shebangs if it's the first two bytes of the file */
    #define YY_USER_INIT BEGIN(STARTUP);
%}

%x STARTUP

%% /* discard everything after #, except if it's "$#", "\#" or shebang ("#!") */
<STARTUP>#!.*       { BEGIN(INITIAL); ECHO; } /** don't discard shebangs **/
<STARTUP>.          { BEGIN(INITIAL); yyless(0); } /** yyless(0) rescans the last input string **/
$#|\\#              {ECHO;}
[#].*[\n]           {}
.|\n                {ECHO;}
%%