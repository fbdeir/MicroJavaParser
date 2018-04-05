import jdk.nashorn.internal.ir.BinaryNode;

public class BST
{
    private SymbolTableNode root;

    public void put(String name, String type, int scope)
    {
        if ( root == null )
        {
            root = new SymbolTableNode(name, type, scope);
        }
        else
        {
            root.put(name, type, scope);
        }
    }

    public Object get( String key )
    {
        return root == null ? null : root.get( key );
    }
}