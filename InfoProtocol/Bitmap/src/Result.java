import java.util.LinkedList;
import java.util.List;

public class Result {
    private static class ResultNode{
        int pos;// 状态0 or 1
        TrieNode trieNode;// pos为1时指向的TrieNode节点
        ResultNode(int pos, TrieNode trieNode){
            this.pos = pos;
            this.trieNode = trieNode;
        }
    }

    private int length;
    public List<ResultNode> lst;

    public Result(int length){
        this.length = length;
        lst = new LinkedList<ResultNode>();
        for(int i = 0; i < length; i++){
            lst.add(new ResultNode(0,null));
        }
    }

    public void setLink(int index, int pos, TrieNode trieNode){
        this.lst.set(index, new ResultNode(pos, trieNode));
    }
    public void show(){
        System.out.print("Result Ptr : ");
        for(int i =0; i < length; i++){
            System.out.print(this.lst.get(i).pos + "," );
            //if(this.lst.get(i).trieNode != null) this.lst.get(i).trieNode.show();
        }
        System.out.println();
    }
}
