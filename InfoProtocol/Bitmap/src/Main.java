import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args){
        /**
         P1 *  default
         P2 1*
         P3 00*
         P4 101*
         P5 111*
         P6 1000*
         P7 11101*
         P8 111001*
         P9 1000011*
        * */
        List<Prefix> prefixList = new ArrayList<Prefix>();
        //prefixList.add(new Prefix("P1","*"));
        prefixList.add(new Prefix("P2","1*"));
        prefixList.add(new Prefix("P3","00*"));
        prefixList.add(new Prefix("P4","101*"));
        prefixList.add(new Prefix("P5","111*"));
        prefixList.add(new Prefix("P6","1000*"));
        prefixList.add(new Prefix("P7","11101*"));
        prefixList.add(new Prefix("P8","111001*"));
        prefixList.add(new Prefix("P9","1000011*"));

        TrieLinked trieLinked = new TrieLinked(prefixList);//构造Trie
        trieLinked.levelOrder();
        int stride = 3;
        BitmapLinked bitmapLinked = new BitmapLinked(trieLinked,stride);
        bitmapLinked.show();
    }
}
