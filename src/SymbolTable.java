import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.HashMap;

public final class SymbolTable {
    public static BST symbolTable=new BST();

    public static BST SymbolTable()  {
        return symbolTable;
    }


    public static void insert(String name, String type, int scope) {
        symbolTable.put(name, type,scope);

    }

    public static void print() {

    }
}
