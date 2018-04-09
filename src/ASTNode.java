import java.util.ArrayList;
import java.util.Arrays;
import java.util.Stack;
public class ASTNode {
String type;
String name;
ArrayList<ASTNode> children;

public ASTNode(String type, String name){
    this.type=type;
    this.name=name;
}
public ASTNode(){
    type=null;
    name=null;
    children=null;
}
public void add(ASTNode n){
    children.add(n);
}
public void add(String type, String name){
    children.add(new ASTNode(type, name));
}
public void printChildren(){
    Arrays.toString(children.toArray());
}
public void add(Stack<ASTNode> stack){
    for(ASTNode n: stack){
        this.add(n);
    }
}
}
