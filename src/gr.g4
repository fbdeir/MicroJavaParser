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
	         public static SymbolHashTable symbolTable=new SymbolHashTable();

			public void setTable(){
				symbolTable.put(0, new SymbolTableNode("int","int", "preloaded", 0,0));
				symbolTable.put(0, new SymbolTableNode("char","char", "preloaded", 0,0));
				symbolTable.put(0, new SymbolTableNode("null","null", "preloaded", 0,0));
				symbolTable.put(0, new SymbolTableNode("chr","chr", "preloaded", 0,0));
				symbolTable.put(0, new SymbolTableNode("ord","ord", "preloaded", 0,0));
				symbolTable.put(0, new SymbolTableNode("len","len", "preloaded", 0,0));
				symbolTable.put(0, new SymbolTableNode("program","program", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("class","class", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("if","if", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("else","else", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("while","while", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("read","read", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("print","print", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("return","return", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("void","void", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("final","final", "keyword", 0,0));
				symbolTable.put(0, new SymbolTableNode("new","new", "keyword", 0,0));
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
	             if(isVar==1 && next.getText().equals("(") && next.getType()==TOK_IDENTIFIER){
	             try{
	               node.structure="method(";
					 node.scope=scope;
					 System.out.println("is method method");
	               super.nextToken();
	               while(!next.getText().equals(")")){
	                   node.structure+=getText();
	               }
	               System.out.println("structure: "+node.structure);
	             }catch(NullPointerException e){
	               System.out.println("Variable already exists. method");
	             }
	             }
	             if(next.getText().equals("int") ||next.getText().equals("char") || next.getText().equals("null") ||next.getText().equals("chr") ||next.getText().equals("ord")||next.getText().equals("len")||next.getText().equals("program")||next.getText().equals("class")
						 ||next.getText().equals("if") ||next.getText().equals("else")||next.getText().equals("while")||next.getText().equals("read")||next.getText().equals("print")||next.getText().equals("return")||next.getText().equals("void")||next.getText().equals("final")||next.getText().equals("new")){
	             	if(isVar==1){
						System.out.println(next.getText()+" is reserved keyword");

					}
				 }
	             if(next.getText().equals("program")){

						 try {
							 node = new SymbolTableNode();
							 node.type = getText();
							 node.structure = "program";
							 node.name = null;
							 node.scope = 0;
							 node.isFinal = 0;
							 isProgram = 1;
						 } catch (NullPointerException e) {
							 System.out.println("Error in program");
						 }

	             }
	             if(next.getText().equals("class")){

	             	try {
						node = new SymbolTableNode();

							node.type = getText();
							node.structure = "class";
							node.scope = scope;
							isVar = 1;
						}catch(NullPointerException e){
							System.out.println("ERROR CLASS");
						}

	             }
	             if(next.getType()==TOK_FINAL){

						 try {
							 node = new SymbolTableNode();
							 node.type = getText();
							 node.structure = "final";
							 node.scope = scope;
							 isVar = 1;
						 } catch (NullPointerException e) {
							 System.out.println("ERROR FINAL");
						 }

	             }
	             if (next.getType() == TOK_IDENTIFIER && (next.getText().equals("int") || next.getText().equals("char"))){

	               node=new SymbolTableNode();
	               node.type=getText();
	               isVar=1;

	             }
	             if(next.getType()== TOK_IDENTIFIER  && !(next.getText().equals("int") || next.getText().equals("char") ||  next.getText().equals("program") ||  next.getText().equals("class") || next.getText().equals("final") )){
	             if(isVar==1){

	               try{
	               node.name=getText();
	               node.scope=scope;
	               if(isClass==0 && isProgram==0 && isArray==0){
	                   node.structure="variable";
	               }
	               isVar=0;
	               }catch(NullPointerException e){
	                   System.out.println("ERROR "+getText());
	               }
	              }
					 if(isProgram==1){
						 try{
							 node.name=getText();
							 node.scope=scope;
							 node.structure="program name";
							 isProgram=2;
						 }catch(NullPointerException e){
							 System.out.println("ERROR "+getText());
						 }
					 }
	             }
	             if(node!=null && node.name!=null && !checkScope(node.name)){
	               System.out.println("inserting "+ getText());
	               symbolTable.insert(node.name, node.type, node.structure, node.isFinal, node.scope);
	               node=null;
	             }else {
	             	try{
	             	if(checkScope(node.name)){
						System.out.println("variable already exists: " + getText());
					}else if(node==null && node.name==null){
						System.out.println("ERROR " + getText());
					}

				 }catch(NullPointerException e){

					 }
	             }
				   if(next.getText().equals("{")){
	               	count++;
	               	tracker.add(count);
	               	scope=count;
	             }
	             if(next.getText().equals("}")){

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
	            public void addTempStack(String type, String name){
	                  Stack<ASTNode> temp=new Stack<>();
	                  temp.push(new ASTNode(type, name));
	                  tempStack.push(temp);
				}
			public void printSymbolTable(){
					Set<Integer> keys=symbolTable.SymbolHashTable().keySet();
					for(Integer i: keys){

						SymbolTableNode n = (SymbolTableNode) symbolTable.get(i);
						while(n != null)
						{
							System.out.println(symbolTable.get(i, n.name).toString());
							n=n.child;
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
           // System.out.println(ruleNames[ruleIndex]);
			/*if((ruleNames[ruleIndex]).equals("formPars")){
				System.out.println("pars");
			    System.out.println(lexer.getText());
			}*/
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
prog: TOK_PROGRAM TOK_IDENTIFIER (constDecl|varDecl|classDecl)* TOK_LCB (methodDecl)* TOK_RCB EOF;

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
TOK_CHARLIT: '\''(LETTER|DIGIT|'\\n'|'\\r'|'\\t')'\'';
UNRECOGNIZED_SYMBOL: . {lexicalError=true;};
//fragments
fragment LETTER: [a-zA-Z];
fragment DIGIT: [0-9];