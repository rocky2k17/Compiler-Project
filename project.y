%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include<math.h>
	int yylex(void);
	int sym[26],store[26];
%}

/*Bison Declaretion*/

%union { 
  int v;
  double d;   
}

%token<v>NUM
%token<d>var
%type<v>statement
%type<v>expression

%token IF ELSE BS BE floop wloop SWITCH CASE DEFAULT major print INT CHAR FLOAT array var odd_even factorial class function SIN COS LOG TAN
%nonassoc IF
%nonassoc ELSE
%nonassoc floop
%nonassoc wloop
%left '<' '>'
%left '+' '-'
%left '*' '/'
%left SIN COS  TAN LOG
%left '%'
%left '^'



/*Grammar rules*/

%%

program: major'(' ')' BS lines BE {printf("\n Main Function \n");}
	 ;

lines:
	|lines statement
	|declaration	{printf("\n Declaration\n");}
	;


declaration: type id1   {printf("\nvariable Declaration\n");}
	    ;

type:  INT   {printf("interger declaration\n");}
     | FLOAT  {printf("float declaration\n");}
     | CHAR   {printf("char declaration\n");}
     ;

id1 : id1 ',' var  {
			int x=$3;
			if(store[x] == 1)
			{
				printf("%c reallocate\n", $3 + 97);
			}
			else
			{
				store[x] = 1;
			}
			}
    |var	{
			int x=$1;
			if(store[x] == 1)
			{
				printf("%c reallocate\n", $1 + 97);
			}
			else
			{
				store[x] = 1;
			}
			} 
    ;

statement: ';'

	| expression ';'		{printf("\nValue of expression: %d\n",$1);$$=$1;}
	
	| var'='expression ';'	{
					printf("\nValue of the variable: %d\n",$3);
					int x=$1;
					sym[x]=$3;
					$$=$3;
				}
	|floop '(' NUM ',' NUM ',' NUM ')' BS  statement BE {
	                                int i;
	                                printf("FOR Loop execution");
	                                for(i=$3 ; i<$5 ; i=i+$7 )
					{printf("\nvalue of the  i: %d expression value : %d\n", i,$10);}
					}

	|wloop '(' NUM '<' NUM ')' BS statement BE  {
	                                int i;
	                                printf("WHILE Loop execution");
	                                for(i=$3 ; i<$5 ; i++) {printf("\nvalue of the loop: %d expression value: %d\n", i,$8);}
					}
	
	| IF '(' expression ')' BS statement BE{
						if($3){
							printf("\nvalue of expression in IF: %d\n",$6);
						}
						else{
							printf("\ncondition value zero in IF block\n");
						}
						}
	
	| IF '(' expression ')' BS statement BE ELSE BS statement BE{
								if($3){
									printf("value of expression in IF: %d\n",$6);
								}
								else{
									printf("value of expression in ELSE: %d\n",$10);
								}
								}

	| print '(' expression ')' ';' {printf("\nPrint Expression %d\n",$3);}

	| factorial '(' NUM ')' ';' {
		printf("\nFACTORIAL declaration\n");
		int i;
		int f=1;
		for(i=1;i<=$3;i++)
		{
			f=f*i;
		}
		printf("FACTORIAL of %d is : %d\n",$3,f);
		}
	
	| odd_even '(' NUM ')' ';' {
		printf("Determining odd or even number \n");

		if($3 %2 ==0){
			printf("Number : %d is -> Even\n",$3);
		}
		else{
			printf("Number is :%d is -> Odd\n",$3);
		}
		}

	| function var '(' expression ')' BS statement BE {
		printf("FUNCTION found :  \n");
		printf("Function Parameter : %d\n",$4);
		printf("Function internal block statement : %d\n",$7);
		}

	| array type var '(' NUM ')' ';' {
		printf("ARRAY Declaration\n");

		printf("Size of the ARRAY is : %d\n",$5);
		}
	| SWITCH '(' NUM ')' BS  cases BE {
		printf("\nSWITCH CASE Declaration\n");
		printf("\nFinally Choose Case number :-> %d\n",$3);
		}
	| class var  BS statement BE {

		printf("Class Declaration\n");
		printf("Expression : %d\n",$4);
		}

	| class var ':' var  BS statement BE {

		printf("Inheritance occur \n");
		printf("Expression value : %d",$6);
		}
	
	;


cases: casegrammar
 			|casegrammar defaultgrammar
 			;

 casegrammar: 
 			| casegrammar casenumber
 			;

 casenumber: CASE NUM ':' expression ';' {printf("Case No : %d & expression value :%d \n",$2,$4);}
 			;
 defaultgrammar: DEFAULT ':' expression ';' {
 				printf("\nDefault CASE & expression value : %d",$3);
 			}
 		;

 expression: NUM		{ printf("\nNumber :  %d\n",$1 ); $$ = $1;  }

	| var			{ int x=$1;$$ = sym[x]; }

	| expression '+' expression	{printf("\nAddition :%d+%d = %d \n",$1,$3,$1+$3 );  $$ = $1 + $3;}

	| expression '-' expression	{printf("\nSubtraction :%d-%d=%d \n ",$1,$3,$1-$3); $$ = $1 - $3; }

	| expression '*' expression	{printf("\nMultiplication :%d*%d \n ",$1,$3,$1*$3); $$ = $1 * $3; }

	| expression '/' expression	{ if($3){
				     		printf("\nDivision :%d/%d \n ",$1,$3,$1/$3);
						$$ = $1 / $3;

				  		}
				  	else{
						$$ = 0;
						printf("\ndivision by zero\n\t");
					} 	
				    			}
	| expression '%' expression	{ if($3){
				     		printf("\nMod :%d % %d \n",$1,$3,$1 % $3);
				     		$$ = $1 % $3;

				  		}
				  	  else{
						$$ = 0;
						printf("\nMOD by zero\n");
				  		} 	
				    			}
	| expression '^' expression	{printf("\nPower  :%d ^ %d \n",$1,$3,$1 ^ $3);  $$ = pow($1 , $3);}
	| expression '<' expression	{printf("\nLess Than :%d < %d \n",$1,$3,$1 < $3); $$ = $1 < $3 ; }

	| expression '>' expression	{printf("\nGreater than :%d > %d \n ",$1,$3,$1 > $3); $$ = $1 > $3; }
	

	| SIN expression 			{printf("\nValue of Sin(%d) is : %lf\n",$2,sin($2*3.1416/180)); $$=sin($2*3.1416/180);}

    	| COS expression 			{printf("\nValue of Cos(%d) is : %lf\n",$2,cos($2*3.1416/180)); $$=cos($2*3.1416/180);}

	| TAN expression			{printf("\nValue of Tan(%d) is : %lf\n",$2,tan($2*3.1416/180)); $$=tan($2*3.1416/180);}

	| LOG expression 			{printf("\nValue of Log(%d) is : %lf\n",$2,(log($2))); $$=(log($2));}

	;
%%


int yywrap()
{
	return 1;
}

int  yyerror(char *s){
	printf( "%s\n", s);
}

int main()
{
	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();
}