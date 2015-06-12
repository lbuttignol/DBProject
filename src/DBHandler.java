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
	    	System.out.println("INIT DATE= "+result.getString(2));
	    	System.out.println("END DATE= "+result.getString(3));
	    	System.out.println("OPPONENT= "+result.getString(4));
	    	System.out.println("\n");
	    }
	    closeDBConnect4();
	}
	
	public void showWonGames() throws SQLException {
		openDBConnect4();
		DatabaseMetaData metaData = connection.getMetaData();
		String query = "SELECT EMAIL, (SELECT count(*) FROM dbconnect4.game WHERE (email_player1=EMAIL AND result='PLAYER1') OR (email_player2=EMAIL AND result='PLAYER2')) AS counter  FROM dbconnect4.user ORDER BY counter DESC ;";
		PreparedStatement statement =connection.prepareStatement(query);
		ResultSet result=statement.executeQuery();
		
		while(result.next()){
	    	System.out.println("E-MAIL = "+result.getString(1));
	    	System.out.println("WON GAMES= "+result.getString(2));
	    	System.out.println("\n");
	    }
		
		closeDBConnect4();
	}
	
	public void showLargestGames() throws SQLException{
		openDBConnect4();
		DatabaseMetaData metaData = connection.getMetaData();
		String query = "SELECT EMAIL, (SELECT MAX(D_END-D_INIT) FROM dbconnect4.game WHERE (email_player1=EMAIL) OR (email_player2=EMAIL)) AS counter  FROM dbconnect4.user ORDER BY counter DESC ;";
		PreparedStatement statement =connection.prepareStatement(query);
		ResultSet result=statement.executeQuery();
		
		while(result.next()){
	    	System.out.println("E-MAIL = "+result.getString(1));
	    	System.out.println("LONGEST GAME= "+result.getString(2));
	    	System.out.println("\n");
	    }
		
		closeDBConnect4();
		
	}
	
	public void showDeletedUsers() throws SQLException{
		openDBConnect4();
		DatabaseMetaData metaData = connection.getMetaData();
		String query = "SELECT * FROM dbconnect4.userdeleted;";
		PreparedStatement statement =connection.prepareStatement(query);
		ResultSet result=statement.executeQuery();		
		while(result.next()){
	    	System.out.println("E-MAIL = "+result.getString(1));
	    	System.out.println("DATE = "+result.getString(2));
	    	System.out.println("DELETER USER = "+result.getString(3));
	    	System.out.println("\n");
	    }
		
		closeDBConnect4();
	}
	
	public void showApproximateAverage() throws SQLException{
		openDBConnect4();
		DatabaseMetaData metaData = connection.getMetaData();
		String query = "SELECT EMAIL, (SELECT  AVG(COUNTER) FROM (SELECT GAME_ID, COUNT (*)/2 AS COUNTER FROM (SELECT *  FROM dbconnect4.game  JOIN dbconnect4.movement ON ( dbconnect4.game.ID=dbconnect4.movement.GAME_ID AND (dbconnect4.game.EMAIL_PLAYER2=EMAIL OR dbconnect4.game.EMAIL_PLAYER1=EMAIL)))AS R1 group by GAME_ID)AS R2)AS R3 from dbconnect4.user group by EMAIL order by R3 DESC ;";
		PreparedStatement statement =connection.prepareStatement(query);
		ResultSet result=statement.executeQuery();		
		while(result.next()){
	    	System.out.println("E-MAIL = "+result.getString(1));
	    	System.out.println("APPROXIMATE AVERAGE = "+result.getFloat(2));
	    	System.out.println("\n");
	    }
		closeDBConnect4();
	}
	
}
