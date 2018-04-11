import java.util.ArrayList;

public class SymbolTableNode {
    public String name;
    public String type;
    public String structure;
    public int scope;
    public int isFinal;
    public SymbolTableNode child;
    public int isArray;
    public ArrayList<SymbolTableNode> parameters;
    public SymbolTableNode(String name, String type, String structure, int isFinal, int scope, int isArray){
        this.name=name;
        this.type=type;
        this.scope=scope;
        this.structure=structure;
        this.isFinal=isFinal;
        this.child=null;
        this.parameters=new ArrayList<>();
        this.isArray=isArray;
    }
    public SymbolTableNode(String name, String type, String structure, int isFinal, int scope){
        this.name=name;
        this.type=type;
        this.scope=scope;
        this.structure=structure;
        this.isFinal=isFinal;
        this.child=null;
        this.parameters=new ArrayList<>();
    }
    public SymbolTableNode(){
        this.name=null;
        this.type=null;
        this.structure=null;
        this.scope=-1;
        this.isFinal=-1;
        this.child=null;
    }




}
