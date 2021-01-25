import java.util.*;

public class TrieLinked {
    public TrieNode root;

    private static class LeverNode{
        TrieNode trieNode;
        int level;
        LeverNode(TrieNode trie, int l){
            trieNode = trie;
            level = l;
        }
    }

    public TrieLinked (List<Prefix> prefixArrayList){
        this.root = new TrieNode(new Prefix("P1","*"));
        final int len = prefixArrayList.size();
        for(int i = 0; i < len; i++){
            TrieNode point  = this.root; //指向根结点
            String str = prefixArrayList.get(i).prefix;
            final int strlen = str.length();
            int j = 0;
            while(j <= strlen - 2){
                if(str.charAt(j) == '1'){
                    if(point.rChild == null){
                        TrieNode tmp = new TrieNode(new Prefix());
                        point.rChild = tmp;
                    }
                    point = point.rChild;
                }else{
                    if(point.lChild == null){
                        TrieNode tmp = new TrieNode(new Prefix());
                        point.lChild = tmp;
                    }
                    point = point.lChild;
                }
                j++;
            }
            point.prefix.mName = prefixArrayList.get(i).mName;
            point.prefix.prefix = prefixArrayList.get(i).prefix;
        }
    }

    public void levelOrder(){
        if(this.root == null){
            return ;
        }
        Queue< LeverNode > queue = new LinkedList<>();
        queue.add(new LeverNode(this.root,1));
        int cnt = 0;
        while(!queue.isEmpty()){
            LeverNode tmpLeverNode = queue.poll();
            TrieNode tmpNode = tmpLeverNode.trieNode;
            int level = tmpLeverNode.level;
            System.out.println((level) + " : " + tmpNode.prefix.mName.toString() + " - " + tmpNode.prefix.prefix);
            if(tmpNode.lChild != null){
                queue.add(new LeverNode(tmpNode.lChild,level+1));
            }
            if(tmpNode.rChild != null){
                queue.add(new LeverNode(tmpNode.rChild,level+1));
            }
        }
    }
}
