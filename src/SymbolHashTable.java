import javax.net.ssl.SSLEngineResult;
import java.util.Hashtable;
import java.util.LinkedList;

public final class SymbolHashTable extends Hashtable{
    private static Hashtable symbolhashtable= new Hashtable<Integer, SymbolTableNode>();;


    public static Hashtable SymbolHashTable(){
        return symbolhashtable;
    }

    public static void insert(String name, String type,String structure, int isFinal, int scope) {
        System.out.println("in put");
        try{
            SymbolTableNode n= (SymbolTableNode) symbolhashtable.get(scope);
            while(n.child!=null){
                n=n.child;
            }
            n.child=new SymbolTableNode(name, type, structure, isFinal, scope);


        }catch(NullPointerException e){
            symbolhashtable.put(scope, new SymbolTableNode(name, type, structure, isFinal, scope));
        }
    }

    public static SymbolTableNode get(int scope, String name){

        try{
            SymbolTableNode n= (SymbolTableNode) symbolhashtable.get(scope);
            while(n.child!=null && n.name!=name){
                n=n.child;
            }
            if(n.name==name){
                return n;
            }else{
                return null;
            }
        }catch(NullPointerException e){
            return null;
        }
    }
    public static SymbolTableNode get(String name){
        System.out.println("table: "+symbolhashtable);

        return null;
    }

}
