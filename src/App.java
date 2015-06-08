import java.sql.SQLException;
import java.util.Scanner;




/*Preguntas para fabio:
*	-Como tratar los errores que tira la base de datos, por ejemplo cuando quuiero registrar
*	un usuario que ya ha sido registrado.
*	
*/


public class App {

	public App(){
		mainMenu();
	}
	public final static void clearConsole(){
	 	System.out.print("\033[H\033[2J");
		System.out.flush();
	}	
	
	public final static void wait(int seconds){
		try {
    		Thread.sleep(1000*seconds);                 //1000 milliseconds is one second.
		} catch(InterruptedException ex) {
    		Thread.currentThread().interrupt();
		}
	}
	
	public void signUpMenu(){
		clearConsole();
		System.out.println("*************************************");
		System.out.println("***********  CONNECT4  **************");
		System.out.println("");
		System.out.println("Complete:");
		System.out.print("E-mail: ");
		String email = "";
		Scanner inputScanner = new Scanner(System.in); //Creación de un objeto Scanner
		email = inputScanner.nextLine(); //Invocamos un método sobre un objeto Scanner
		System.out.println("");
		System.out.print("First name: ");
		String fName="";
		fName=inputScanner.nextLine(); 
		System.out.println("");
		System.out.print("Last name: ");
		String lName="";
		lName=inputScanner.nextLine();
		DBHandler handler=new DBHandler();
		try{
			handler.insertUser(email, fName, lName);
			System.out.println("\nYou are registered in Connect4. Thank you!.");
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);	
			mainMenu();
		}
	
	}
	
	public void deleteMenu(){
		clearConsole();
		System.out.println("*************************************");
		System.out.println("***********  CONNECT4  **************");
		System.out.println("");
		System.out.println("Please enter an email that you want to delete:");
		System.out.print("E-mail: ");
		String email = "";
		Scanner inputScanner = new Scanner(System.in); //Creación de un objeto Scanner
		email = inputScanner.nextLine(); //Invocamos un método sobre un objeto Scanner
		DBHandler handler=new DBHandler();
		try{
			handler.deleteUser(email);
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
			mainMenu();
		}
	}
	
	public void showGamesMenu(){
		clearConsole();
		System.out.println("*************************************");
		System.out.println("***********  CONNECT4  **************");
		System.out.println("");
		System.out.println("Please enter an email that you want to delete:");
		System.out.print("E-mail: ");
		String email = "";
		Scanner inputScanner = new Scanner(System.in); //Creación de un objeto Scanner
		email = inputScanner.nextLine(); //Invocamos un método sobre un objeto Scanner
		DBHandler handler=new DBHandler();
		try{
			handler.showGamesUser(email);
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
			mainMenu();
			
		}
		
	}
	
	
	private String submenu1(){
		clearConsole();
		System.out.println("*************************************");
		System.out.println("***********  CONNECT4  **************");
		System.out.println("");
		System.out.println("Select just a option:");
		System.out.println("   1. Sign Up.");
		System.out.println("   2. Delete User.");
		System.out.println("   3. Show games.");
		System.out.println("   4. More info.");
		System.out.println("");
		System.out.print("Option: ");
		String option = "";
		Scanner inputScanner = new Scanner(System.in); //Creación de un objeto Scanner
		option = inputScanner.nextLine(); //Invocamos un método sobre un objeto Scanner
		return option;
	}
	
	public void mainMenu(){
		clearConsole();
		switch(submenu1()){
			case "1":
					signUpMenu();
					break;
			case "2":
					deleteMenu();
					break;
			case "3":
					showGamesMenu();
					break;
			case "4":
					
					break;
			case "5":
					System.exit(0);
					break;
			default:
				System.out.println("Option is incorrect. Please choose again.");
				wait(2);
				mainMenu();
		}
	}

	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		App app=new App();
	
	}

}
