module externalDependencies;

import std.typecons;
import core.stdc.config;

version(MySQL_51) {

} else version(Less_Than_MySQL_51) {}

version(Windows) {
	pragma(lib, "libmysql");
}
else {
	pragma(lib, "mysqlclient");
}

extern(System) {
	alias const(ubyte)* cstring;
	alias cstring* MYSQL_ROW;

	// From MySQL C API Data Structures
	struct MYSQL;
	struct MYSQL_RES;
	struct MYSQL_FIELDOFFSET;
	struct MYSQL_FIELD {
		  cstring name;                 /* Name of column */
		  cstring org_name;             /* Original column name, if an alias */ 
		  cstring table;                /* Table of column if column was a field */
		  cstring org_table;            /* Org table name, if table was an alias */
		  cstring db;                   /* Database for table */
		  cstring catalog;	      		/* Catalog for table */
		  cstring def;                  /* Default value (set by mysql_list_fields) */
		  c_ulong length;       		/* Width of column (create length) */
		  c_ulong max_length;   		/* Max width for selected set */
		  uint name_length;
		  uint org_name_length;
		  uint table_length;
		  uint org_table_length;
		  uint db_length;
		  uint catalog_length;
		  uint def_length;
		  uint flags;         			/* Div flags */
		  uint decimals;      			/* Number of decimals in field */
		  uint charsetnr;     			/* Character set */
		  uint type; 		
	}

	MYSQL* mysql_init(MYSQL*);
	MYSQL* mysql_real_connect(MYSQL*, cstring, cstring, cstring, cstring, uint, cstring, c_ulong);
	MYSQL_RES* mysql_store_result(MYSQL*);
	MYSQL_RES* mysql_use_result(MYSQL*);
	MYSQL_ROW mysql_fetch_row(MYSQL_RES *);
	MYSQL_FIELD* mysql_fetch_field(MYSQL_RES*);
	MYSQL_FIELD* mysql_fetch_fields(MYSQL_RES*);

	uint mysql_errno(MYSQL*);
	cstring mysql_error(MYSQL*);	
	cstring mysql_get_client_info();
	int mysql_query(MYSQL*, cstring);
	int mysql_real_query(MYSQL *mysql, cstring, c_ulong);
	int mysql_rollback(MYSQL *mysql);
	int mysql_commit(MYSQL *mysql);
	int mysql_set_character_set(MYSQL *mysql, cstring);
	int mysql_reset_connection(MYSQL *mysql);
	void mysql_close(MYSQL*);
	ulong mysql_num_rows(MYSQL_RES*);
	uint mysql_num_fields(MYSQL_RES*);
	bool mysql_eof(MYSQL_RES*);
	ulong mysql_affected_rows(MYSQL*);
	ulong mysql_insert_id(MYSQL*);
	c_ulong* mysql_fetch_lengths(MYSQL_RES*);
	uint mysql_real_escape_string(MYSQL*, ubyte* to, cstring from, c_ulong length);
	void mysql_free_result(MYSQL_RES*);

}