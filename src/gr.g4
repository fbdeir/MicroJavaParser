grammar gr;

options{
    language=Java;
}


//The following code is so that any unknown characters result in printing of an error statement and continuing.
@lexer::header{
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Stack;

}
@lexer::members{
  	   boolean lexicalError;
         public ArrayList<Integer> tracker=new ArrayList<Integer>(){{   add(0);}};;
         public static Stack<Stack<ASTNode>> tempStack=new Stack<Stack<ASTNode>>(); //list of children of the current subroot
         Stack<ASTNode> nodeStack=new Stack<ASTNode>(); //all subtrees
         ASTNode Ptree=new ASTNode(); //The root of the program
         static int scope=0;
         static int count=0;
         static int isVar=0;
         static int isClass=0;
         static int isFinal=0;
         static int isProgram=0;
         static int isArray=0;
         private java.util.Queue<Token> queue = new java.util.LinkedList<Token>();
         public static SymbolTable symbolTable=new SymbolTable();


         public int lexGetLine(){
           return getLine();
         }
         public SymbolTableNode node;
         @Override
         public Token nextToken() {
           if(!queue.isEmpty()) {
             return queue.poll();
           }
           Token next = super.nextToken();

           while(next.getType()==WhiteSpace){

           }
           if(next.getType() != Unknown) {
             Token curr=next;
             if(isVar==1 && next.getType()==TOK_LP){
             try{
               node.structure="method(";
               super.nextToken();
               while(next.getType()!=TOK_RP){
                   node.structure+=getText();
               }
             }catch(NullPointerException e){
               System.out.println("Variable already exists.");
             }
             }
             if(next.getType()==TOK_PROGRAM){
                try{
                node=new SymbolTableNode();
                node.type=getText();
                node.structure="program";
                isVar=1;
                }catch(NullPointerException e){
                        System.out.println("Variable already exists.");
                }
             }
             if(next.getType()==TOK_CLASS){
                try{
                node=new SymbolTableNode();
                node.type=getText();
                node.structure="class";
                isVar=1;
                }catch(NullPointerException e){
                        System.out.println("Variable already exists.");
                      }
             }
             if(next.getType()==TOK_FINAL){
             try{
             node=new SymbolTableNode();
               node.type=getText();
               node.structure="final";
               isVar=1;
               }catch(NullPointerException e){
                       System.out.println("Variable already exists.");
                     }
             }
             if (next.getType() == TOK_IDENTIFIER && (next.getText().equals("int") || next.getText().equals("char"))){
              try{
               node=new SymbolTableNode();
               node.type=getText();
               isVar=1;
               }catch(NullPointerException e){
                       System.out.println("Variable already exists.");
                     }
             }
             if(next.getType()== TOK_IDENTIFIER  && !(next.getText().equals("int") || next.getText().equals("char"))){
             if(isVar==1){
               try{
               node.name=getText();
               node.scope=scope;
               if(isClass==0 && isProgram==0 && isArray==0){
                   node.structure="variable";
               }
               }catch(NullPointerException e){
                   System.out.println("ERROR "+getText());
               }
              }
             }
             if(node!=null && node.name!=null && !checkScope(node.name) && (isvar==1 || isClass==1 || isArray==1)){
               System.out.println("inserting "+ getText());
               symbolTable.insert(node);
               node=null;
             }else{
               if(node!=null && node.name!=null){
               System.out.println("variable already exists: "+getText());
               node=null;
               }
             }
             System.out.println("type: "+next.getType()==TOK_LCB)
             if(next.getType()==TOK_LCB){
               count++;
               tracker.add(count);
               scope=count;
             }
             if(next.getType()==TOK_RCB){
               tracker.remove(tracker.size()-1);
               scope=tracker.get(tracker.size()-1);
             }
             return curr;
           }


           StringBuilder builder = new StringBuilder();

           while(next.getType() == Unknown) {
             next = super.nextToken();
           }


           queue.offer(next);

           return new CommonToken(Unknown, builder.toString());
         }
       public Boolean checkScope(String name){
               if(symbolTable.get(name)==null){
                   return false;
               }else{
                   return true;
               }
           }
            public void addTempStack(String type, String name){
                  Stack<ASTNode> temp=new Stack<>();
                  temp.push(new ASTNode(type, name));
                  tempStack.push(temp);
              }
}
@parser:: members{
grLexer lexer;
public void setLexer(grLexer lexer){
			this.lexer=lexer;
		}
}

@parser::header{
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Stack;

}

//SPACES
WhiteSpace: (' ' | '\n'| '\r'| '\t'){skip();};
Comments: '//'.*?'\n'{skip();};
Unknown: '!'|'@'|'#'|'$'|'^';

//
//MicroJava Tokens:
TOK_INTLIT : (DIGIT)+{
long y= Long.parseLong(getText());
if(y>2147483647){
lexicalError=true;
}

};
TOK_INVALID_IDENTIFIER: '_' TOK_IDENTIFIER
  | DIGIT TOK_IDENTIFIER {lexicalError=true;};
TOK_IDENTIFIER : LETTER (LETTER|DIGIT)*;
TOK_INVALID_CHARLIT: '\'' (TOK_CHARLIT)? ~('\''){lexicalError=true;};
TOK_CHARLIT: '\''(LETTER|DIGIT|'\\n'|'\\r'|'\\t')'\'';
UNRECOGNIZED_SYMBOL: . {lexicalError=true;};
//Rules
prog: TOK_PROGRAM TOK_IDENTIFIER (constDecl|varDecl|classDecl)* TOK_LCB (methodDecl)* TOK_RCB;

varDecl: varType TOK_IDENTIFIER  (TOK_COMMA TOK_IDENTIFIER)* TOK_SEMI;

constDecl: TOK_FINAL varType TOK_IDENTIFIER TOK_OP_ASSIGN (TOK_INTLIT|TOK_CHARLIT) TOK_SEMI;
classDecl: TOK_CLASS  TOK_IDENTIFIER TOK_LCB (varDecl)* TOK_RCB ;
methodDecl: (varType| TOK_VOID) TOK_IDENTIFIER TOK_LP (formPars)? TOK_RP (varDecl)* block;
formPars: varType TOK_IDENTIFIER (TOK_COMMA varType TOK_IDENTIFIER)*;
block: TOK_LCB (statement)* TOK_RCB;
statement: designator (TOK_OP_ASSIGN expr|actPars) TOK_SEMI
| TOK_IF TOK_LP  condition TOK_RP (TOK_LCB)? (statement)* (TOK_RCB)? (TOK_ELSE (TOK_LCB)? statement (TOK_RCB)?)*
| TOK_WHILE TOK_LP condition TOK_RP statement
| TOK_RETURN (expr)? TOK_SEMI
| TOK_READ TOK_LP designator TOK_RP TOK_SEMI
| TOK_PRINT TOK_LP expr (TOK_COMMA TOK_INTLIT)? TOK_RP TOK_SEMI
|  block
| TOK_SEMI;
actPars: TOK_LP (expr (TOK_COMMA expr)*)? TOK_RP;
condition: expr relop expr;
relop: TOK_OP_REL;
expr: ('-')? term  (TOK_OP_ADD term)*;
term: factor (TOK_OP_TIMES factor)*;
factor: designator (actPars)?
| TOK_INTLIT
| TOK_CHARLIT
| TOK_NEW x
| TOK_LP expr TOK_RP;
designator: TOK_IDENTIFIER (TOK_DOT TOK_IDENTIFIER | TOK_LB expr TOK_RB)*;
x:TOK_IDENTIFIER ((TOK_LP expr TOK_RP)?|(TOK_LB (expr)? TOK_RB)*);

varType: TOK_IDENTIFIER (TOK_LB TOK_RB)?;

//Keywords
TOK_PROGRAM : 'program';
TOK_CLASS : 'class';
TOK_FINAL : 'final';
TOK_ELSE : 'else';
TOK_IF : 'if';
TOK_NEW : 'new';
TOK_READ : 'read';
TOK_RETURN : 'return';
TOK_VOID : 'void';
TOK_WHILE : 'while';
TOK_PRINT : 'print';

//MicroJava Delimiters
TOK_COMMA : ',';
TOK_SEMI : ';';
TOK_DOT : '.';
TOK_LB : '[';
TOK_RB : ']';
TOK_LCB : '{' ;
TOK_RCB : '}';
TOK_LP : '(';
TOK_RP : ')';

//MicroJava Operators
TOK_OP_REL : TOK_EQ
   | TOK_OP_NE
   | TOK_OP_LT
   | TOK_OP_LE
   | TOK_OP_GT
   | TOK_OP_GE;

TOK_OP_ADD : OP_ADD_PLUS
   | OP_ADD_MINUS ;


TOK_OP_TIMES : OP_MUL_TIMES //OPP_MUL_TIMES
| OP_MUL_DIV
| OP_MUL_MOD;

//OPERATOR TOKENS
TOK_EQ:'==';
TOK_OP_NE: '!=';
TOK_OP_LT: '<';
TOK_OP_LE: '<=';
TOK_OP_GT: '>';
TOK_OP_GE: '<=';
TOK_OP_ASSIGN : '=' ;// OP_ASSIGN
OP_ADD_PLUS: '+';
OP_ADD_MINUS: '-';
OP_MUL_TIMES:'*';
OP_MUL_DIV:'/';
OP_MUL_MOD:'%';

//fragments
fragment LETTER: [a-zA-Z];
fragment DIGIT: [0-9];