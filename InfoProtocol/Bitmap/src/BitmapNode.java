public class BitmapNode {
    public Result mResult;
    public Child mChild;
    public  TrieNode mTrieNode;

    public BitmapNode(int stride,TrieNode trieNode){
        int length = (int)Math.pow(2,stride);
        this.mResult = new Result(length - 1);
        this.mChild = new Child(length);
        this.mTrieNode = trieNode;
    }

    public void show(){
        this.mResult.show();
        this.mChild.show();
    }
}
