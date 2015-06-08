import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class DBHandler {
	 Connection connection ;
	 String driver = "org.postgresql.Driver";
     String url = "jdbc:postgresql://localhost:5432/postgres";
     String username = "postgres";
     String password = "root";

	public void openDBConnect4(){
		
		try{
			Class.forName(driver); // Establish network connection to database.
		    connection = DriverManager.getConnection(url, username, password);
		    DatabaseMetaData metaData = connection.getMetaData();
		    String query = "SET search_path='dbconnect4'";
		    PreparedStatement statement = connection.prepareStatement(query);
		    statement.execute();
		    
		}catch(ClassNotFoundException cnfe){
			System.out.println("Error loading driver: "+cnfe.getMessage());
		}catch(SQLException sqle){
			System.out.println("Error connecting: "+ sqle.getMessage());
			
		}
	}
	
	public void closeDBConnect4(){
		try{
			connection.close();
		}catch(SQLException sqle){
			System.out.println(sqle.getMessage());
		}
		
	}
	public void insertUser(String email,String firstN,String lastN) throws SQLException{
		openDBConnect4();
		DatabaseMetaData metaData = connection.getMetaData();
		String query ="INSERT INTO dbconnect4.user VALUES ('"+email+"','"+firstN+"','"+lastN+"');";
	    PreparedStatement statement = connection.prepareStatement(query);
	    statement.execute();
	    closeDBConnect4();
	}
	
	public void deleteUser(String email) throws SQLException{
		openDBConnect4();
		System.out.println(connection);
		DatabaseMetaData metaData = connection.getMetaData();
		String query ="DELETE FROM dbconnect4.user WHERE EMAIL='"+email+"';";
	    PreparedStatement statement = connection.prepareStatement(query);
	    statement.execute();
	    closeDBConnect4();
	}
	
	public void showGamesUser (String email) throws SQLException{
		openDBConnect4();
		DatabaseMetaData metaData = connection.getMetaData();
		String query1="SELECT ID, D_INIT, D_END, EMAIL_PLAYER2 FROM dbconnect4.game WHERE EMAIL_PLAYER1='"+email+"'";
		String query2="SELECT ID,D_INIT, D_END, EMAIL_PLAYER1 FROM dbconnect4.game WHERE EMAIL_PLAYER2='"+email+"';";
		String final_query=query1+" UNION "+query2;
		PreparedStatement statement = connection.prepareStatement(final_query);
	    ResultSet result=statement.executeQuery();
	
	    while(result.next()){
	    	System.out.println("ID= "+Integer.toString(result.getInt(1)));
	    	System.out.println("FECHA DE INICIO= "+result.getString(2));
	    	System.out.println("FECHA DE FIN= "+result.getString(3));
	    	System.out.println("CONTRINCANTE= "+result.getString(4));
	    	System.out.println("\n");
	    }
	    closeDBConnect4();
	}
	
}
