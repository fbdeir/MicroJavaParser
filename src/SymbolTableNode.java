public class SymbolTableNode {
    public String name;
    public String type;
    public int scope;
    public SymbolTableNode left;

    public SymbolTableNode right;

    public SymbolTableNode(String name, String type, int scope){
        this.name=name;
        this.type=type;
        this.scope=scope;
    }
    public void put(String name, String type, int scope)
    {
        if ( name.compareTo( this.name ) < 0 )
        {
            if ( left != null )
            {
                left.put(name, type, scope);
            }
            else
            {
                left = new SymbolTableNode( name, type, scope);
            }
        }
        else if ( name.compareTo( this.name ) > 0 )
        {
            if ( right != null )
            {
                right.put( name, type, scope );
            }
            else
            {
                right = new SymbolTableNode( name, type, scope);
            }
        }
        else
        {
            //update this one
            this.name = name;
        }
    }

    //find Node with given key and return it's value
    public Object getScope( String key )
    {
        if ( this.name.equals( key ) )
        {
            return scope;
        }

        if ( key.compareTo( this.name) < 0 )
        {
            return left == null ? null : left.getScope( key );
        }
        else
        {
            return right == null ? null : right.getScope( key );
        }
    }
    public Object getType( String key )
    {
        if ( this.name.equals( key ) )
        {
            return type;
        }

        if ( key.compareTo( this.name) < 0 )
        {
            return left == null ? null : left.getType( key );
        }
        else
        {
            return right == null ? null : right.getType( key );
        }
    }
    public Object find( String key )
    {
        if ( this.name.equals( key ) )
        {
            return this;
        }

        if ( key.compareTo( this.name) < 0 )
        {
            return left == null ? null : left.getScope( key );
        }
        else
        {
            return right == null ? null : right.getScope( key );
        }
    }

}
