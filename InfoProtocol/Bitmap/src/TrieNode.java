public class TrieNode {
    public Prefix prefix;
    public TrieNode lChild;
    public TrieNode rChild;
    public TrieNode(Prefix prefix){
        this.prefix = prefix;
        if(this.prefix.mName == null){
            this.prefix.mName = "null";
        }
        this.rChild = null;
        this.lChild = null;
    }

    public void show(){
        System.out.println("**********************");
        this.prefix.show();
        if(this.lChild != null){
            System.out.println("lChild : " + this.lChild.prefix.mName);
        }else{
            System.out.println("lChild : NULL");
        }
        if(this.rChild != null){
            System.out.println("rChild : " + this.rChild.prefix.mName);
        }else{
            System.out.println("rChild : NULL");
        }
        System.out.println("**********************");
    }

}
