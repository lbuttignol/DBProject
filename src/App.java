import java.sql.SQLException;
import java.util.Scanner;




/*Preguntas para fabio:
* 	-El tema de las fechas.
* 	-Que pasa si quiero eliminar a alguien que haya eliminado otros usuarios.
*	-Como tratar los errores que tira la base de datos, por ejemplo cuando quuiero registrar
*	un usuario que ya ha sido registrado.
*	- Tema de transaccioines.
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
			System.out.println("Press any key for continue.");
			String enter = inputScanner.nextLine(); 
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
		}finally{	
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
			System.out.println("Press any key for continue.");
			String enter= inputScanner.nextLine(); //Invocamos un método sobre un objeto Scanner
			
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
		}finally{
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
			System.out.println("Press any key for continue.");
			String enter = inputScanner.nextLine(); 
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
		}finally{
			mainMenu();
		}
		
	}
	
	public void showWonGamesMenu(){
		clearConsole();
		System.out.println("*************************************");
		System.out.println("***********  CONNECT4  **************");
		System.out.println("");
		DBHandler handler=new DBHandler();
		try{
			handler.showWonGames();
			System.out.println("Press any key for continue.");
			Scanner inputScanner = new Scanner(System.in); //Creación de un objeto Scanner
			String enter= inputScanner.nextLine(); //Invocamos un método sobre un objeto Scanner
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
			
		}finally{
			mainMenu();
		}
	}
	public void showLargestGamesMenu(){
		clearConsole();
		System.out.println("*************************************");
		System.out.println("***********  CONNECT4  **************");
		System.out.println("");
		DBHandler handler=new DBHandler();
		try{
			handler.showLargestGames();
			System.out.println("Press any key for continue.");
			Scanner inputScanner = new Scanner(System.in); 
			String enter= inputScanner.nextLine();
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
		}finally{
			mainMenu();
		}
	}
	
	public void showDeletedUsersMenu(){
		clearConsole();
		System.out.println("*************************************");
		System.out.println("***********  CONNECT4  **************");
		System.out.println("");
		DBHandler handler=new DBHandler();
		try{
			handler.showDeletedUsers();
			System.out.println("Press any key for continue.");
			Scanner inputScanner = new Scanner(System.in); 
			String enter= inputScanner.nextLine();
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
		}finally{
			mainMenu();
		}
	}
	
	private void showApproximateAverageMenu(){
		clearConsole();
		System.out.println("*************************************");
		System.out.println("***********  CONNECT4  **************");
		System.out.println("");
		DBHandler handler=new DBHandler();
		try{
			handler.showApproximateAverage();
			System.out.println("Press any key for continue.");
			Scanner inputScanner = new Scanner(System.in); 
			String enter= inputScanner.nextLine();
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
			wait(2);
		}finally{
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
		System.out.println("   4. Won games by users.");
		System.out.println("   5. Longest game by users.");
		System.out.println("   6. Deleted users.");
		System.out.println("   7. Average chip by user.");
		System.out.println("   8. Exit.");
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
					showWonGamesMenu();
					break;
			case "5":
					showLargestGamesMenu();
					break;
			case "6":
					showDeletedUsersMenu();
					break;
			case "7":
					showApproximateAverageMenu();
					break;
			case "8":
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
