import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeListener;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.Parser.TraceListener;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.prefs.NodeChangeListener;

public class main  {
    public static void main (String args[]) throws java.io.IOException {
        grLexer lexer = new grLexer( CharStreams.fromFileName("C:\\Users\\MSE\\IdeaProjects\\MicroJavaParser\\src\\sample.txt"));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        grParser parser = new grParser(tokens);
        grBaseListener listener=new grBaseListener();
        parser.setLexer(lexer);
       //lexer.getAllTokens();
        System.out.println("Symbol Table");
        lexer.printSymbolTable();
        parser.prog();
        /*System.out.println("tempstack: ");
        Arrays.toString(lexer.tempStack.toArray());
        System.out.println("nodestack: ");
        Arrays.toString(lexer.nodeStack.toArray());*/

    }
}
