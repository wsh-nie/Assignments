import java.util.LinkedList;
import java.util.List;

public class Child {

    private static class ChildNode{
        int pos;// 状态0 or 1
        BitmapNode bitmapNode;// pos为1时指向的TrieNode节点
        ChildNode(int pos, BitmapNode bitmapNode){
            this.pos = pos;
            this.bitmapNode = bitmapNode;
        }
    }

    private int length;
    protected List<ChildNode> lst;

    public Child(int length){
        this.length = length;
        lst = new LinkedList<ChildNode>();
        for(int i = 0; i < length; i++){
            lst.add(new ChildNode(0,null));
        }
    }

    public void setLink(int index, int pos, BitmapNode bitmapNode){
        this.lst.set(index, new ChildNode(pos,bitmapNode));
    }

    public void show(){
        System.out.print("Child Ptr : ");
        boolean test = false;
        for(int i =0; i < length; i++){
            System.out.print(this.lst.get(i).pos + "," );
            if(!test && this.lst.get(i).pos == 1){
                test = true;
            }
        }
        if(test){
            System.out.print("\nChild Ptr Linked: ");
            for(int i =0; i < length; i++){
                if(this.lst.get(i).bitmapNode != null) {
                    System.out.print(this.lst.get(i).bitmapNode.mName+',');
                }
            }
        }
        System.out.println();
    }
}
