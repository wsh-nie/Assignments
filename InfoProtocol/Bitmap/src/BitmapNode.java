public class BitmapNode {
    public Result mResult;
    public Child mChild;
    public  TrieNode mTrieNode;
    public String mName;

    public BitmapNode(int stride,TrieNode trieNode,String name){
        this.mName = name;
        int length = (int)Math.pow(2,stride);
        this.mResult = new Result(length - 1);
        this.mChild = new Child(length);
        this.mTrieNode = trieNode;
    }

    public void show(){
        System.out.println("\n"+this.mName+":");
        this.mResult.show();
        this.mChild.show();
    }
}
