%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node {
    const char *value;
    struct node *left;
    struct node *right;
} node;

struct node *nval;

node* create_node(const char *value, node *left, node *right) {
    node *new_node = (node *)malloc(sizeof(node));
    new_node->value = strdup(value);  // Garantir que a string seja copiada
    new_node->left = left;
    new_node->right = right;
    return new_node;
}

void print_tree(node *root, int level) {
    if (root == NULL)
        return;

    // Adiciona indentação proporcional ao nível do nó
    for (int i = 0; i < level; i++)
        printf("    ");

    // Imprime o valor do nó
    printf("|-- %s\n", root->value);

    // Chama recursivamente para os filhos esquerdo e direito
    print_tree(root->left, level + 1);
    print_tree(root->right, level + 1);
}

void yyerror(const char *s);
int yylex();

%}

%union {
    char *sval;
    struct node *nval;
    int ival;
}

%token VAR PRINT IDENTIFIER NUMBER
%token EQUALS SEMICOLON PLUS MINUS TIMES DIVIDE

%left PLUS MINUS
%left TIMES DIVIDE

%type <nval> program statements statement declaration assignment print expression
%type <sval> IDENTIFIER
%type <ival> NUMBER

%%

program:
    statements { nval = $1; }
;

statements:
    statement SEMICOLON statements {
        $$ = create_node("statements", $1, $3);
    }
    | statement SEMICOLON {
        $$ = $1;
    }
;

statement:
    declaration { $$ = $1; }
    | assignment { $$ = $1; }
    | print { $$ = $1; }
;

declaration:
    VAR IDENTIFIER EQUALS expression {
        $$ = create_node("declaration", create_node($2, $4, NULL), NULL);
    }
;

assignment:
    IDENTIFIER EQUALS expression {
        $$ = create_node("assignment", create_node($1, $3, NULL), NULL);
    }
;

print:
    PRINT IDENTIFIER {
        $$ = create_node("print", create_node($2, NULL, NULL), NULL);
    }
;

expression:
    NUMBER { $$ = create_node("number", NULL, NULL); }
    | IDENTIFIER { $$ = create_node("identifier", NULL, NULL); }
    | expression PLUS expression {
        $$ = create_node("plus", $1, $3);
    }
    | expression MINUS expression {
        $$ = create_node("minus", $1, $3);
    }
    | expression TIMES expression {
        $$ = create_node("times", $1, $3);
    }
    | expression DIVIDE expression {
        $$ = create_node("divide", $1, $3);
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main() {
    yyparse();    
    print_tree(nval, 0);
    return 0;
}