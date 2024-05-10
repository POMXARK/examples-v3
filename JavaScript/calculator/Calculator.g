grammar Calculator;
options {language=JavaScript;}

prog:   stat+ ; // Infinite number of expressions
                
stat:   expr NEWLINE {Calculator.log($expr.value);} // Possible expressions
    |   ID '=' expr NEWLINE // Assigning a value to a variable.
        {this.memory[$ID.text] = $expr.value;} // Rules for converting to the language in use
    |   NEWLINE // List of valid end-of-expression characters
    ;

expr returns [value]
    :   e=multExpr {$value = $e.value;}
        (   '+' e=multExpr {$value += $e.value;}
        |   '-' e=multExpr {$value -= $e.value;}
        )*
    ;

multExpr returns [value]
    :   e=atom {$value = $e.value;} (
    '*' e=atom {$value *= $e.value;}
    | ('/' | ':' ) e=atom {$value /= $e.value;}
    )*
    ;

atom returns [value] // Options for possible characters. Mapping to data type. lexemes. words of formal language
    :   INT {$value = parseInt($INT.text,10);}
    |   DECIMAL {$value = parseFloat($DECIMAL.text);}
    |   ID
        {
        var v = this.memory[$ID.text];
        if ( org.antlr.lang.isNumber(v) ) $value = v;
        else Calculator.logError("undefined variable "+$ID.text);
        }
    |   '(' expr ')' {$value = $expr.value;}
    ;

// Token, in computer science, is a sequence of valid characters in a programming language. formal language letters

ID  :   ('a'..'z'|'A'..'Z')+ ; // Assigning a value to a variable. Only Latin letters are allowed
DECIMAL: INT+ '.' INT+; // to recognize a word of real type
INT: '0'..'9'+; // Specifies the data type: numbers only
NEWLINE:'\r'? '\n' | ';' ; // List of valid end-of-expression characters
WS  :   (' '|'\t')+ {this.skip();} ;
