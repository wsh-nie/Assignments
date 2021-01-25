public class Prefix implements Cloneable{
    public String mName;
    public String prefix;

    public Prefix(){
        this.mName = null;
        this.prefix = null;
    }
    public Prefix(String name,String prefix){
        this.mName = name;
        this.prefix = prefix;
    }

    public Prefix clone() throws CloneNotSupportedException{
        return (Prefix) super.clone();
    }

    public void show(){
        System.out.println("----Prefix show: " );
        if(this.mName == null){
            System.out.println("----Name is NULL");
        }else{
            System.out.println("----Name is " + this.mName);
        }
        if(this.prefix == null){
            System.out.println("----Prefix is NULL");
        }else{
            System.out.println("----Prefix is " + this.prefix);
        }
    }
}
