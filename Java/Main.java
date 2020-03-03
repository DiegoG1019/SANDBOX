public class Main{
	
	static int a = 100;
	static int b = 0144;
	static int c = 0x3f;
	static int d = 0xff;
	static double e = 034.53;
	
	static int[] alpha = {35,463,235,75};
	
	public static void beta(int[] v){
		
		v[3] = 69;
		
	}

    public static void main( String[] args ){
		
		System.out.println(a);
		System.out.println(b);
		System.out.println(c);
		System.out.println(d);
		System.out.println(d+a);
		System.out.println(d-c);
		System.out.println(c-b);
		System.out.println(a*0x3c);
		System.out.println(c-5);
		System.out.println(e);
		
		System.out.println(String.format("%04X", (d)));
		
		System.out.println(alpha[3]);
		beta(alpha);
		System.out.println(alpha[3]);
		
    }
}