
//////////////////////////////////////////////////
//  SQLite Data Access Components
//  Copyright © 2008-2012 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I LiteDac.inc}
unit LiteCallUni;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes, SysUtils, SyncObjs,
{$IFDEF POSIX}
  Posix.Dlfcn,
{$ENDIF}
{$IFDEF UNIX}
  dl,
{$ENDIF}
{$IFDEF CLR}
  System.Text, System.Runtime.InteropServices,
{$ELSE}
  CLRClasses,
{$ENDIF}
  CRTypes;

const
  SQLiteDLLName = {$IFDEF MSWINDOWS}
                    'sqlite3.dll';
                  {$ELSE}
                    {$IFDEF MACOS}
                    'libsqlite3.dylib';
                    {$ELSE}
                    'libsqlite3.so';
                    {$ENDIF}
                  {$ENDIF}

const
  // Result Codes
  SQLITE_OK         =  0;   // Successful result
  SQLITE_ERROR      =  1;   // SQL error or missing database
  SQLITE_INTERNAL   =  2;   // Internal logic error in SQLite
  SQLITE_PERM       =  3;   // Access permission denied
  SQLITE_ABORT      =  4;   // Callback routine requested an abort
  SQLITE_BUSY       =  5;   // The database file is locked
  SQLITE_LOCKED     =  6;   // A table in the database is locked
  SQLITE_NOMEM      =  7;   // A malloc() failed
  SQLITE_READONLY   =  8;   // Attempt to write a readonly database
  SQLITE_INTERRUPT  =  9;   // Operation terminated by sqlite3_interrupt()
  SQLITE_IOERR      = 10;   // Some kind of disk I/O error occurred
  SQLITE_CORRUPT    = 11;   // The database disk image is malformed
  SQLITE_NOTFOUND   = 12;   // NOT USED. Table or record not found
  SQLITE_FULL       = 13;   // Insertion failed because database is full
  SQLITE_CANTOPEN   = 14;   // Unable to open the database file
  SQLITE_PROTOCOL   = 15;   // NOT USED. Database lock protocol error
  SQLITE_EMPTY      = 16;   // Database is empty
  SQLITE_SCHEMA     = 17;   // The database schema changed
  SQLITE_TOOBIG     = 18;   // String or BLOB exceeds size limit
  SQLITE_CONSTRAINT = 19;   // Abort due to constraint violation
  SQLITE_MISMATCH   = 20;   // Data type mismatch
  SQLITE_MISUSE     = 21;   // Library used incorrectly
  SQLITE_NOLFS      = 22;   // Uses OS features not supported on host
  SQLITE_AUTH       = 23;   // Authorization denied
  SQLITE_FORMAT     = 24;   // Auxiliary database format error
  SQLITE_RANGE      = 25;   // 2nd parameter to sqlite3_bind out of range
  SQLITE_NOTADB     = 26;   // File opened that is not a database file
  SQLITE_ROW        = 100;  // sqlite3_step() has another row ready
  SQLITE_DONE       = 101;  // sqlite3_step() has finished executing

  // extended error codes

  SQLITE_IOERR_READ              = SQLITE_IOERR + 256;
  SQLITE_IOERR_SHORT_READ        = SQLITE_IOERR + 2*256;
  SQLITE_IOERR_WRITE             = SQLITE_IOERR + 3*256;
  SQLITE_IOERR_FSYNC             = SQLITE_IOERR + 4*256;
  SQLITE_IOERR_DIR_FSYNC         = SQLITE_IOERR + 5*256;
  SQLITE_IOERR_TRUNCATE          = SQLITE_IOERR + 6*256;
  SQLITE_IOERR_FSTAT             = SQLITE_IOERR + 7*256;
  SQLITE_IOERR_UNLOCK            = SQLITE_IOERR + 8*256;
  SQLITE_IOERR_RDLOCK            = SQLITE_IOERR + 9*256;
  SQLITE_IOERR_DELETE            = SQLITE_IOERR + 10*256;
  SQLITE_IOERR_BLOCKED           = SQLITE_IOERR + 11*256;
  SQLITE_IOERR_NOMEM             = SQLITE_IOERR + 12*256;
  SQLITE_IOERR_ACCESS            = SQLITE_IOERR + 13*256;
  SQLITE_IOERR_CHECKRESERVEDLOCK = SQLITE_IOERR + 14*256;
  SQLITE_IOERR_LOCK              = SQLITE_IOERR + 15*256;
  SQLITE_IOERR_CLOSE             = SQLITE_IOERR + 16*256;
  SQLITE_IOERR_DIR_CLOSE         = SQLITE_IOERR + 17*256;
  SQLITE_IOERR_SHMOPEN           = SQLITE_IOERR + 18*256;
  SQLITE_IOERR_SHMSIZE           = SQLITE_IOERR + 19*256;
  SQLITE_IOERR_SHMLOCK           = SQLITE_IOERR + 20*256;
  SQLITE_IOERR_SHMMAP            = SQLITE_IOERR + 21*256;
  SQLITE_IOERR_SEEK              = SQLITE_IOERR + 22*256;
  SQLITE_LOCKED_SHAREDCACHE      = SQLITE_LOCKED + 256;
  SQLITE_BUSY_RECOVERY           = SQLITE_BUSY + 256;
  SQLITE_CANTOPEN_NOTEMPDIR      = SQLITE_CANTOPEN + 256;
  SQLITE_CANTOPEN_ISDIR          = SQLITE_CANTOPEN + 2*256;
  SQLITE_CORRUPT_VTAB            = SQLITE_CORRUPT + 256;
  SQLITE_READONLY_RECOVERY       = SQLITE_READONLY + 256;
  SQLITE_READONLY_CANTLOCK       = SQLITE_READONLY + 2*256;
  SQLITE_ABORT_ROLLBACK          = SQLITE_ABORT + 2*256;

  // Fundamental Datatypes
  SQLITE_INTEGER = 1;
  SQLITE_FLOAT   = 2;
  SQLITE_TEXT    = 3;
  SQLITE_BLOB    = 4;
  SQLITE_NULL    = 5;

  // Special destructor types
  SQLITE_STATIC: IntPtr    = IntPtr(0);
  SQLITE_TRANSIENT: IntPtr = IntPtr(-1);

  SQLITE_UTF8       = 1;
  SQLITE_UTF16LE    = 2;
  SQLITE_UTF16BE    = 3;
  SQLITE_UTF16      = 4;    // Use native byte order
  SQLITE_ANY        = 5;

type
  u8                  = byte;
  u16                 = word;
  u32                 = longword;
  i16                 = SmallInt;
  i64                 = Int64;

  pFuncDef = ^FuncDef;
  FuncDef = record
    nArg: i16;            // Number of arguments.  -1 means unlimited */
    iPrefEnc: u8;         // Preferred text encoding (SQLITE_UTF8, 16LE, 16BE) */
    flags: u8;            // Some combination of SQLITE_FUNC_* */
    pUserData: IntPtr;    // User data parameter */
    pNext: IntPtr;        // Next function with same name */
    xFunc: IntPtr;        // Regular function */
    xStep: IntPtr;        // Aggregate step */
    xFinalize: IntPtr;    // Aggregate finalizer */
    zName: IntPtr;        // SQL name of the function. */
    pHash: IntPtr;        // Next with a different name but the same hash */
    pDestructor: IntPtr;  // Reference counted destructor function */
  end;

  sqlite3_context = record
  {$IFNDEF CLR}
    pFunc: pFuncDef;      // Pointer to function information.  MUST BE FIRST */
  {$ELSE}
    pFunc: IntPtr;
  {$ENDIF}
    pVdbeFunc: IntPtr;    // Auxilary data, if created. */
    //Mem s;                // The return value is stored here */
    //pMem: IntPtr;         // Memory cell used to store aggregate context */
    //pColl: IntPtr;        // Collating sequence */
    //isError: integer;     // Error code returned by the function. */
    //skipFlag: integer;    // Skip skip accumulator loading if true */
  end;

  TLiteEncryptionAlgorithm = (leTripleDES, leBlowfish, leAES128, leAES192, leAES256, leCast128, leRC4, leDefault);

  Tsqlite3 = IntPtr;
  Tsqlite3_stmt = IntPtr;
  Tsqlite3_context = {$IFNDEF CLR}^sqlite3_context{$ELSE}IntPtr{$ENDIF};
  Tsqlite3_value = IntPtr;

  TCallBackLiteCollation = function (
    pUserData: IntPtr;
    StrSize1: Integer; const pStr1: IntPtr;
    StrSize2: Integer; const pStr2: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  TCallBackLiteFunction = procedure (
    Context: Tsqlite3_context;
    ParamCount: Integer;
    pData: IntPtr
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  // functions
  Tsqlite3_open = function(
    filename: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF};    // Database filename (UTF-8)
    out ppDb: Tsqlite3      // OUT: SQLite db handle
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_open16 = function(
    filename: {$IFNDEF CLR}PWideChar{$ELSE}IntPtr{$ENDIF};    // Database filename (UTF-16)
    out ppDb: Tsqlite3      // OUT: SQLite db handle
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_open_v2 = function(
    filename: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF};    // Database filename (UTF-8)
    out ppDb: Tsqlite3;     // OUT: SQLite db handle
    flags: Integer;         // Flags
    zVfs: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}         // Name of VFS module to use
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_close = function(
    pDb: Tsqlite3
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_errcode = function(
    pDb: Tsqlite3
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_extended_errcode = function(
    pDb: Tsqlite3
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_extended_result_codes = function(
    pDb: Tsqlite3;
    onoff: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_errmsg = function(
    pDb: Tsqlite3
  ): {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_last_insert_rowid = function(
    pDb: Tsqlite3
  ): Int64; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_changes = function(
    pDb: Tsqlite3
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_prepare_v2 = function(
    db: Tsqlite3;           // Database handle
    zSql: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF};        // SQL statement, UTF-8 encoded
    nByte: Integer;         // Maximum length of zSql in bytes.
    out ppStmt: Tsqlite3_stmt;  // OUT: Statement handle
    pzTail: IntPtr          // OUT: Pointer to unused portion of zSql
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_step = function(
    pStmt: Tsqlite3_stmt
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_reset = function(
    pStmt: Tsqlite3_stmt
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_finalize = function(
    pStmt: Tsqlite3_stmt
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_count = function(
    pStmt: Tsqlite3_stmt
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_type = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_name = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_origin_name = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_table_name = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_database_name = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_decltype = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_blob = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): IntPtr; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_bytes = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_double = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): double; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_int = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_int64 = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): int64; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_column_text = function(
    pStmt: Tsqlite3_stmt; iCol: Integer
  ): {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_bind_parameter_count = function(
    pStmt: Tsqlite3_stmt
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_bind_blob = function(
    pStmt: Tsqlite3_stmt; Index: Integer; pBlob: IntPtr; Size: Integer; pDestrType: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_bind_double = function(
    pStmt: Tsqlite3_stmt; Index: Integer; Value: Double
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_bind_int = function(
    pStmt: Tsqlite3_stmt; Index: Integer; Value: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_bind_int64 = function(
    pStmt: Tsqlite3_stmt; Index: Integer; Value: Int64
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_bind_null = function(
    pStmt: Tsqlite3_stmt; Index: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_bind_text = function(
    pStmt: Tsqlite3_stmt; Index: Integer; Value: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; Size: Integer; pDestrType: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_blob = procedure(
    pContext: Tsqlite3_context; pBlob: IntPtr; Size: Integer; pDestrType: IntPtr
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_double = procedure(
    pContext: Tsqlite3_context; Value: Double
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_error = procedure(
    pContext: Tsqlite3_context; pMsg: IntPtr; Size: Integer
  ); {$IFNDEF CLR}cdecl;{$ENDIF}
  
  _sqlite3_result_error16 = procedure(
    pContext: Tsqlite3_context; pMsg: IntPtr; Size: Integer
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_error_toobig = procedure(
    pContext: Tsqlite3_context
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_error_nomem = procedure(
    pContext: Tsqlite3_context
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_error_code = procedure(
    pContext: Tsqlite3_context; ErrorCode: Integer
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_int = procedure(
    pContext: Tsqlite3_context; Value: Integer
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_int64 = procedure(
    pContext: Tsqlite3_context; Value: Int64
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_null = procedure(
    pContext: Tsqlite3_context
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_text = procedure(
    pContext: Tsqlite3_context; pStr: IntPtr; Size: Integer; pDestrType: IntPtr
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_text16 = procedure(
    pContext: Tsqlite3_context; pStr: IntPtr; Size: Integer; pDestrType: IntPtr
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_text16le = procedure(
    pContext: Tsqlite3_context; pStr: IntPtr; Size: Integer; pDestrType: IntPtr
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_text16be = procedure(
    pContext: Tsqlite3_context; pStr: IntPtr; Size: Integer; pDestrType: IntPtr
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_value = procedure(
    pContext: Tsqlite3_context; Value: Tsqlite3_value
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_result_zeroblob = procedure(
    pContext: Tsqlite3_context; Size: Integer
  ); {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_value_blob = function(
    pValue: IntPtr
  ): IntPtr; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_value_bytes = function(
    pValue: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_value_bytes16 = function(
    pValue: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_value_double = function(
    pValue: IntPtr
  ): Double; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_value_int = function(
    pValue: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_value_int64 = function(
    pValue: IntPtr
  ): Int64; {$IFNDEF CLR}cdecl;{$ENDIF}


  _sqlite3_value_text = function(
    pValue: IntPtr
  ): IntPtr; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_value_text16 = function(
    pValue: IntPtr
  ): IntPtr; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_value_type = function(
    pValue: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_user_data = function(
    pContext: Tsqlite3_context
  ): IntPtr; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_libversion = function(
  ): {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_libversion_number = function(
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_create_collation = function(
    pSQLite: Tsqlite3; zName: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; eTextRep: Integer; userData: IntPtr; func: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_create_collation16 = function(
    pSQLite: Tsqlite3; zName: {$IFNDEF CLR}PWideChar{$ELSE}IntPtr{$ENDIF}; eTextRep: Integer; userData: IntPtr; func: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_create_function = function(
    pSQLite: Tsqlite3; zFunctionName: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; nArg: Integer; eTextRep: Integer; pApp: IntPtr; xFunc: IntPtr; xStep: IntPtr; xFinal: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_create_function16 = function(
    pSQLite: Tsqlite3; zFunctionName: {$IFNDEF CLR}PWideChar{$ELSE}IntPtr{$ENDIF}; nArg: Integer; eTextRep: Integer; pApp: IntPtr; xFunc: IntPtr; xStep: IntPtr; xFinal: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_enable_shared_cache = function(
    Value: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_busy_timeout = function(
    pSQLite: Tsqlite3; MilliSeconds: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_busy_handler = function(
    pSQLite: Tsqlite3; func: IntPtr; userData: IntPtr
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_key = function(
    pSQLite: Tsqlite3; key: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; size: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  _sqlite3_rekey = function(
    pSQLite: Tsqlite3; newkey: {$IFNDEF CLR}PAnsiChar{$ELSE}IntPtr{$ENDIF}; size: Integer
  ): Integer; {$IFNDEF CLR}cdecl;{$ENDIF}

  TSQLite3API = class
  private

  {$IFDEF MSWINDOWS}
    hLiteLib: HMODULE;
  {$ENDIF}
  {$IFDEF POSIX}
    hLiteLib: NativeUInt;
  {$ENDIF}
  {$IFDEF UNIX}
    hLiteLib: IntPtr;
  {$ENDIF}

    FClientLibrary: _string;
    FDirect: boolean;
    FInitialized: Boolean;

    procedure LoadClientLibrary;
    procedure UnLoadClientLibrary;

  public
    SQLite: Tsqlite3;

    sqlite3_open: Tsqlite3_open;
    sqlite3_open16: _sqlite3_open16;         
    sqlite3_open_v2: _sqlite3_open_v2;
    sqlite3_close: _sqlite3_close;
    sqlite3_errcode: _sqlite3_errcode;
    sqlite3_extended_errcode: _sqlite3_extended_errcode;
    sqlite3_extended_result_codes: _sqlite3_extended_result_codes;
    sqlite3_errmsg: _sqlite3_errmsg;
    sqlite3_last_insert_rowid: _sqlite3_last_insert_rowid;
    sqlite3_changes: _sqlite3_changes;
    sqlite3_prepare_v2: _sqlite3_prepare_v2;
    sqlite3_step: _sqlite3_step;
    sqlite3_reset: _sqlite3_reset;
    sqlite3_finalize: _sqlite3_finalize;
    sqlite3_column_count: _sqlite3_column_count;
    sqlite3_column_type: _sqlite3_column_type;
    sqlite3_column_name: _sqlite3_column_name;
    sqlite3_column_origin_name: _sqlite3_column_origin_name;
    sqlite3_column_table_name: _sqlite3_column_table_name;
    sqlite3_column_database_name: _sqlite3_column_database_name;
    sqlite3_column_decltype: _sqlite3_column_decltype;
    sqlite3_column_blob: _sqlite3_column_blob;
    sqlite3_column_bytes: _sqlite3_column_bytes;
    sqlite3_column_double: _sqlite3_column_double;
    sqlite3_column_int: _sqlite3_column_int;
    sqlite3_column_int64: _sqlite3_column_int64;
    sqlite3_column_text: _sqlite3_column_text;
    sqlite3_bind_parameter_count: _sqlite3_bind_parameter_count;
    sqlite3_bind_blob: _sqlite3_bind_blob;
    sqlite3_bind_double: _sqlite3_bind_double;
    sqlite3_bind_int: _sqlite3_bind_int;
    sqlite3_bind_int64: _sqlite3_bind_int64;
    sqlite3_bind_null: _sqlite3_bind_null;
    sqlite3_bind_text: _sqlite3_bind_text;
    sqlite3_result_blob: _sqlite3_result_blob;
    sqlite3_result_double: _sqlite3_result_double;
    sqlite3_result_error: _sqlite3_result_error;
    sqlite3_result_error16: _sqlite3_result_error16;
    sqlite3_result_error_toobig: _sqlite3_result_error_toobig;
    sqlite3_result_error_nomem: _sqlite3_result_error_nomem;
    sqlite3_result_error_code: _sqlite3_result_error_code;
    sqlite3_result_int: _sqlite3_result_int;
    sqlite3_result_int64: _sqlite3_result_int64;
    sqlite3_result_null: _sqlite3_result_null;
    sqlite3_result_text: _sqlite3_result_text;
    sqlite3_result_text16: _sqlite3_result_text16;
    sqlite3_result_text16le: _sqlite3_result_text16le;
    sqlite3_result_text16be: _sqlite3_result_text16be;
    sqlite3_result_value: _sqlite3_result_value;
    sqlite3_result_zeroblob: _sqlite3_result_zeroblob;
    sqlite3_value_blob: _sqlite3_value_blob;
    sqlite3_value_bytes: _sqlite3_value_bytes;
    sqlite3_value_bytes16: _sqlite3_value_bytes16;
    sqlite3_value_double: _sqlite3_value_double;
    sqlite3_value_int: _sqlite3_value_int;
    sqlite3_value_int64: _sqlite3_value_int64;
    sqlite3_value_text: _sqlite3_value_text;
    sqlite3_value_text16: _sqlite3_value_text16;
    sqlite3_value_type: _sqlite3_value_type;
    sqlite3_user_data: _sqlite3_user_data;
    sqlite3_libversion: _sqlite3_libversion;
    sqlite3_libversion_number: _sqlite3_libversion_number;
    sqlite3_create_collation: _sqlite3_create_collation;
    sqlite3_create_collation16: _sqlite3_create_collation16;
    sqlite3_create_function: _sqlite3_create_function;
    sqlite3_create_function16: _sqlite3_create_function16;
    sqlite3_enable_shared_cache: _sqlite3_enable_shared_cache;
    sqlite3_busy_timeout: _sqlite3_busy_timeout;
    sqlite3_busy_handler: _sqlite3_busy_handler;
    sqlite3_key: _sqlite3_key;
    sqlite3_rekey: _sqlite3_rekey;

    constructor Create;
    destructor Destroy; override;

    procedure Initialize;
    procedure UnInitialize;

    procedure GetLiteErrorCode(var ErrorCode: integer);
    procedure GetLiteErrorMsg(var ErrorMsg: _string);
    procedure GetPredefinedErrorMsg(ErrorCode: integer; var ErrorMsg: _string);
    function IsMetaDataAPIAvailable: boolean;

  {$IFNDEF CLR}
    function GetProc(const Name: string; NotLinkPtr: IntPtr): IntPtr; overload;
    function GetProc(const Name: string): IntPtr; overload;
  {$ENDIF}

    procedure Assign(Source: TSQLite3API); virtual;

    property ClientLibrary: _string read FClientLibrary write FClientLibrary;
    property Initialized: boolean read FInitialized;
    property Direct: boolean read FDirect write FDirect;
  end;

const
  DefaultEncryptionAlgorithm = leDefault;

var
  LockInit: TCriticalSection;

implementation

uses
{$IFDEF CLR}
{$IFNDEF UNIDACPRO}
  LiteCallCLR,
{$ELSE}
  LiteCallCLRUni,
{$ENDIF}
{$ELSE}
{$IFNDEF NOSTATIC}
{$IFNDEF UNIDACPRO}
  LiteStatic,
{$ELSE}
  LiteStaticUni,
{$ENDIF}
{$ENDIF}
{$ENDIF}
  CRFunctions;

function NotLink: integer;
begin
  raise Exception.Create('SQLite function is not linked');
end;

function NotLinkEncryption: integer;
begin
  raise Exception.Create('SQLite DLL that you are using does not support SQLite database encryption. ' + #13 +
                         'Please download a new DLL or recompile the existing one with encryption support. ');
end;

procedure InitFunctions(const API: TSQLite3API);
begin
{$IFDEF CLR}
  API.sqlite3_open := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_open;
  API.sqlite3_open16 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_open16;
  API.sqlite3_open_v2 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_open_v2;
  API.sqlite3_close := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_close;
  API.sqlite3_errcode := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_errcode;
  API.sqlite3_extended_errcode := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_extended_errcode;
  API.sqlite3_extended_result_codes := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_extended_result_codes;
  API.sqlite3_errmsg := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_errmsg;
  API.sqlite3_last_insert_rowid := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_last_insert_rowid;
  API.sqlite3_changes := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_changes;
  API.sqlite3_prepare_v2 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_prepare_v2;
  API.sqlite3_step := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_step;
  API.sqlite3_reset := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_reset;
  API.sqlite3_finalize := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_finalize;
  API.sqlite3_column_count := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_count;
  API.sqlite3_column_type := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_type;
  API.sqlite3_column_name := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_name;
  API.sqlite3_column_origin_name := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_origin_name;
  API.sqlite3_column_table_name := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_table_name;
  API.sqlite3_column_database_name := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_database_name;
  API.sqlite3_column_decltype := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_decltype;
  API.sqlite3_column_blob := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_blob;
  API.sqlite3_column_bytes := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_bytes;
  API.sqlite3_column_double := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_double;
  API.sqlite3_column_int := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_int;
  API.sqlite3_column_int64 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_int64;
  API.sqlite3_column_text := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_column_text;
  API.sqlite3_bind_parameter_count := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_bind_parameter_count;
  API.sqlite3_bind_blob := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_bind_blob;
  API.sqlite3_bind_double := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_bind_double;
  API.sqlite3_bind_int := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_bind_int;
  API.sqlite3_bind_int64 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_bind_int64;
  API.sqlite3_bind_null := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_bind_null;
  API.sqlite3_bind_text := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_bind_text;
  API.sqlite3_result_blob := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_blob;
  API.sqlite3_result_double := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_double;
  API.sqlite3_result_error := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_error;
  API.sqlite3_result_error16 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_error16;
  API.sqlite3_result_error_toobig := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_error_toobig;
  API.sqlite3_result_error_nomem := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_error_nomem;
  API.sqlite3_result_error_code := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_error_code;
  API.sqlite3_result_int := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_int;
  API.sqlite3_result_int64 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_int64;
  API.sqlite3_result_null := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_null;
  API.sqlite3_result_text := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_text;
  API.sqlite3_result_text16 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_text16;
  API.sqlite3_result_text16le := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_text16le;
  API.sqlite3_result_text16be := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_text16be;
  API.sqlite3_result_value := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_value;
  API.sqlite3_result_zeroblob := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_result_zeroblob;
  API.sqlite3_value_blob := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_blob;
  API.sqlite3_value_bytes := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_bytes;
  API.sqlite3_value_bytes16 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_bytes16;
  API.sqlite3_value_double := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_double;
  API.sqlite3_value_int := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_int;
  API.sqlite3_value_int64 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_int64;
  API.sqlite3_value_text := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_text;
  API.sqlite3_value_text16 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_text16;
  API.sqlite3_value_type := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_value_type;
  API.sqlite3_user_data := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_user_data;
  API.sqlite3_libversion := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_libversion;
  API.sqlite3_libversion_number := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_libversion_number;
  API.sqlite3_create_collation := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_create_collation;
  API.sqlite3_create_collation16 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_create_collation16;
  API.sqlite3_create_function := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_create_function;
  API.sqlite3_create_function16 := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_create_function16;
  API.sqlite3_enable_shared_cache := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_enable_shared_cache;
  API.sqlite3_busy_timeout := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_busy_timeout;
  API.sqlite3_busy_handler := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_busy_handler;
  API.sqlite3_key := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_key;
  API.sqlite3_rekey := {$IFNDEF UNIDACPRO}LiteCallCLR{$ELSE}LiteCallCLRUni{$ENDIF}.sqlite3_rekey;
{$ELSE}
  API.sqlite3_open := API.GetProc('sqlite3_open');
  API.sqlite3_open16 := API.GetProc('sqlite3_open16');
  API.sqlite3_open_v2 := API.GetProc('sqlite3_open_v2');
  API.sqlite3_close := API.GetProc('sqlite3_close');
  API.sqlite3_errcode := API.GetProc('sqlite3_errcode');
  API.sqlite3_extended_errcode := API.GetProc('sqlite3_extended_errcode');
  API.sqlite3_extended_result_codes := API.GetProc('sqlite3_extended_result_codes');
  API.sqlite3_errmsg := API.GetProc('sqlite3_errmsg');
  API.sqlite3_last_insert_rowid := API.GetProc('sqlite3_last_insert_rowid');
  API.sqlite3_changes := API.GetProc('sqlite3_changes');
  API.sqlite3_prepare_v2 := API.GetProc('sqlite3_prepare_v2');
  API.sqlite3_step := API.GetProc('sqlite3_step');
  API.sqlite3_reset := API.GetProc('sqlite3_reset');
  API.sqlite3_finalize := API.GetProc('sqlite3_finalize');
  API.sqlite3_column_count := API.GetProc('sqlite3_column_count');
  API.sqlite3_column_type := API.GetProc('sqlite3_column_type');
  API.sqlite3_column_name := API.GetProc('sqlite3_column_name');
  API.sqlite3_column_origin_name := API.GetProc('sqlite3_column_origin_name');
  API.sqlite3_column_table_name := API.GetProc('sqlite3_column_table_name');
  API.sqlite3_column_database_name := API.GetProc('sqlite3_column_database_name');
  API.sqlite3_column_decltype := API.GetProc('sqlite3_column_decltype');
  API.sqlite3_column_blob := API.GetProc('sqlite3_column_blob');
  API.sqlite3_column_bytes := API.GetProc('sqlite3_column_bytes');
  API.sqlite3_column_double := API.GetProc('sqlite3_column_double');
  API.sqlite3_column_int := API.GetProc('sqlite3_column_int');
  API.sqlite3_column_int64 := API.GetProc('sqlite3_column_int64');
  API.sqlite3_column_text := API.GetProc('sqlite3_column_text');
  API.sqlite3_bind_parameter_count := API.GetProc('sqlite3_bind_parameter_count');
  API.sqlite3_bind_blob := API.GetProc('sqlite3_bind_blob');
  API.sqlite3_bind_double := API.GetProc('sqlite3_bind_double');
  API.sqlite3_bind_int := API.GetProc('sqlite3_bind_int');
  API.sqlite3_bind_int64 := API.GetProc('sqlite3_bind_int64');
  API.sqlite3_bind_null := API.GetProc('sqlite3_bind_null');
  API.sqlite3_bind_text := API.GetProc('sqlite3_bind_text');
  API.sqlite3_result_blob := API.GetProc('sqlite3_result_blob');
  API.sqlite3_result_double := API.GetProc('sqlite3_result_double');
  API.sqlite3_result_error := API.GetProc('sqlite3_result_error');
  API.sqlite3_result_error16 := API.GetProc('sqlite3_result_error16');
  API.sqlite3_result_error_toobig := API.GetProc('sqlite3_result_error_toobig');
  API.sqlite3_result_error_nomem := API.GetProc('sqlite3_result_error_nomem');
  API.sqlite3_result_error_code := API.GetProc('sqlite3_result_error_code');
  API.sqlite3_result_int := API.GetProc('sqlite3_result_int');
  API.sqlite3_result_int64 := API.GetProc('sqlite3_result_int64');
  API.sqlite3_result_null := API.GetProc('sqlite3_result_null');
  API.sqlite3_result_text := API.GetProc('sqlite3_result_text');
  API.sqlite3_result_text16 := API.GetProc('sqlite3_result_text16');
  API.sqlite3_result_text16le := API.GetProc('sqlite3_result_text16le');
  API.sqlite3_result_text16be := API.GetProc('sqlite3_result_text16be');
  API.sqlite3_result_value := API.GetProc('sqlite3_result_value');
  API.sqlite3_result_zeroblob := API.GetProc('sqlite3_result_zeroblob');
  API.sqlite3_value_blob := API.GetProc('sqlite3_value_blob');;
  API.sqlite3_value_bytes := API.GetProc('sqlite3_value_bytes');
  API.sqlite3_value_bytes16 := API.GetProc('sqlite3_value_bytes16');
  API.sqlite3_value_double := API.GetProc('sqlite3_value_double');
  API.sqlite3_value_int := API.GetProc('sqlite3_value_int');
  API.sqlite3_value_int64 := API.GetProc('sqlite3_value_int64');
  API.sqlite3_value_text := API.GetProc('sqlite3_value_text');
  API.sqlite3_value_text16 := API.GetProc('sqlite3_value_text16');
  API.sqlite3_value_type := API.GetProc('sqlite3_value_type');
  API.sqlite3_user_data := API.GetProc('sqlite3_user_data');
  API.sqlite3_libversion := API.GetProc('sqlite3_libversion');
  API.sqlite3_libversion_number := API.GetProc('sqlite3_libversion_number');
  API.sqlite3_create_collation := API.GetProc('sqlite3_create_collation');
  API.sqlite3_create_collation16 := API.GetProc('sqlite3_create_collation16');
  API.sqlite3_create_function := API.GetProc('sqlite3_create_function');
  API.sqlite3_create_function16 := API.GetProc('sqlite3_create_function16');
  API.sqlite3_enable_shared_cache := API.GetProc('sqlite3_enable_shared_cache');
  API.sqlite3_busy_timeout := API.GetProc('sqlite3_busy_timeout');
  API.sqlite3_busy_handler := API.GetProc('sqlite3_busy_handler');
  API.sqlite3_key := API.GetProc('sqlite3_key', @NotLinkEncryption);
  API.sqlite3_rekey := API.GetProc('sqlite3_rekey', @NotLinkEncryption);
{$ENDIF}
end;

{ TSQLite3API }

procedure TSQLite3API.Assign(Source: TSQLite3API);
begin
  SQLite := Source.SQLite;

  sqlite3_open := Source.sqlite3_open;
  sqlite3_open16 := Source.sqlite3_open16;
  sqlite3_open_v2 := Source.sqlite3_open_v2;
  sqlite3_close := Source.sqlite3_close;
  sqlite3_errcode := Source.sqlite3_errcode;
  sqlite3_extended_errcode := Source.sqlite3_extended_errcode;
  sqlite3_extended_result_codes := Source.sqlite3_extended_result_codes;
  sqlite3_errmsg := Source.sqlite3_errmsg;
  sqlite3_last_insert_rowid := Source.sqlite3_last_insert_rowid;
  sqlite3_changes := Source.sqlite3_changes;
  sqlite3_prepare_v2 := Source.sqlite3_prepare_v2;
  sqlite3_step := Source.sqlite3_step;
  sqlite3_reset := Source.sqlite3_reset;
  sqlite3_finalize := Source.sqlite3_finalize;
  sqlite3_column_count := Source.sqlite3_column_count;
  sqlite3_column_type := Source.sqlite3_column_type;
  sqlite3_column_name := Source.sqlite3_column_name;
  sqlite3_column_origin_name := Source.sqlite3_column_origin_name;
  sqlite3_column_table_name := Source.sqlite3_column_table_name;
  sqlite3_column_database_name := Source.sqlite3_column_database_name;
  sqlite3_column_decltype := Source.sqlite3_column_decltype;
  sqlite3_column_blob := Source.sqlite3_column_blob;
  sqlite3_column_bytes := Source.sqlite3_column_bytes;
  sqlite3_column_double := Source.sqlite3_column_double;
  sqlite3_column_int := Source.sqlite3_column_int;
  sqlite3_column_int64 := Source.sqlite3_column_int64;
  sqlite3_column_text := Source.sqlite3_column_text;
  sqlite3_bind_parameter_count := Source.sqlite3_bind_parameter_count;
  sqlite3_bind_blob := Source.sqlite3_bind_blob;
  sqlite3_bind_double := Source.sqlite3_bind_double;
  sqlite3_bind_int := Source.sqlite3_bind_int;
  sqlite3_bind_int64 := Source.sqlite3_bind_int64;
  sqlite3_bind_null := Source.sqlite3_bind_null;
  sqlite3_bind_text := Source.sqlite3_bind_text;
  sqlite3_result_blob := Source.sqlite3_result_blob;
  sqlite3_result_double := Source.sqlite3_result_double;
  sqlite3_result_error := Source.sqlite3_result_error;
  sqlite3_result_error16 := Source.sqlite3_result_error16;
  sqlite3_result_error_toobig := Source.sqlite3_result_error_toobig;
  sqlite3_result_error_nomem := Source.sqlite3_result_error_nomem;
  sqlite3_result_error_code := Source.sqlite3_result_error_code;
  sqlite3_result_int := Source.sqlite3_result_int;
  sqlite3_result_int64 := Source.sqlite3_result_int64;
  sqlite3_result_null := Source.sqlite3_result_null;
  sqlite3_result_text := Source.sqlite3_result_text;
  sqlite3_result_text16 := Source.sqlite3_result_text16;
  sqlite3_result_text16le := Source.sqlite3_result_text16le;
  sqlite3_result_text16be := Source.sqlite3_result_text16be;
  sqlite3_result_value := Source.sqlite3_result_value;
  sqlite3_result_zeroblob := Source.sqlite3_result_zeroblob;
  sqlite3_value_blob := Source.sqlite3_value_blob;
  sqlite3_value_bytes := Source.sqlite3_value_bytes;
  sqlite3_value_bytes16 := Source.sqlite3_value_bytes16;
  sqlite3_value_double := Source.sqlite3_value_double;
  sqlite3_value_int := Source.sqlite3_value_int;
  sqlite3_value_int64 := Source.sqlite3_value_int64;
  sqlite3_value_text := Source.sqlite3_value_text;
  sqlite3_value_text16 := Source.sqlite3_value_text16;
  sqlite3_value_type := Source.sqlite3_value_type;
  sqlite3_user_data := Source.sqlite3_user_data;
  sqlite3_libversion := Source.sqlite3_libversion;
  sqlite3_libversion_number := Source.sqlite3_libversion_number;
  sqlite3_create_collation := Source.sqlite3_create_collation;
  sqlite3_create_collation16 := Source.sqlite3_create_collation16;
  sqlite3_create_function := Source.sqlite3_create_function;
  sqlite3_create_function16 := Source.sqlite3_create_function16;
  sqlite3_enable_shared_cache := Source.sqlite3_enable_shared_cache;
  sqlite3_busy_timeout:= Source.sqlite3_busy_timeout;
  sqlite3_busy_handler:= Source.sqlite3_busy_handler;
{$IFDEF CODEC}
  sqlite3_key := Source.sqlite3_key;
  sqlite3_rekey := Source.sqlite3_rekey;
{$ENDIF}
end;

constructor TSQLite3API.Create;
begin
  inherited;

{$IFDEF UNIX}
  hLiteLib := nil;
{$ELSE}
  hLiteLib := 0;
{$ENDIF}  

{$IFNDEF CLR}
  sqlite3_open := @NotLink;
  sqlite3_open16 := @NotLink;
  sqlite3_open_v2 := @NotLink;
  sqlite3_close := @NotLink;
  sqlite3_errcode := @NotLink;
  sqlite3_extended_errcode := @NotLink;
  sqlite3_extended_result_codes := @NotLink;
  sqlite3_errmsg := @NotLink;
  sqlite3_last_insert_rowid := @NotLink;
  sqlite3_changes := @NotLink;
  sqlite3_prepare_v2 := @NotLink;
  sqlite3_step := @NotLink;
  sqlite3_reset := @NotLink;
  sqlite3_finalize := @NotLink;
  sqlite3_column_count := @NotLink;
  sqlite3_column_type := @NotLink;
  sqlite3_column_name := @NotLink;
  sqlite3_column_origin_name := @NotLink;
  sqlite3_column_table_name := @NotLink;
  sqlite3_column_database_name := @NotLink;
  sqlite3_column_decltype := @NotLink;
  sqlite3_column_blob := @NotLink;
  sqlite3_column_bytes := @NotLink;
  sqlite3_column_double := @NotLink;
  sqlite3_column_int := @NotLink;
  sqlite3_column_int64 := @NotLink;
  sqlite3_column_text := @NotLink;
  sqlite3_bind_parameter_count := @NotLink;
  sqlite3_bind_blob := @NotLink;
  sqlite3_bind_double := @NotLink;
  sqlite3_bind_int := @NotLink;
  sqlite3_bind_int64 := @NotLink;
  sqlite3_bind_null := @NotLink;
  sqlite3_bind_text := @NotLink;
  sqlite3_result_blob := @NotLink;
  sqlite3_result_double := @NotLink;
  sqlite3_result_error := @NotLink;
  sqlite3_result_error16 := @NotLink;
  sqlite3_result_error_toobig := @NotLink;
  sqlite3_result_error_nomem := @NotLink;
  sqlite3_result_error_code := @NotLink;
  sqlite3_result_int := @NotLink;
  sqlite3_result_int64 := @NotLink;
  sqlite3_result_null := @NotLink;
  sqlite3_result_text := @NotLink;
  sqlite3_result_text16 := @NotLink;
  sqlite3_result_text16le := @NotLink;
  sqlite3_result_text16be := @NotLink;
  sqlite3_result_value := @NotLink;
  sqlite3_result_zeroblob := @NotLink;
  sqlite3_value_blob := @NotLink;
  sqlite3_value_bytes := @NotLink;
  sqlite3_value_bytes16 := @NotLink;
  sqlite3_value_double := @NotLink;
  sqlite3_value_int := @NotLink;
  sqlite3_value_int64 := @NotLink;
  sqlite3_value_text := @NotLink;
  sqlite3_value_text16 := @NotLink;
  sqlite3_value_type := @NotLink;
  sqlite3_user_data := @NotLink;
  sqlite3_libversion := @NotLink;
  sqlite3_libversion_number := @NotLink;
  sqlite3_create_collation := @NotLink;
  sqlite3_create_collation16 := @NotLink;
  sqlite3_create_function := @NotLink;
  sqlite3_create_function16 := @NotLink;
  sqlite3_enable_shared_cache := @NotLink;
  sqlite3_busy_timeout := @NotLink;
  sqlite3_busy_handler := @NotLink;
  sqlite3_key := @NotLinkEncryption;
  sqlite3_rekey := @NotLinkEncryption;
{$ENDIF}

  FInitialized := False;
  FDirect := False;
end;

destructor TSQLite3API.Destroy;
begin
  if FInitialized then
    UnInitialize;
  inherited;
end;

procedure TSQLite3API.GetLiteErrorCode(var ErrorCode: integer);
begin
  if SQLite <> nil then
    ErrorCode := sqlite3_extended_errcode(SQLite)
  else
  // for CheckExtended
    ErrorCode := 0;  
end;

procedure TSQLite3API.GetLiteErrorMsg(var ErrorMsg: _string);
begin
  ErrorMsg := _string(UTF8Decode({$IFDEF CLR}Marshal.PtrToStringAnsi{$ENDIF}(sqlite3_errmsg(SQLite))));
end;

procedure TSQLite3API.GetPredefinedErrorMsg(ErrorCode: integer;
  var ErrorMsg: _string);
begin
  case ErrorCode of
    SQLITE_OK:         ErrorMsg := 'not an error';
    SQLITE_ERROR:      ErrorMsg := 'SQL error or missing database';
    SQLITE_INTERNAL:   ErrorMsg := 'Internal logic error in SQLite';
    SQLITE_PERM:       ErrorMsg := 'Access permission denied';
    SQLITE_ABORT:      ErrorMsg := 'Callback routine requested an abort';
    SQLITE_BUSY:       ErrorMsg := 'The database file is locked';
    SQLITE_LOCKED:     ErrorMsg := 'A table in the database is locked';
    SQLITE_NOMEM:      ErrorMsg := 'A malloc() failed';
    SQLITE_READONLY:   ErrorMsg := 'Attempt to write a readonly database';
    SQLITE_INTERRUPT:  ErrorMsg := 'Operation terminated by sqlite3_interrupt()';
    SQLITE_IOERR:      ErrorMsg := 'Some kind of disk I/O error occurred';
    SQLITE_CORRUPT:    ErrorMsg := 'The database disk image is malformed';
    SQLITE_NOTFOUND:   ErrorMsg := 'NOT USED. Table or record not found';
    SQLITE_FULL:       ErrorMsg := 'Insertion failed because database is full';
    SQLITE_CANTOPEN:   ErrorMsg := 'Unable to open the database file';
    SQLITE_PROTOCOL:   ErrorMsg := 'NOT USED. Database lock protocol error';
    SQLITE_EMPTY:      ErrorMsg := 'Database is empty ';
    SQLITE_SCHEMA:     ErrorMsg := 'The database schema changed';
    SQLITE_TOOBIG:     ErrorMsg := 'String or BLOB exceeds size limit';
    SQLITE_CONSTRAINT: ErrorMsg := 'Abort due to constraint violation';
    SQLITE_MISMATCH:   ErrorMsg := 'Data type mismatch';
    SQLITE_MISUSE:     ErrorMsg := 'Library used incorrectly';
    SQLITE_NOLFS:      ErrorMsg := 'Uses OS features not supported on host';
    SQLITE_AUTH:       ErrorMsg := 'Authorization denied';
    SQLITE_FORMAT:     ErrorMsg := 'Auxiliary database format error';
    SQLITE_RANGE:      ErrorMsg := '2nd parameter to sqlite3_bind out of range';
    SQLITE_NOTADB:     ErrorMsg := 'File opened that is not a database file';
    SQLITE_ROW:        ErrorMsg := 'sqlite3_step() has another row ready';
    SQLITE_DONE:       ErrorMsg := 'sqlite3_step() has finished executing';

    SQLITE_IOERR_READ              :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_READ';
    SQLITE_IOERR_SHORT_READ        :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_SHORT_READ';
    SQLITE_IOERR_WRITE             :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_WRITE';
    SQLITE_IOERR_FSYNC             :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_FSYNC';
    SQLITE_IOERR_DIR_FSYNC         :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_DIR_FSYNC';
    SQLITE_IOERR_TRUNCATE          :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_TRUNCATE';
    SQLITE_IOERR_FSTAT             :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_FSTAT';
    SQLITE_IOERR_UNLOCK            :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_UNLOCK';
    SQLITE_IOERR_RDLOCK            :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_RDLOCK';
    SQLITE_IOERR_DELETE            :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_DELETE';
    SQLITE_IOERR_BLOCKED           :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_BLOCKED';
    SQLITE_IOERR_NOMEM             :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_NOMEM';
    SQLITE_IOERR_ACCESS            :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_ACCESS';
    SQLITE_IOERR_CHECKRESERVEDLOCK :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_CHECKRESERVEDLOCK';
    SQLITE_IOERR_LOCK              :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_LOCK';
    SQLITE_IOERR_CLOSE             :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_CLOSE';
    SQLITE_IOERR_DIR_CLOSE         :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_DIR_CLOSE';
    SQLITE_IOERR_SHMOPEN           :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_SHMOPEN';
    SQLITE_IOERR_SHMSIZE           :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_SHMSIZE';
    SQLITE_IOERR_SHMLOCK           :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_SHMLOCK';
    SQLITE_IOERR_SHMMAP            :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_SHMMAP';
    SQLITE_IOERR_SEEK              :ErrorMsg := 'SQLite extended error: SQLITE_IOERR_SEEK';
    SQLITE_LOCKED_SHAREDCACHE      :ErrorMsg := 'SQLite extended error: SQLITE_LOCKED_SHAREDCACHE';
    SQLITE_BUSY_RECOVERY           :ErrorMsg := 'SQLite extended error: SQLITE_BUSY_RECOVERY';
    SQLITE_CANTOPEN_NOTEMPDIR      :ErrorMsg := 'SQLite extended error: SQLITE_CANTOPEN_NOTEMPDIR';
    SQLITE_CANTOPEN_ISDIR          :ErrorMsg := 'SQLite extended error: SQLITE_CANTOPEN_ISDIR';
    SQLITE_CORRUPT_VTAB            :ErrorMsg := 'SQLite extended error: SQLITE_CORRUPT_VTAB';
    SQLITE_READONLY_RECOVERY       :ErrorMsg := 'SQLite extended error: SQLITE_READONLY_RECOVERY';
    SQLITE_READONLY_CANTLOCK       :ErrorMsg := 'SQLite extended error: SQLITE_READONLY_CANTLOCK';
    SQLITE_ABORT_ROLLBACK          :ErrorMsg := 'SQLite extended error: SQLITE_ABORT_ROLLBACK';
  else
    ErrorMsg := 'Unknown error';
  end;
end;

procedure TSQLite3API.Initialize;
begin
  LockInit.Enter;

  try
    if FInitialized then
      Exit;
      
    if FDirect then begin
{$IFNDEF NOSTATIC}
      InitStaticFunction(Self);
{$ENDIF}

    end
    else begin
{$IFNDEF CLR}
      if FClientLibrary = '' then
        FClientLibrary := SQLiteDLLName;
{$ELSE}
      FClientLibrary := SQLiteDLLName;
{$ENDIF}

      LoadClientLibrary;

      if NativeUInt(hLiteLib) = 0 then
        raise Exception.Create('Cannot load client library: ' + FClientLibrary);

      InitFunctions(Self);

    end;

    FInitialized := True;

  finally
    LockInit.Leave;
  end;
end;

function TSQLite3API.IsMetaDataAPIAvailable: boolean;
begin
  Result := (@sqlite3_column_origin_name <> @NotLink) and
            (@sqlite3_column_table_name <> @NotLink) and
            (@sqlite3_column_database_name <> @NotLink);
end;

procedure TSQLite3API.UnInitialize;
begin
  LockInit.Enter;
  try
    if not FInitialized then
      Exit;

    FInitialized := False;

    if not FDirect then begin
{$IFDEF UNIX}
      if hLiteLib <> nil then
{$ELSE}
      if hLiteLib <> 0 then
{$ENDIF}
      UnloadClientLibrary;

    end;

  finally
    LockInit.Leave;
  end;
end;

procedure TSQLite3API.LoadClientLibrary;
begin
{$IFDEF MSWINDOWS}
  hLiteLib := LoadLibraryEx(PChar(FClientLibrary), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
{$ELSE}
  hLiteLib := dlopen(PAnsiChar(AnsiString(FClientLibrary)), RTLD_LAZY);
{$ENDIF}

end;

procedure TSQLite3API.UnloadClientLibrary;
begin
{$IFDEF MSWINDOWS}
  FreeLibrary(hLiteLib);
  hLiteLib := 0;
{$ENDIF}
{$IFDEF POSIX}
  dlclose(hLiteLib);
  hLiteLib := 0;
{$ENDIF}
{$IFDEF UNIX}
  dlclose(hLiteLib);
  hLiteLib := nil;
{$ENDIF}

end;

{$IFNDEF CLR}
function TSQLite3API.GetProc(const Name: string; NotLinkPtr: IntPtr): IntPtr;
begin
{$IFDEF MSWINDOWS}
  Result := GetProcAddress(hLiteLib, PChar(Name));
{$ELSE}
  Result := dlsym(hLiteLib, PAnsiChar(AnsiString(Name)));
{$ENDIF}
  if Result = nil then
    Result := NotLinkPtr;
end;

function TSQLite3API.GetProc(const Name: string): IntPtr;
begin
  Result := GetProc(Name, @NotLink);
end;
{$ENDIF}

initialization
  LockInit := TCriticalSection.Create;

finalization
  LockInit.Free;
  
end.

