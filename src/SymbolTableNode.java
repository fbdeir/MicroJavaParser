public class SymbolTableNode {
    public String name;
    public String type;
    public String structure;
    public int scope;
    public int isFinal;
    public SymbolTableNode child;

    public SymbolTableNode(String name, String type, String structure, int isFinal, int scope){
        this.name=name;
        this.type=type;
        this.scope=scope;
        this.structure=structure;
        this.isFinal=isFinal;
        this.child=null;
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
