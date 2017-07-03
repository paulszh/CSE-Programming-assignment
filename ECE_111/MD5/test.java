public class test{
	
	public static void main(String args []){

		int temp = 0;
		for (int i = 0; i < 64; i++){
			if(i <= 15){
				temp = i;
			}
			else if( i <= 31){
				temp = (5*i + 1) % 16;
			}
			else if (i <= 47){
				temp = (3*i + 5) % 16;
			}
			else{
				temp = (7*i) % 16;
			}
			System.out.printf("W[%d] = %d\n",i,temp);
		}

	}

}