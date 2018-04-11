grammar gr;

options{
    language=Java;
}


//The following code is so that any unknown characters result in printing of an error statement and continuing.
@lexer::header{
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Stack;
import java.util.Set;
}
@lexer::members{
boolean lexicalError=false;
 public ArrayList<Integer> tracker=new ArrayList<Integer>(){{   add(0);}};;
 		         public static Stack<Stack<ASTNode>> tempStack=new Stack<Stack<ASTNode>>(); //list of children of the current subroot
 		         Stack<ASTNode> nodeStack=new Stack<ASTNode>(); //all subtrees
 		         ASTNode Ptree=new ASTNode(); //The root of the program
 		         int scope=0;
 		         static int count=0;
 		         static int isVar=0;
 		         static int isClass=0;
 		         static int isProgram=0;
 		         static int isArray=0;
 		         static int isAssign=0;
 		         static int isMethod=0;
 		         static String methodParams="";
 		         static int isParams=0;
 		         static ArrayList<String> varTypes=new ArrayList<String>();
 		         private java.util.Queue<Token> queue = new java.util.LinkedList<Token>();
 		         public static SymbolHashTable symbolTable=new SymbolHashTable();
                 Writer writer=new Writer("errors.txt");

 				public void setTable(){
 				    varTypes.add("int");
 				    varTypes.add("char");

 					symbolTable.insert("int","int", "preloaded", 0,0);
                    	 					symbolTable.insert("char","char", "preloaded", 0,0);
                    	 					symbolTable.insert("null","null", "preloaded", 0,0);
                    	 					symbolTable.insert("chr","chr", "preloaded", 0,0);
                    	 					symbolTable.insert("ord","ord", "preloaded", 0,0);
                    	 					symbolTable.insert("len","len", "preloaded", 0,0);
                    	 					symbolTable.insert("program","program", "keyword", 0,0);
                    	 					symbolTable.insert("class","class", "keyword", 0,0);
                    	 					symbolTable.insert("if","if", "keyword", 0,0);
                    	 					symbolTable.insert("else","else", "keyword", 0,0);
                    	 					symbolTable.insert("while","while", "keyword", 0,0);
                    	 					symbolTable.insert("read","read", "keyword", 0,0);
                    	 					symbolTable.insert("print","print", "keyword", 0,0);
                    	 					symbolTable.insert("return","return", "keyword", 0,0);
                    	 					symbolTable.insert("void","void", "keyword", 0,0);
                    	 					symbolTable.insert("final","final", "keyword", 0,0);
                    	 					symbolTable.insert("new","new", "keyword", 0,0);
 				}
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

 		             if(next.getText().equals("int") ||next.getText().equals("char") || next.getText().equals("null") ||next.getText().equals("chr") ||next.getText().equals("ord")||next.getText().equals("len")||next.getText().equals("program")||next.getText().equals("class")
 							 ||next.getText().equals("if") ||next.getText().equals("else")||next.getText().equals("while")||next.getText().equals("read")||next.getText().equals("print")||next.getText().equals("return")||next.getText().equals("void")||next.getText().equals("final")||next.getText().equals("new")){
 		             	if(isVar==1 && isMethod==0){
 							System.out.println(next.getText()+" is reserved keyword");
 						}
 					 }



 					 if(getText().equals("\'") && isArray==1){
 					    System.out.println("Can only use number indeces in arrays at line "+getLine());
 					 }
 		             if(next.getType()==TOK_PROGRAM){

 							 try {
 								 node = new SymbolTableNode();
 								 node.type = "Program Name";
 								 node.structure = "TOK_IDENTIFIER";
 								 node.name = null;
 								 node.scope = 0;
 								 node.isFinal = 0;
 								 isProgram = 1;
 							 } catch (NullPointerException e) {
 								 System.out.println("Error in program");
 							 }

 		             }
 		             if(next.getType()==TOK_CLASS){

 		             	try {
 							node = new SymbolTableNode();
                            isClass=1;
 								node.type = getText();
 								node.structure = "class";
 								node.scope = scope;
 								isVar = 1;
 							}catch(NullPointerException e){
 								System.out.println("ERROR CLASS");
 							}

 		             }
 		             if(next.getType()==TOK_FINAL){
 	                        System.out.println("Final");
 							 try {
 								 node = new SymbolTableNode();
 								 node.type = getText();
 								 node.structure = "final";
 								 node.scope = scope;
 								 node.isFinal=1;
 							 } catch (NullPointerException e) {
 								 System.out.println("ERROR FINAL");
 							 }
 		             }
 		             if (next.getType() == TOK_IDENTIFIER && (next.getText().equals("int") || next.getText().equals("char"))){
 		             if(varTypes.contains(next.getText())){
 		             try{

 		                node.type=getText();
 		                node.isArray=isArray;
 		                isVar=1;
 		             }catch(NullPointerException e){
 		               node=new SymbolTableNode();
 		               node.type=getText();
 		               isVar=1;
 		               }
                    }
 		             }
 		             if(next.getType()==TOK_LP){
 		                isParams=0;
 		             }
 		             if(next.getType()==TOK_LP){
 		                isMethod=0;
 		             }
 		              if(next.getType()==TOK_LCB){

                      		               	count++;
                      		               	tracker.add(count);
                      		               	scope=count;
                      		               	 if(isMethod==1){
                      		               	 isMethod=0;
                      		               	 isVar=0;
                      		               	 }
                                    }else
                      		             if(next.getType()==TOK_RCB){

                      						 tracker.remove(tracker.size()-1);
                      						 scope=tracker.get(tracker.size()-1);

                      		             }

 		             if(next.getType()== TOK_IDENTIFIER  && !(next.getText().equals("int") || next.getText().equals("char") ||  next.getText().equals("program") ||  next.getText().equals("class") || next.getText().equals("final") )){
                       if(isClass==1){
                            isClass=0;
                            varTypes.add(getText());
                       }
                     if(isMethod==1){
                          node=new SymbolTableNode();
                          node.name=getText();
                          node.scope=0;
                          node.isFinal=0;
                          node.structure="method";
                          node.type=methodParams;
                         if (next.getType()== TOK_IDENTIFIER && !next.getText().equals("int") && !next.getText().equals("char") &&!varTypes.contains(getText())) {
                            methodParams +=" "+getText();

                         } else if (next.getType()== TOK_COMMA) {
                            methodParams += " "+",";

                         }
                         node.type+=methodParams;
                         methodParams="";
                     }else
                     if(isVar!=1 && !varTypes.contains(getText())){
                            isAssign=1;
                     }

 		             if(isVar==1){

 		               try{
 		               node.name=getText();
 		               node.scope=count;
 		               node.structure="TOK_IDENTIFIER";
 		               node.isArray=isArray;
 		               if(isClass==0 && isProgram==0 && isArray==0){
 		                   node.structure="variable";
 		               }

 		               isVar=0;
 		               }catch(NullPointerException e){
 		                   System.out.println("ERROR "+getText());
 		               }

 		              }else
 						 if(isProgram==1){
 							 try{
 								 node.name=getText();
 								 node.scope=count;
 								 node.structure="TOK_IDENTIFIER";
 								 isProgram=2;
 							 }catch(NullPointerException e){
 								 System.out.println("ERROR "+getText());
 							 }
 						 }else

 						 if(isAssign==1 && !checkScope(getText())){
                                 System.out.println("variable " +getText()+" not defined in scope. line: "+getLine());
                         }
                         else
 						 if(isVar!=1 && isAssign==0){

 						    if(checkScopeNode(getText()).isFinal==1){
 							    System.out.println("variable " +getText()+" is final.");
 							}
 						 }else
 						 if(isAssign==1){
 						  if(!checkScope(getText()))
 							    System.out.println("variable " +getText()+" not defined in scope");
 						 }
 		             }
 		             if(node!=null && node.name!=null && !checkScope(node.name)){
 		               System.out.println("inserting "+ getText());
	 		               symbolTable.insert(node.name, node.type, node.structure, node.isFinal, scope, node.isArray);
 		               node=null;
 		             }else {
 		             	try{
 		             	if(checkScope(node.name)&&isVar==1){
 		             	if(!(getText().equals(",") || getText().equals(";") || getText().equals(".") || getText().equals("[") || getText().equals("]") || getText().equals("{") || getText().equals("}") || getText().equals("(") || getText().equals(")") || getText().equals("+") || getText().equals("-") || getText().equals("=")|| getText().equals("/") || getText().equals("&") || getText().equals("*"))){
 		             	    System.out.println("variable already exists: " + getText());
 		             	}
 						}else if(node==null && node.name==null){
 							System.out.println("ERROR " + getText());
 						}

 					 }catch(NullPointerException e){

 						 }
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
 					   SymbolTableNode n=null;
 					   if(name.equals("int") ||name.equals("char") || name.equals("null") ||name.equals("chr") ||name.equals("ord")||name.equals("len")||name.equals("program")||name.equals("class")
 							   ||name.equals("if") ||name.equals("else")||name.equals("while")||name.equals("read")||name.equals("print")||name.equals("return")||name.equals("void")||name.equals("final")||name.equals("new")){
 					   	return true;
 					   }

 					   for(int i=0; i<tracker.size(); i++) {
 						  // for(Integer temp: set) {
 							   n = (SymbolTableNode) symbolTable.get(tracker.get(i), name);

 						//   }
 						try {
 							if (n != null)
 								return true;
 						}catch(NullPointerException e){
 								return false;
 							}
 						}
 						return false;

 			   }
 			   public SymbolTableNode checkScopeNode(String name){
 	           	           				   SymbolTableNode n=null;
 	           	           				   for(int i=0; i<tracker.size(); i++) {
 	           	           					  // for(Integer temp: set) {
 	           	           						   n = (SymbolTableNode) symbolTable.get(tracker.get(i), name);
 	           								   try {
 	           									   if (n != null)
 	           										   return n;
 	           								   }catch(NullPointerException e){
 	           								   }
 	           							   }
 	           	           					return n;

 	           	           		   }
 		            public void addTempStack(String type, String name){
 		                  Stack<ASTNode> temp=new Stack<>();
 		                  temp.push(new ASTNode(type, name));
 		                  tempStack.push(temp);
 					}
 				public void printSymbolTable(){
 					Set<Integer> keys=symbolTable.SymbolHashTable().keySet();
 	                int line=0;
 	                for(Integer i: keys){
 	                    SymbolTableNode n = (SymbolTableNode) symbolTable.SymbolHashTable().get(i);
 	                    while(n != null){
 	                        if(n.isArray!=1){
 		                    System.out.println(line+": "+n.name+", "+n.structure+", scope: "+n.scope+", type: "+n.type);
 		                    }else{
 		                        System.out.println(line+": "+n.name+", "+n.structure+", scope: "+n.scope+", type: "+n.type+"[]");
 		                    }
 	                        n=n.child;
 	                        line++;
 	                    }
 	                }
 				}
}
@parser:: members{
grLexer lexer;
public void setLexer(grLexer lexer){
			this.lexer=lexer;
		}
        @Override
		public void enterRule(ParserRuleContext localctx, int state, int ruleIndex) {
        super.enterRule(localctx, state, ruleIndex);

        	if (ruleNames[ruleIndex].equals("methodDecl")) {
            					System.out.println("entering method");
            					lexer.isMethod = 1;
            				} else if (lexer.isMethod == 1) {
            					if (ruleNames[ruleIndex].equals("varType")) {
            						lexer.methodParams += " "+lexer.getText();
            					}

            				}
            				else if(ruleNames[ruleIndex].equals("varArray")) {
                                lexer.isArray=1;
                                System.out.println("is arr "+lexer.isArray);
                            }
                            else if(ruleNames[ruleIndex].equals("semi")) {
                                lexer.isAssign=0;
                                lexer.isArray=0;

                            }
                            else if(ruleNames[ruleIndex].equals("tok_rcb")){
                                lexer.scope++;
                                lexer.count++;

                            }

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
//Keywords
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
TOK_PROGRAM: 'program';

//Rules
program: prog;
prog: TOK_PROGRAM TOK_IDENTIFIER (constDecl|varDecl|classDecl)* tok_lcb (methodDecl)* tok_rcb EOF;
tok_lcb: TOK_LCB;
tok_rcb: TOK_RCB;
varDecl: varType TOK_IDENTIFIER  (TOK_COMMA TOK_IDENTIFIER)* semi;

constDecl: TOK_FINAL varType TOK_IDENTIFIER TOK_OP_ASSIGN (TOK_INTLIT|TOK_CHARLIT) semi;
classDecl: TOK_CLASS  TOK_IDENTIFIER tok_lcb (varDecl)* tok_rcb ;
methodDecl: (varType| TOK_VOID) TOK_IDENTIFIER TOK_LP (formPars)? TOK_RP (varDecl)* block;
formPars: varType TOK_IDENTIFIER (TOK_COMMA varType TOK_IDENTIFIER)*;
block: tok_lcb (statement)* tok_rcb;
statement: designator (TOK_OP_ASSIGN expr|actPars) semi
| TOK_IF TOK_LP  condition TOK_RP (tok_lcb)? (statement)* (tok_rcb)? (TOK_ELSE (tok_lcb)? statement (tok_rcb)?)*
| TOK_WHILE TOK_LP condition TOK_RP statement
| TOK_RETURN (expr)? semi
| TOK_READ TOK_LP designator TOK_RP semi
| TOK_PRINT TOK_LP expr (TOK_COMMA TOK_INTLIT)? TOK_RP semi
|  block
| semi;
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
designator: TOK_IDENTIFIER (TOK_DOT TOK_IDENTIFIER | (validarray|invalidarray))*;
x:TOK_IDENTIFIER ((TOK_LP expr TOK_RP)?|(tok_lb(expr)? tok_rb)*);
validarray:tok_lb expr tok_rb;
invalidarray:tok_lb '\'' {System.out.println("cannot define with character index");} tok_rb;
tok_lb: TOK_LB;
tok_rb:TOK_RB;
semi: TOK_SEMI;
varType: (vartp)|
(varArray);
vartp:TOK_IDENTIFIER ;
varArray: TOK_IDENTIFIER (tok_lb tok_rb);



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
//
TOK_INVALID_IDENTIFIER: '_' TOK_IDENTIFIER
  | DIGIT TOK_IDENTIFIER {lexicalError=true;};
TOK_IDENTIFIER : LETTER (LETTER|DIGIT)*;
TOK_INVALID_CHARLIT: '\'' (TOK_CHARLIT)? ~('\''){lexicalError=true;};
TOK_CHARLIT: '\'' (LETTER|DIGIT|'\\n'|'\\r'|'\\t')'\'';
UNRECOGNIZED_SYMBOL: . {lexicalError=true;};
//fragments
fragment LETTER: [a-zA-Z];
fragment DIGIT: [0-9];