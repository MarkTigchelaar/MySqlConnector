module MySql;
import externalDependencies;

class MySqlConnector {
	
	private  {
		MYSQL_RES* result;
		MYSQL* mysql;

		cstring hostName;
		cstring userName;
		cstring password;
		cstring database;

		bool isConnectedtoDB = false;
		string errorString;
	}

	this(string host, string user, string pwd, string db) {
		hostName = toCstring(host);
		userName = toCstring(user);
		password = toCstring(pwd);
		database = toCstring(db);
	}

	public bool open() {
		mysql = mysql_init(mysql);
		if(mysql is null) {
			return fail();
		} else {
			mysql = mysql_real_connect(
			mysql, hostName, userName, password, database, 0,null,0);
		}
		if(mysql is null) {
			return fail();
		} else {
			isConnectedtoDB = true;
		}
		string command = "SET NAMES 'utf8'";
		if(cast(bool) mysql_real_query(
			mysql, toCstring(command), command.length + 1)) {
			return fail();
		}
		if(cast(bool) mysql_set_character_set(
			mysql, toCstring("utf8"))) {
			return fail();
		}
		return true;
	}

	public bool isConnected() {
		return isConnectedtoDB;
	}

	public void close() {
		mysql_close(mysql);
		isConnectedtoDB = false;
	}

	public bool query(string statement) {
		if(cast(bool) mysql_real_query(
			mysql, toCstring(statement), statement.length + 1)) {
		  return fail();
		}
		result = mysql_store_result(mysql);
		if(result is null) {
		  return fail();
		} return true;
	}

	public void getResults(DataReader reader) {
		reader.numFields = mysql_num_fields(result);
		reader.numRows = mysql_num_rows(result);
		MYSQL_ROW row;
		while((row = mysql_fetch_row(result)) !is null) {
		  string strRow = "";
		  for(uint i = 0; i < reader.columns(); i++) {
		  	strRow ~= fromCstring(*(row + i));
		  	if(i < reader.columns() - 1) {
		  		strRow ~= ",";
		  	}
		  }
		  reader.rows ~= strRow;
		}
		mysql_free_result(result);
	}

	public bool startTransaction() {
		string command = "START TRANSACTION";
		if(cast(bool) mysql_real_query(
			mysql, toCstring(command), command.length + 1)) {
			return fail();
		}	return true;	
	}

	public bool commit() {
		if(cast(bool) mysql_commit(mysql)) {
		  return fail();
		} return true;
	}

	public bool rollback() {
		if(cast(bool) mysql_rollback(mysql)) {
		  return fail();
		} return true;
	}

	public bool resetConnection() {
		if(cast(bool) mysql_reset_connection(mysql)) {
		  return fail();
		} return true;
	}

	public string getError() {
		return errorString;
	}

	private cstring toCstring(string input) {
		import std.string: toStringz;
		return cast(cstring) toStringz(input);
	}

	private string fromCstring(cstring input) {
		if(input is null) {
			return null;
		}
		int len = 0;
		auto dstring = input;
		while(*dstring) {
			dstring++;
			len++;
		}
		return cast(string) input[0 .. len].idup;
	}

	private string error() {
		return fromCstring(mysql_error(mysql));
	}

	private bool fail() {
		errorString = error();
		close();
		return false;
	}
}

class DataReader {

	string[] rows;
	private uint numFields = 0;
	private ulong numRows = 0;

	this() {}

	public void clearFields() {
		destroy(rows);
	}

	public uint columns() {
		return numFields;
	}

	public ulong length() {
		return numRows;
	}

	public string getRow(uint rowNum) {
		return rows[rowNum];
	}

}