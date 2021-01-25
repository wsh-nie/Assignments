import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class BitmapLinked {
    public BitmapNode root;
    public TrieNode result;
    private List<BitmapNode> bitmapNodeList = new ArrayList<BitmapNode>();

    private static class LeverNode{
        TrieNode trieNode;
        int level;
        LeverNode(TrieNode trie, int l){
            trieNode = trie;
            level = l;
        }
    }

    public BitmapLinked(TrieLinked trieLinked,int stride){
        this.root = new BitmapNode(stride,trieLinked.root);
        this.bitmapNodeList.add(this.root);
        this.result = trieLinked.root;
        Queue<BitmapNode> queueBitmapNode = new LinkedList<>();
        queueBitmapNode.add(this.root);
        while(!queueBitmapNode.isEmpty()){
            BitmapNode point = queueBitmapNode.poll();
            Queue<LeverNode> queueLevelNode = new LinkedList<>();
            queueLevelNode.add(new LeverNode(point.mTrieNode,1));
            while(!queueLevelNode.isEmpty()){
                LeverNode tmpLevelNode = queueLevelNode.poll();
                TrieNode tmpTrieNode = tmpLevelNode.trieNode;
                int idx = tmpLevelNode.level;
                if(idx >= (int)Math.pow(2,stride)){
                    break;
                }
                if(tmpTrieNode.prefix.mName !=null && tmpTrieNode.prefix.mName !="null"){//构造Result
                    point.mResult.setLink(idx-1,1,point.mTrieNode);
                }
                if(idx >= (int)Math.pow(2,stride-1)){//构造Child
                    int childIdx = idx - (int)Math.pow(2,stride-1);

                    if(tmpTrieNode.lChild != null){
                        BitmapNode newBitmapNode = new BitmapNode(stride,tmpTrieNode.lChild);
                        point.mChild.setLink(childIdx*2,1,newBitmapNode);
                        queueBitmapNode.add(newBitmapNode);
                        this.bitmapNodeList.add(newBitmapNode);
                    }
                    if(tmpTrieNode.rChild != null){
                        BitmapNode newBitmapNode = new BitmapNode(stride,tmpTrieNode.rChild);
                        point.mChild.setLink(childIdx*2+1,1,newBitmapNode);
                        queueBitmapNode.add(newBitmapNode);
                        this.bitmapNodeList.add(newBitmapNode);
                    }
                }
                if(tmpTrieNode.lChild != null){
                    queueLevelNode.add(new LeverNode(tmpTrieNode.lChild,idx*2));
                }
                if(tmpTrieNode.rChild != null){
                    queueLevelNode.add(new LeverNode(tmpTrieNode.rChild,idx*2+1));
                }
            }
        }
    }

    public void show(){
        for(int i = 0; i < this.bitmapNodeList.size(); i++){
            System.out.println("Node " + (i+1) + " : ");
            this.bitmapNodeList.get(i).show();
        }
    }
}
