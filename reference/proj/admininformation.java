import java.io.*;
public class admininformation {
	public static void main(String args[]) throws Exception{
 	BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
       	BufferedWriter bw=new BufferedWriter(new FileWriter("admininformation.txt"));
	File dir = new File("image_temp");
	dir.mkdir();
       	String sql_user;
	String sql_pwd;
	String host;
	String port_num;
        System.out.println("Enter Your Username:");
        System.out.flush();
       	sql_user=br.readLine();
        bw.write(sql_user);
        bw.newLine();
	System.out.println("Enter Your Password:");
        System.out.flush();
       	sql_pwd=br.readLine();
        bw.write(sql_pwd);
        bw.newLine();
	System.out.println("Enter Your Hostname:");
        System.out.flush();
       	host=br.readLine();
        bw.write(host);
        bw.newLine();
	System.out.println("Enter Your Port Num:");
        System.out.flush();
       	port_num=br.readLine();
        bw.write(port_num);
        bw.newLine();      	
       	bw.close();
	}}

