grammar gr;

options{
    language=Java;
}


//The following code is so that any unknown characters result in printing of an error statement and continuing.
@lexer::members{
  private java.util.Queue<Token> queue = new java.util.LinkedList<Token>();
  public int lexGetLine(){
    return getLine();
  }
  @Override
  public Token nextToken() {

    if(!queue.isEmpty()) {
      return queue.poll();
    }


    Token next = super.nextToken();

    while(next.getType()==WhiteSpace){

    }
    if(next.getType() != Unknown) {
      return next;
    }

    StringBuilder builder = new StringBuilder();

    while(next.getType() == Unknown) {
      next = super.nextToken();
    }


    queue.offer(next);

    return new CommonToken(Unknown, builder.toString());
  }
}

@parser:: imports{
import java.io.FileWriter;
import java.util.ArrayList;
}
@parser:: members{
static int count=0;
public int line=0;
scratchLexer lexer;
public String curr="";
public Writer rulewriter;
public ArrayList<TOK_ERROR> errorTokens;

public void setLexer(scratchLexer lexer){
      this.lexer=lexer;
   }

   public scratchParser(TokenStream input, String name) {
          super(input);
          _interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);

                    this.rulewriter= new Writer("rules.txt");

                errorTokens=new ArrayList<TOK_ERROR>();
}
public void printErrorTokens(){
System.out.println((errorTokens.toArray()));
}
@Override
   public void enterRule(ParserRuleContext localctx, int state, int ruleIndex) {
      super.enterRule(localctx, state, ruleIndex);

                 for (int i = 0; i < count; i++) {
                     rulewriter.write("\t");
                 }
                 curr=lexer.getText();
                 rulewriter.write(ruleNames[ruleIndex]+"->"+count+"\n");
                   count++;
   }
@Override
public void exitRule(){
   super.exitRule();
       for (int i = 0; i < count+1; i++) {

       rulewriter.write("\t");
}

        count--;

       rulewriter.write(curr+" line("+lexer.getLine()+")\n");


    }
}

WhiteSpace: (Space | NewLine | BackR | Tab){skip();};

Unknown: '!'|'@'|'#'|'$'|'^';

//Rules
program: progStart ident (constDecl | varDecl | classDecl)* cbOpen (methodDecl)* cbClose;
cbOpen: CbOpen;
cbClose: CbClose;
progStart: P;
constDecl: fin type ident equals (terminated| unterminated) semi;
equals: Equals;
semi: Semi;
number: Number;
chara: Chara;
fin: Final;
classDecl: cl ident cbOpen (varDecl)* cbClose ;

cl: Class;
methodDecl:methodHeader block;
methodHeader: methodType ident formPars varDecl*;
methodType: (type | vd);
vd: Void;
formPars: pOpen (type ident (comma type ident)* )? pClose;
pOpen: POpen;
pClose: PClose;
comma: Comma;
varDecl: type ident (comma ident)* semi;
//varAssignment: type ident equals (terminated | unterminated);
terminated:(number | character| string);
character: Character;
string: String;
unterminated: (InvalidCharacter |InvalidString);
Number: Digit (Digit)*;

type: VariableType(bracketOpen bracketClose)*;

bracketOpen: BracketOpen;
bracketClose: BracketClose;
VariableType:
'String'
|'var'
|'int'
|'char'
;
block: cbOpen (statement)* cbClose ;
statement: (designator (equals expr | actPars) semi)
| mif
| whileKey pOpen condition pClose statement
| returnKey (expr)+ semi
| readKey pOpen designator pClose semi
| printKey pOpen expr (comma digit)+ pClose semi
| block
| semi
;
iff: mif|uif|condition;
mif: (ifKey pOpen iff pClose statement (el statement)? );
uif: (ifKey pOpen iff pOpen iff  )| (ifKey pOpen iff pClose  mif el uif);
ifKey: If;
el: Else;
whileKey: While;
returnKey: Return;
readKey: Read;
printKey: Print;
digit: Digit;

actPars: pOpen  expr (comma expr)*  pClose;
condition: (expr) relop (expr);
relop: equalsEquals | notEquals | greaterThan | greaterThanOrEq | lessThan | lessThanOrEq;
equalsEquals: EqualsEquals;
notEquals: NotEquals;
greaterThan:GreaterThan;
greaterThanOrEq: GreaterThanOrEq;
lessThan: LessThan;
lessThanOrEq: LessThanOrEq;

boolexpr: boolterm(boolor boolterm)*;
boolterm:boolfactor (booland boolfactor)*;
boolfactor: (not)? bool;
bool: Bool;
not: Not;
Not: '!';
Bool: 'True'|'False';
booland: Booland;
Booland: '&&';
boolor: Boolor;
Boolor: '||';

expr: (minus)* term (addop term)*;
minus:Minus;
addop: Addop;
term:  factor (mulop factor)*;
mulop: Mulop;
factor: designator (actPars)*
| digit
| chara
|ident
| newKey ident (bracketOpen (expr) bracketClose)*
| pOpen expr pClose
;
newKey: New;
designator: ident (dot ident | bracketOpen (expr) bracketClose)*;
dot: Dot;

//Operators
Addop: Plus | Minus;
Mulop: Times | Divide| Mod;

//operators
EqualsEquals: '==';
Minus: '-';
Plus: '+' ;
Times: '*';
Divide:'/';
Mod:'%';
NotEquals:'!=' ;
GreaterThan: '>';
LessThan: '<';
GreaterThanOrEq:'>=';
LessThanOrEq: '<=';
Comma: ',';
Dot: '.';
BracketOpen:'[';
BracketClose: ']';
POpen: '(';
PClose: ')';
Semi: ';' ;
Equals: '=';
CbOpen: '{';
CbClose: '}';
SingleQuote:'\'';
Quote: '"';
NewLine: '\n';
Tab: '\t';
BackR: '\r';
Space: ' ';
//Comments:
Comment: '//'.*?'\n'{skip();};


//reserved words
P: 'program';
Class: 'class';
If: 'if';
While: 'while';
Return: 'return' ;
Else: 'else';
Void: 'void';
Read: 'read';
Print: 'print';
Final: 'final';
New: 'new';

//character classes:

Character: (SingleQuote ~'\''* SingleQuote);
InvalidCharacter: SingleQuote ~'\''* (NewLine | BackR) ;
String: (Quote ~'"'* Quote) | InvalidString;
InvalidString: (Quote Chara* ~'"'* NewLine) ;
ident: Identifier|VariableType;
Identifier: Letter (Letter|Digit)*;
Letter: [a-zA-Z];
Chara: [!-~] |' ';
Digit: [0-9];