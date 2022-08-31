%{
char *unidades[]={"primeiro","um","dois","tres","quatro","cinco",
               "seis", "sete","oito","nove"};
char *interm[]={"dez","onze","doze","treze",
                 "quatorze","quinze","dezesseis",
                 "dezessete","dezoito","dezenove"};
char *dezenas[]={"vinte","trinta","quarenta","cinquenta",
                 "sessenta","setenta","oitenta","noventa"};
char *meses[]={"janeiro","fevereiro","marco","abril","maio",
               "junho","julho","agosto","setembro",
               "outubro","novembro","dezembro"};

char* get_dd_str(int dd);
char* get_yy_str(int yy);
void print_formatted_date(char *str);
%}

DateFormat  [0-9][0-9][/][0-9][0-9][/][0-9][0-9]([0-9][0-9])?

%%

{DateFormat}      { print_formatted_date(yytext); }
.                 { ECHO; }

%%

void print_formatted_date(char *str)
{
    // change occurrences of '/' into '\0'
    str[2] = str[5] = '\0';
    int dd = atoi(str);
    int mm = atoi(str + 3);
    int yy = atoi(str + 6);

    int error = 0;

    char *dd_str, *mm_str, *yy_str;
    
    printf("%s de %s de %s",
            get_dd_str(dd),
            meses[mm-1],
            get_yy_str(yy));

}

// gets string for a two digit number
char* get_dd_str(int dd)
{
    static char buf[32] = {0};
    buf[0] = '\0';
    char *dd_str;
    if (dd == 1) {
        dd_str = unidades[0];   // "primeiro"
    } else if (2 <= dd && dd <= 9) {
        dd_str = unidades[dd];
    } else if (10 <= dd && dd <= 19) {
        dd_str = interm[dd-10];
    } else {
        int idx = (dd - 20)/10; // calcula posicao no vetor dezenas
        strncat(buf, dezenas[idx], sizeof(buf));
        idx = dd - ((dd/10)*10); // calcula unidade (e posicao no vetor)
        if (idx > 0) {
            strncat(buf, " e ", sizeof(buf));
            strncat(buf, unidades[idx], sizeof(buf));
        }
        dd_str = buf;
    }

    return dd_str;
}

// ugly hack that only supports dates after 2001
char *get_yy_str(int yy) {
    static char buf[32] = {0};
    buf[0] = '\0';
    yy %= 100;
    strncat(buf, "dois mil e ", sizeof(buf));
    strncat(buf, get_dd_str(yy), sizeof(buf));
    return buf;
}
