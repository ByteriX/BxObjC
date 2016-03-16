/*
** 2006 June 7
**
** The author disclaims copyright to this source code.  In place of
** a legal notice, here is a blessing:
**
**    May you do good and not evil.
**    May you find forgiveness for yourself and forgive others.
**    May you share freely, never taking more than you give.
**
*************************************************************************
** This header file defines the SQLite interface for use by
** shared libraries that want to be imported as extensions into
** an SQLite instance.  Shared libraries that intend to be loaded
** as extensions by SQLite should #include this file instead of 
** bx_unicode_sqlite3.h.
*/
#ifndef FILE_SQLITE3EXT_H_
#define FILE_SQLITE3EXT_H_
#include "bx_unicode_sqlite3.h"

typedef struct bx_unicode_sqlite3_api_routines bx_unicode_sqlite3_api_routines;

/*
** The following structure holds pointers to all of the SQLite API
** routines.
**
** WARNING:  In order to maintain backwards compatibility, add new
** interfaces to the end of this structure only.  If you insert new
** interfaces in the middle of this structure, then older different
** versions of SQLite will not be able to load each others' shared
** libraries!
*/
struct bx_unicode_sqlite3_api_routines {
  void * (*aggregate_context)(bx_unicode_sqlite3_context*,int nBytes);
  int  (*aggregate_count)(bx_unicode_sqlite3_context*);
  int  (*bind_blob)(bx_unicode_sqlite3_stmt*,int,const void*,int n,void(*)(void*));
  int  (*bind_double)(bx_unicode_sqlite3_stmt*,int,double);
  int  (*bind_int)(bx_unicode_sqlite3_stmt*,int,int);
  int  (*bind_int64)(bx_unicode_sqlite3_stmt*,int,sqlite_int64);
  int  (*bind_null)(bx_unicode_sqlite3_stmt*,int);
  int  (*bind_parameter_count)(bx_unicode_sqlite3_stmt*);
  int  (*bind_parameter_index)(bx_unicode_sqlite3_stmt*,const char*zName);
  const char * (*bind_parameter_name)(bx_unicode_sqlite3_stmt*,int);
  int  (*bind_text)(bx_unicode_sqlite3_stmt*,int,const char*,int n,void(*)(void*));
  int  (*bind_text16)(bx_unicode_sqlite3_stmt*,int,const void*,int,void(*)(void*));
  int  (*bind_value)(bx_unicode_sqlite3_stmt*,int,const bx_unicode_sqlite3_value*);
  int  (*busy_handler)(bx_unicode_sqlite3*,int(*)(void*,int),void*);
  int  (*busy_timeout)(bx_unicode_sqlite3*,int ms);
  int  (*changes)(bx_unicode_sqlite3*);
  int  (*close)(bx_unicode_sqlite3*);
  int  (*collation_needed)(bx_unicode_sqlite3*,void*,void(*)(void*,bx_unicode_sqlite3*,
                           int eTextRep,const char*));
  int  (*collation_needed16)(bx_unicode_sqlite3*,void*,void(*)(void*,bx_unicode_sqlite3*,
                             int eTextRep,const void*));
  const void * (*column_blob)(bx_unicode_sqlite3_stmt*,int iCol);
  int  (*column_bytes)(bx_unicode_sqlite3_stmt*,int iCol);
  int  (*column_bytes16)(bx_unicode_sqlite3_stmt*,int iCol);
  int  (*column_count)(bx_unicode_sqlite3_stmt*pStmt);
  const char * (*column_database_name)(bx_unicode_sqlite3_stmt*,int);
  const void * (*column_database_name16)(bx_unicode_sqlite3_stmt*,int);
  const char * (*column_decltype)(bx_unicode_sqlite3_stmt*,int i);
  const void * (*column_decltype16)(bx_unicode_sqlite3_stmt*,int);
  double  (*column_double)(bx_unicode_sqlite3_stmt*,int iCol);
  int  (*column_int)(bx_unicode_sqlite3_stmt*,int iCol);
  sqlite_int64  (*column_int64)(bx_unicode_sqlite3_stmt*,int iCol);
  const char * (*column_name)(bx_unicode_sqlite3_stmt*,int);
  const void * (*column_name16)(bx_unicode_sqlite3_stmt*,int);
  const char * (*column_origin_name)(bx_unicode_sqlite3_stmt*,int);
  const void * (*column_origin_name16)(bx_unicode_sqlite3_stmt*,int);
  const char * (*column_table_name)(bx_unicode_sqlite3_stmt*,int);
  const void * (*column_table_name16)(bx_unicode_sqlite3_stmt*,int);
  const unsigned char * (*column_text)(bx_unicode_sqlite3_stmt*,int iCol);
  const void * (*column_text16)(bx_unicode_sqlite3_stmt*,int iCol);
  int  (*column_type)(bx_unicode_sqlite3_stmt*,int iCol);
  bx_unicode_sqlite3_value* (*column_value)(bx_unicode_sqlite3_stmt*,int iCol);
  void * (*commit_hook)(bx_unicode_sqlite3*,int(*)(void*),void*);
  int  (*complete)(const char*sql);
  int  (*complete16)(const void*sql);
  int  (*create_collation)(bx_unicode_sqlite3*,const char*,int,void*,
                           int(*)(void*,int,const void*,int,const void*));
  int  (*create_collation16)(bx_unicode_sqlite3*,const void*,int,void*,
                             int(*)(void*,int,const void*,int,const void*));
  int  (*create_function)(bx_unicode_sqlite3*,const char*,int,int,void*,
                          void (*xFunc)(bx_unicode_sqlite3_context*,int,bx_unicode_sqlite3_value**),
                          void (*xStep)(bx_unicode_sqlite3_context*,int,bx_unicode_sqlite3_value**),
                          void (*xFinal)(bx_unicode_sqlite3_context*));
  int  (*create_function16)(bx_unicode_sqlite3*,const void*,int,int,void*,
                            void (*xFunc)(bx_unicode_sqlite3_context*,int,bx_unicode_sqlite3_value**),
                            void (*xStep)(bx_unicode_sqlite3_context*,int,bx_unicode_sqlite3_value**),
                            void (*xFinal)(bx_unicode_sqlite3_context*));
  int (*create_module)(bx_unicode_sqlite3*,const char*,const bx_unicode_sqlite3_module*,void*);
  int  (*data_count)(bx_unicode_sqlite3_stmt*pStmt);
  bx_unicode_sqlite3 * (*db_handle)(bx_unicode_sqlite3_stmt*);
  int (*declare_vtab)(bx_unicode_sqlite3*,const char*);
  int  (*enable_shared_cache)(int);
  int  (*errcode)(bx_unicode_sqlite3*db);
  const char * (*errmsg)(bx_unicode_sqlite3*);
  const void * (*errmsg16)(bx_unicode_sqlite3*);
  int  (*exec)(bx_unicode_sqlite3*,const char*,bx_unicode_sqlite3_callback,void*,char**);
  int  (*expired)(bx_unicode_sqlite3_stmt*);
  int  (*finalize)(bx_unicode_sqlite3_stmt*pStmt);
  void  (*free)(void*);
  void  (*free_table)(char**result);
  int  (*get_autocommit)(bx_unicode_sqlite3*);
  void * (*get_auxdata)(bx_unicode_sqlite3_context*,int);
  int  (*get_table)(bx_unicode_sqlite3*,const char*,char***,int*,int*,char**);
  int  (*global_recover)(void);
  void  (*interruptx)(bx_unicode_sqlite3*);
  sqlite_int64  (*last_insert_rowid)(bx_unicode_sqlite3*);
  const char * (*libversion)(void);
  int  (*libversion_number)(void);
  void *(*malloc)(int);
  char * (*mprintf)(const char*,...);
  int  (*open)(const char*,bx_unicode_sqlite3**);
  int  (*open16)(const void*,bx_unicode_sqlite3**);
  int  (*prepare)(bx_unicode_sqlite3*,const char*,int,bx_unicode_sqlite3_stmt**,const char**);
  int  (*prepare16)(bx_unicode_sqlite3*,const void*,int,bx_unicode_sqlite3_stmt**,const void**);
  void * (*profile)(bx_unicode_sqlite3*,void(*)(void*,const char*,sqlite_uint64),void*);
  void  (*progress_handler)(bx_unicode_sqlite3*,int,int(*)(void*),void*);
  void *(*realloc)(void*,int);
  int  (*reset)(bx_unicode_sqlite3_stmt*pStmt);
  void  (*result_blob)(bx_unicode_sqlite3_context*,const void*,int,void(*)(void*));
  void  (*result_double)(bx_unicode_sqlite3_context*,double);
  void  (*result_error)(bx_unicode_sqlite3_context*,const char*,int);
  void  (*result_error16)(bx_unicode_sqlite3_context*,const void*,int);
  void  (*result_int)(bx_unicode_sqlite3_context*,int);
  void  (*result_int64)(bx_unicode_sqlite3_context*,sqlite_int64);
  void  (*result_null)(bx_unicode_sqlite3_context*);
  void  (*result_text)(bx_unicode_sqlite3_context*,const char*,int,void(*)(void*));
  void  (*result_text16)(bx_unicode_sqlite3_context*,const void*,int,void(*)(void*));
  void  (*result_text16be)(bx_unicode_sqlite3_context*,const void*,int,void(*)(void*));
  void  (*result_text16le)(bx_unicode_sqlite3_context*,const void*,int,void(*)(void*));
  void  (*result_value)(bx_unicode_sqlite3_context*,bx_unicode_sqlite3_value*);
  void * (*rollback_hook)(bx_unicode_sqlite3*,void(*)(void*),void*);
  int  (*set_authorizer)(bx_unicode_sqlite3*,int(*)(void*,int,const char*,const char*,
                         const char*,const char*),void*);
  void  (*set_auxdata)(bx_unicode_sqlite3_context*,int,void*,void (*)(void*));
  char * (*snprintf)(int,char*,const char*,...);
  int  (*step)(bx_unicode_sqlite3_stmt*);
  int  (*table_column_metadata)(bx_unicode_sqlite3*,const char*,const char*,const char*,
                                char const**,char const**,int*,int*,int*);
  void  (*thread_cleanup)(void);
  int  (*total_changes)(bx_unicode_sqlite3*);
  void * (*trace)(bx_unicode_sqlite3*,void(*xTrace)(void*,const char*),void*);
  int  (*transfer_bindings)(bx_unicode_sqlite3_stmt*,bx_unicode_sqlite3_stmt*);
  void * (*update_hook)(bx_unicode_sqlite3*,void(*)(void*,int ,char const*,char const*,
                                         sqlite_int64),void*);
  void * (*user_data)(bx_unicode_sqlite3_context*);
  const void * (*value_blob)(bx_unicode_sqlite3_value*);
  int  (*value_bytes)(bx_unicode_sqlite3_value*);
  int  (*value_bytes16)(bx_unicode_sqlite3_value*);
  double  (*value_double)(bx_unicode_sqlite3_value*);
  int  (*value_int)(bx_unicode_sqlite3_value*);
  sqlite_int64  (*value_int64)(bx_unicode_sqlite3_value*);
  int  (*value_numeric_type)(bx_unicode_sqlite3_value*);
  const unsigned char * (*value_text)(bx_unicode_sqlite3_value*);
  const void * (*value_text16)(bx_unicode_sqlite3_value*);
  const void * (*value_text16be)(bx_unicode_sqlite3_value*);
  const void * (*value_text16le)(bx_unicode_sqlite3_value*);
  int  (*value_type)(bx_unicode_sqlite3_value*);
  char *(*vmprintf)(const char*,va_list);
  /* Added ??? */
  int (*overload_function)(bx_unicode_sqlite3*, const char *zFuncName, int nArg);
  /* Added by 3.3.13 */
  int (*prepare_v2)(bx_unicode_sqlite3*,const char*,int,bx_unicode_sqlite3_stmt**,const char**);
  int (*prepare16_v2)(bx_unicode_sqlite3*,const void*,int,bx_unicode_sqlite3_stmt**,const void**);
  int (*clear_bindings)(bx_unicode_sqlite3_stmt*);
  /* Added by 3.4.1 */
  int (*create_module_v2)(bx_unicode_sqlite3*,const char*,const bx_unicode_sqlite3_module*,void*,
                          void (*xDestroy)(void *));
  /* Added by 3.5.0 */
  int (*bind_zeroblob)(bx_unicode_sqlite3_stmt*,int,int);
  int (*blob_bytes)(bx_unicode_sqlite3_blob*);
  int (*blob_close)(bx_unicode_sqlite3_blob*);
  int (*blob_open)(bx_unicode_sqlite3*,const char*,const char*,const char*,bx_unicode_sqlite3_int64,
                   int,bx_unicode_sqlite3_blob**);
  int (*blob_read)(bx_unicode_sqlite3_blob*,void*,int,int);
  int (*blob_write)(bx_unicode_sqlite3_blob*,const void*,int,int);
  int (*create_collation_v2)(bx_unicode_sqlite3*,const char*,int,void*,
                             int(*)(void*,int,const void*,int,const void*),
                             void(*)(void*));
  int (*file_control)(bx_unicode_sqlite3*,const char*,int,void*);
  bx_unicode_sqlite3_int64 (*memory_highwater)(int);
  bx_unicode_sqlite3_int64 (*memory_used)(void);
  bx_unicode_sqlite3_mutex *(*mutex_alloc)(int);
  void (*mutex_enter)(bx_unicode_sqlite3_mutex*);
  void (*mutex_free)(bx_unicode_sqlite3_mutex*);
  void (*mutex_leave)(bx_unicode_sqlite3_mutex*);
  int (*mutex_try)(bx_unicode_sqlite3_mutex*);
  int (*open_v2)(const char*,bx_unicode_sqlite3**,int,const char*);
  int (*release_memory)(int);
  void (*result_error_nomem)(bx_unicode_sqlite3_context*);
  void (*result_error_toobig)(bx_unicode_sqlite3_context*);
  int (*sleep)(int);
  void (*soft_heap_limit)(int);
  bx_unicode_sqlite3_vfs *(*vfs_find)(const char*);
  int (*vfs_register)(bx_unicode_sqlite3_vfs*,int);
  int (*vfs_unregister)(bx_unicode_sqlite3_vfs*);
  int (*xthreadsafe)(void);
  void (*result_zeroblob)(bx_unicode_sqlite3_context*,int);
  void (*result_error_code)(bx_unicode_sqlite3_context*,int);
  int (*test_control)(int, ...);
  void (*randomness)(int,void*);
  bx_unicode_sqlite3 *(*context_db_handle)(bx_unicode_sqlite3_context*);
  int (*extended_result_codes)(bx_unicode_sqlite3*,int);
  int (*limit)(bx_unicode_sqlite3*,int,int);
  bx_unicode_sqlite3_stmt *(*next_stmt)(bx_unicode_sqlite3*,bx_unicode_sqlite3_stmt*);
  const char *(*sql)(bx_unicode_sqlite3_stmt*);
  int (*status)(int,int*,int*,int);
  int (*backup_finish)(bx_unicode_sqlite3_backup*);
  bx_unicode_sqlite3_backup *(*backup_init)(bx_unicode_sqlite3*,const char*,bx_unicode_sqlite3*,const char*);
  int (*backup_pagecount)(bx_unicode_sqlite3_backup*);
  int (*backup_remaining)(bx_unicode_sqlite3_backup*);
  int (*backup_step)(bx_unicode_sqlite3_backup*,int);
  const char *(*compileoption_get)(int);
  int (*compileoption_used)(const char*);
  int (*create_function_v2)(bx_unicode_sqlite3*,const char*,int,int,void*,
                            void (*xFunc)(bx_unicode_sqlite3_context*,int,bx_unicode_sqlite3_value**),
                            void (*xStep)(bx_unicode_sqlite3_context*,int,bx_unicode_sqlite3_value**),
                            void (*xFinal)(bx_unicode_sqlite3_context*),
                            void(*xDestroy)(void*));
  int (*db_config)(bx_unicode_sqlite3*,int,...);
  bx_unicode_sqlite3_mutex *(*db_mutex)(bx_unicode_sqlite3*);
  int (*db_status)(bx_unicode_sqlite3*,int,int*,int*,int);
  int (*extended_errcode)(bx_unicode_sqlite3*);
  void (*log)(int,const char*,...);
  bx_unicode_sqlite3_int64 (*soft_heap_limit64)(bx_unicode_sqlite3_int64);
  const char *(*sourceid)(void);
  int (*stmt_status)(bx_unicode_sqlite3_stmt*,int,int);
  int (*strnicmp)(const char*,const char*,int);
  int (*unlock_notify)(bx_unicode_sqlite3*,void(*)(void**,int),void*);
  int (*wal_autocheckpoint)(bx_unicode_sqlite3*,int);
  int (*wal_checkpoint)(bx_unicode_sqlite3*,const char*);
  void *(*wal_hook)(bx_unicode_sqlite3*,int(*)(void*,bx_unicode_sqlite3*,const char*,int),void*);
  int (*blob_reopen)(bx_unicode_sqlite3_blob*,bx_unicode_sqlite3_int64);
  int (*vtab_config)(bx_unicode_sqlite3*,int op,...);
  int (*vtab_on_conflict)(bx_unicode_sqlite3*);
  /* Version 3.7.16 and later */
  int (*close_v2)(bx_unicode_sqlite3*);
  const char *(*db_filename)(bx_unicode_sqlite3*,const char*);
  int (*db_readonly)(bx_unicode_sqlite3*,const char*);
  int (*db_release_memory)(bx_unicode_sqlite3*);
  const char *(*errstr)(int);
  int (*stmt_busy)(bx_unicode_sqlite3_stmt*);
  int (*stmt_readonly)(bx_unicode_sqlite3_stmt*);
  int (*stricmp)(const char*,const char*);
  int (*uri_boolean)(const char*,const char*,int);
  bx_unicode_sqlite3_int64 (*uri_int64)(const char*,const char*,bx_unicode_sqlite3_int64);
  const char *(*uri_parameter)(const char*,const char*);
  char *(*vsnprintf)(int,char*,const char*,va_list);
  int (*wal_checkpoint_v2)(bx_unicode_sqlite3*,const char*,int,int*,int*);
};

/*
** The following macros redefine the API routines so that they are
** redirected throught the global bx_unicode_sqlite3_api structure.
**
** This header file is also used by the loadext.c source file
** (part of the main SQLite library - not an extension) so that
** it can get access to the bx_unicode_sqlite3_api_routines structure
** definition.  But the main library does not want to redefine
** the API.  So the redefinition macros are only valid if the
** SQLITE_CORE macros is undefined.
*/
#ifndef SQLITE_CORE
#define bx_unicode_sqlite3_aggregate_context      bx_unicode_sqlite3_api->aggregate_context
#ifndef SQLITE_OMIT_DEPRECATED
#define bx_unicode_sqlite3_aggregate_count        bx_unicode_sqlite3_api->aggregate_count
#endif
#define bx_unicode_sqlite3_bind_blob              bx_unicode_sqlite3_api->bind_blob
#define bx_unicode_sqlite3_bind_double            bx_unicode_sqlite3_api->bind_double
#define bx_unicode_sqlite3_bind_int               bx_unicode_sqlite3_api->bind_int
#define bx_unicode_sqlite3_bind_int64             bx_unicode_sqlite3_api->bind_int64
#define bx_unicode_sqlite3_bind_null              bx_unicode_sqlite3_api->bind_null
#define bx_unicode_sqlite3_bind_parameter_count   bx_unicode_sqlite3_api->bind_parameter_count
#define bx_unicode_sqlite3_bind_parameter_index   bx_unicode_sqlite3_api->bind_parameter_index
#define bx_unicode_sqlite3_bind_parameter_name    bx_unicode_sqlite3_api->bind_parameter_name
#define bx_unicode_sqlite3_bind_text              bx_unicode_sqlite3_api->bind_text
#define bx_unicode_sqlite3_bind_text16            bx_unicode_sqlite3_api->bind_text16
#define bx_unicode_sqlite3_bind_value             bx_unicode_sqlite3_api->bind_value
#define bx_unicode_sqlite3_busy_handler           bx_unicode_sqlite3_api->busy_handler
#define bx_unicode_sqlite3_busy_timeout           bx_unicode_sqlite3_api->busy_timeout
#define bx_unicode_sqlite3_changes                bx_unicode_sqlite3_api->changes
#define bx_unicode_sqlite3_close                  bx_unicode_sqlite3_api->close
#define bx_unicode_sqlite3_collation_needed       bx_unicode_sqlite3_api->collation_needed
#define bx_unicode_sqlite3_collation_needed16     bx_unicode_sqlite3_api->collation_needed16
#define bx_unicode_sqlite3_column_blob            bx_unicode_sqlite3_api->column_blob
#define bx_unicode_sqlite3_column_bytes           bx_unicode_sqlite3_api->column_bytes
#define bx_unicode_sqlite3_column_bytes16         bx_unicode_sqlite3_api->column_bytes16
#define bx_unicode_sqlite3_column_count           bx_unicode_sqlite3_api->column_count
#define bx_unicode_sqlite3_column_database_name   bx_unicode_sqlite3_api->column_database_name
#define bx_unicode_sqlite3_column_database_name16 bx_unicode_sqlite3_api->column_database_name16
#define bx_unicode_sqlite3_column_decltype        bx_unicode_sqlite3_api->column_decltype
#define bx_unicode_sqlite3_column_decltype16      bx_unicode_sqlite3_api->column_decltype16
#define bx_unicode_sqlite3_column_double          bx_unicode_sqlite3_api->column_double
#define bx_unicode_sqlite3_column_int             bx_unicode_sqlite3_api->column_int
#define bx_unicode_sqlite3_column_int64           bx_unicode_sqlite3_api->column_int64
#define bx_unicode_sqlite3_column_name            bx_unicode_sqlite3_api->column_name
#define bx_unicode_sqlite3_column_name16          bx_unicode_sqlite3_api->column_name16
#define bx_unicode_sqlite3_column_origin_name     bx_unicode_sqlite3_api->column_origin_name
#define bx_unicode_sqlite3_column_origin_name16   bx_unicode_sqlite3_api->column_origin_name16
#define bx_unicode_sqlite3_column_table_name      bx_unicode_sqlite3_api->column_table_name
#define bx_unicode_sqlite3_column_table_name16    bx_unicode_sqlite3_api->column_table_name16
#define bx_unicode_sqlite3_column_text            bx_unicode_sqlite3_api->column_text
#define bx_unicode_sqlite3_column_text16          bx_unicode_sqlite3_api->column_text16
#define bx_unicode_sqlite3_column_type            bx_unicode_sqlite3_api->column_type
#define bx_unicode_sqlite3_column_value           bx_unicode_sqlite3_api->column_value
#define bx_unicode_sqlite3_commit_hook            bx_unicode_sqlite3_api->commit_hook
#define bx_unicode_sqlite3_complete               bx_unicode_sqlite3_api->complete
#define bx_unicode_sqlite3_complete16             bx_unicode_sqlite3_api->complete16
#define bx_unicode_sqlite3_create_collation       bx_unicode_sqlite3_api->create_collation
#define bx_unicode_sqlite3_create_collation16     bx_unicode_sqlite3_api->create_collation16
#define bx_unicode_sqlite3_create_function        bx_unicode_sqlite3_api->create_function
#define bx_unicode_sqlite3_create_function16      bx_unicode_sqlite3_api->create_function16
#define bx_unicode_sqlite3_create_module          bx_unicode_sqlite3_api->create_module
#define bx_unicode_sqlite3_create_module_v2       bx_unicode_sqlite3_api->create_module_v2
#define bx_unicode_sqlite3_data_count             bx_unicode_sqlite3_api->data_count
#define bx_unicode_sqlite3_db_handle              bx_unicode_sqlite3_api->db_handle
#define bx_unicode_sqlite3_declare_vtab           bx_unicode_sqlite3_api->declare_vtab
#define bx_unicode_sqlite3_enable_shared_cache    bx_unicode_sqlite3_api->enable_shared_cache
#define bx_unicode_sqlite3_errcode                bx_unicode_sqlite3_api->errcode
#define bx_unicode_sqlite3_errmsg                 bx_unicode_sqlite3_api->errmsg
#define bx_unicode_sqlite3_errmsg16               bx_unicode_sqlite3_api->errmsg16
#define bx_unicode_sqlite3_exec                   bx_unicode_sqlite3_api->exec
#ifndef SQLITE_OMIT_DEPRECATED
#define bx_unicode_sqlite3_expired                bx_unicode_sqlite3_api->expired
#endif
#define bx_unicode_sqlite3_finalize               bx_unicode_sqlite3_api->finalize
#define bx_unicode_sqlite3_free                   bx_unicode_sqlite3_api->free
#define bx_unicode_sqlite3_free_table             bx_unicode_sqlite3_api->free_table
#define bx_unicode_sqlite3_get_autocommit         bx_unicode_sqlite3_api->get_autocommit
#define bx_unicode_sqlite3_get_auxdata            bx_unicode_sqlite3_api->get_auxdata
#define bx_unicode_sqlite3_get_table              bx_unicode_sqlite3_api->get_table
#ifndef SQLITE_OMIT_DEPRECATED
#define bx_unicode_sqlite3_global_recover         bx_unicode_sqlite3_api->global_recover
#endif
#define bx_unicode_sqlite3_interrupt              bx_unicode_sqlite3_api->interruptx
#define bx_unicode_sqlite3_last_insert_rowid      bx_unicode_sqlite3_api->last_insert_rowid
#define bx_unicode_sqlite3_libversion             bx_unicode_sqlite3_api->libversion
#define bx_unicode_sqlite3_libversion_number      bx_unicode_sqlite3_api->libversion_number
#define bx_unicode_sqlite3_malloc                 bx_unicode_sqlite3_api->malloc
#define bx_unicode_sqlite3_mprintf                bx_unicode_sqlite3_api->mprintf
#define bx_unicode_sqlite3_open                   bx_unicode_sqlite3_api->open
#define bx_unicode_sqlite3_open16                 bx_unicode_sqlite3_api->open16
#define bx_unicode_sqlite3_prepare                bx_unicode_sqlite3_api->prepare
#define bx_unicode_sqlite3_prepare16              bx_unicode_sqlite3_api->prepare16
#define bx_unicode_sqlite3_prepare_v2             bx_unicode_sqlite3_api->prepare_v2
#define bx_unicode_sqlite3_prepare16_v2           bx_unicode_sqlite3_api->prepare16_v2
#define bx_unicode_sqlite3_profile                bx_unicode_sqlite3_api->profile
#define bx_unicode_sqlite3_progress_handler       bx_unicode_sqlite3_api->progress_handler
#define bx_unicode_sqlite3_realloc                bx_unicode_sqlite3_api->realloc
#define bx_unicode_sqlite3_reset                  bx_unicode_sqlite3_api->reset
#define bx_unicode_sqlite3_result_blob            bx_unicode_sqlite3_api->result_blob
#define bx_unicode_sqlite3_result_double          bx_unicode_sqlite3_api->result_double
#define bx_unicode_sqlite3_result_error           bx_unicode_sqlite3_api->result_error
#define bx_unicode_sqlite3_result_error16         bx_unicode_sqlite3_api->result_error16
#define bx_unicode_sqlite3_result_int             bx_unicode_sqlite3_api->result_int
#define bx_unicode_sqlite3_result_int64           bx_unicode_sqlite3_api->result_int64
#define bx_unicode_sqlite3_result_null            bx_unicode_sqlite3_api->result_null
#define bx_unicode_sqlite3_result_text            bx_unicode_sqlite3_api->result_text
#define bx_unicode_sqlite3_result_text16          bx_unicode_sqlite3_api->result_text16
#define bx_unicode_sqlite3_result_text16be        bx_unicode_sqlite3_api->result_text16be
#define bx_unicode_sqlite3_result_text16le        bx_unicode_sqlite3_api->result_text16le
#define bx_unicode_sqlite3_result_value           bx_unicode_sqlite3_api->result_value
#define bx_unicode_sqlite3_rollback_hook          bx_unicode_sqlite3_api->rollback_hook
#define bx_unicode_sqlite3_set_authorizer         bx_unicode_sqlite3_api->set_authorizer
#define bx_unicode_sqlite3_set_auxdata            bx_unicode_sqlite3_api->set_auxdata
#define bx_unicode_sqlite3_snprintf               bx_unicode_sqlite3_api->snprintf
#define bx_unicode_sqlite3_step                   bx_unicode_sqlite3_api->step
#define bx_unicode_sqlite3_table_column_metadata  bx_unicode_sqlite3_api->table_column_metadata
#define bx_unicode_sqlite3_thread_cleanup         bx_unicode_sqlite3_api->thread_cleanup
#define bx_unicode_sqlite3_total_changes          bx_unicode_sqlite3_api->total_changes
#define bx_unicode_sqlite3_trace                  bx_unicode_sqlite3_api->trace
#ifndef SQLITE_OMIT_DEPRECATED
#define bx_unicode_sqlite3_transfer_bindings      bx_unicode_sqlite3_api->transfer_bindings
#endif
#define bx_unicode_sqlite3_update_hook            bx_unicode_sqlite3_api->update_hook
#define bx_unicode_sqlite3_user_data              bx_unicode_sqlite3_api->user_data
#define bx_unicode_sqlite3_value_blob             bx_unicode_sqlite3_api->value_blob
#define bx_unicode_sqlite3_value_bytes            bx_unicode_sqlite3_api->value_bytes
#define bx_unicode_sqlite3_value_bytes16          bx_unicode_sqlite3_api->value_bytes16
#define bx_unicode_sqlite3_value_double           bx_unicode_sqlite3_api->value_double
#define bx_unicode_sqlite3_value_int              bx_unicode_sqlite3_api->value_int
#define bx_unicode_sqlite3_value_int64            bx_unicode_sqlite3_api->value_int64
#define bx_unicode_sqlite3_value_numeric_type     bx_unicode_sqlite3_api->value_numeric_type
#define bx_unicode_sqlite3_value_text             bx_unicode_sqlite3_api->value_text
#define bx_unicode_sqlite3_value_text16           bx_unicode_sqlite3_api->value_text16
#define bx_unicode_sqlite3_value_text16be         bx_unicode_sqlite3_api->value_text16be
#define bx_unicode_sqlite3_value_text16le         bx_unicode_sqlite3_api->value_text16le
#define bx_unicode_sqlite3_value_type             bx_unicode_sqlite3_api->value_type
#define bx_unicode_sqlite3_vmprintf               bx_unicode_sqlite3_api->vmprintf
#define bx_unicode_sqlite3_overload_function      bx_unicode_sqlite3_api->overload_function
#define bx_unicode_sqlite3_prepare_v2             bx_unicode_sqlite3_api->prepare_v2
#define bx_unicode_sqlite3_prepare16_v2           bx_unicode_sqlite3_api->prepare16_v2
#define bx_unicode_sqlite3_clear_bindings         bx_unicode_sqlite3_api->clear_bindings
#define bx_unicode_sqlite3_bind_zeroblob          bx_unicode_sqlite3_api->bind_zeroblob
#define bx_unicode_sqlite3_blob_bytes             bx_unicode_sqlite3_api->blob_bytes
#define bx_unicode_sqlite3_blob_close             bx_unicode_sqlite3_api->blob_close
#define bx_unicode_sqlite3_blob_open              bx_unicode_sqlite3_api->blob_open
#define bx_unicode_sqlite3_blob_read              bx_unicode_sqlite3_api->blob_read
#define bx_unicode_sqlite3_blob_write             bx_unicode_sqlite3_api->blob_write
#define bx_unicode_sqlite3_create_collation_v2    bx_unicode_sqlite3_api->create_collation_v2
#define bx_unicode_sqlite3_file_control           bx_unicode_sqlite3_api->file_control
#define bx_unicode_sqlite3_memory_highwater       bx_unicode_sqlite3_api->memory_highwater
#define bx_unicode_sqlite3_memory_used            bx_unicode_sqlite3_api->memory_used
#define bx_unicode_sqlite3_mutex_alloc            bx_unicode_sqlite3_api->mutex_alloc
#define bx_unicode_sqlite3_mutex_enter            bx_unicode_sqlite3_api->mutex_enter
#define bx_unicode_sqlite3_mutex_free             bx_unicode_sqlite3_api->mutex_free
#define bx_unicode_sqlite3_mutex_leave            bx_unicode_sqlite3_api->mutex_leave
#define bx_unicode_sqlite3_mutex_try              bx_unicode_sqlite3_api->mutex_try
#define bx_unicode_sqlite3_open_v2                bx_unicode_sqlite3_api->open_v2
#define bx_unicode_sqlite3_release_memory         bx_unicode_sqlite3_api->release_memory
#define bx_unicode_sqlite3_result_error_nomem     bx_unicode_sqlite3_api->result_error_nomem
#define bx_unicode_sqlite3_result_error_toobig    bx_unicode_sqlite3_api->result_error_toobig
#define bx_unicode_sqlite3_sleep                  bx_unicode_sqlite3_api->sleep
#define bx_unicode_sqlite3_soft_heap_limit        bx_unicode_sqlite3_api->soft_heap_limit
#define bx_unicode_sqlite3_vfs_find               bx_unicode_sqlite3_api->vfs_find
#define bx_unicode_sqlite3_vfs_register           bx_unicode_sqlite3_api->vfs_register
#define bx_unicode_sqlite3_vfs_unregister         bx_unicode_sqlite3_api->vfs_unregister
#define bx_unicode_sqlite3_threadsafe             bx_unicode_sqlite3_api->xthreadsafe
#define bx_unicode_sqlite3_result_zeroblob        bx_unicode_sqlite3_api->result_zeroblob
#define bx_unicode_sqlite3_result_error_code      bx_unicode_sqlite3_api->result_error_code
#define bx_unicode_sqlite3_test_control           bx_unicode_sqlite3_api->test_control
#define bx_unicode_sqlite3_randomness             bx_unicode_sqlite3_api->randomness
#define bx_unicode_sqlite3_context_db_handle      bx_unicode_sqlite3_api->context_db_handle
#define bx_unicode_sqlite3_extended_result_codes  bx_unicode_sqlite3_api->extended_result_codes
#define bx_unicode_sqlite3_limit                  bx_unicode_sqlite3_api->limit
#define bx_unicode_sqlite3_next_stmt              bx_unicode_sqlite3_api->next_stmt
#define bx_unicode_sqlite3_sql                    bx_unicode_sqlite3_api->sql
#define bx_unicode_sqlite3_status                 bx_unicode_sqlite3_api->status
#define bx_unicode_sqlite3_backup_finish          bx_unicode_sqlite3_api->backup_finish
#define bx_unicode_sqlite3_backup_init            bx_unicode_sqlite3_api->backup_init
#define bx_unicode_sqlite3_backup_pagecount       bx_unicode_sqlite3_api->backup_pagecount
#define bx_unicode_sqlite3_backup_remaining       bx_unicode_sqlite3_api->backup_remaining
#define bx_unicode_sqlite3_backup_step            bx_unicode_sqlite3_api->backup_step
#define bx_unicode_sqlite3_compileoption_get      bx_unicode_sqlite3_api->compileoption_get
#define bx_unicode_sqlite3_compileoption_used     bx_unicode_sqlite3_api->compileoption_used
#define bx_unicode_sqlite3_create_function_v2     bx_unicode_sqlite3_api->create_function_v2
#define bx_unicode_sqlite3_db_config              bx_unicode_sqlite3_api->db_config
#define bx_unicode_sqlite3_db_mutex               bx_unicode_sqlite3_api->db_mutex
#define bx_unicode_sqlite3_db_status              bx_unicode_sqlite3_api->db_status
#define bx_unicode_sqlite3_extended_errcode       bx_unicode_sqlite3_api->extended_errcode
#define bx_unicode_sqlite3_log                    bx_unicode_sqlite3_api->log
#define bx_unicode_sqlite3_soft_heap_limit64      bx_unicode_sqlite3_api->soft_heap_limit64
#define bx_unicode_sqlite3_sourceid               bx_unicode_sqlite3_api->sourceid
#define bx_unicode_sqlite3_stmt_status            bx_unicode_sqlite3_api->stmt_status
#define bx_unicode_sqlite3_strnicmp               bx_unicode_sqlite3_api->strnicmp
#define bx_unicode_sqlite3_unlock_notify          bx_unicode_sqlite3_api->unlock_notify
#define bx_unicode_sqlite3_wal_autocheckpoint     bx_unicode_sqlite3_api->wal_autocheckpoint
#define bx_unicode_sqlite3_wal_checkpoint         bx_unicode_sqlite3_api->wal_checkpoint
#define bx_unicode_sqlite3_wal_hook               bx_unicode_sqlite3_api->wal_hook
#define bx_unicode_sqlite3_blob_reopen            bx_unicode_sqlite3_api->blob_reopen
#define bx_unicode_sqlite3_vtab_config            bx_unicode_sqlite3_api->vtab_config
#define bx_unicode_sqlite3_vtab_on_conflict       bx_unicode_sqlite3_api->vtab_on_conflict
/* Version 3.7.16 and later */
#define bx_unicode_sqlite3_close_v2               bx_unicode_sqlite3_api->close_v2
#define bx_unicode_sqlite3_db_filename            bx_unicode_sqlite3_api->db_filename
#define bx_unicode_sqlite3_db_readonly            bx_unicode_sqlite3_api->db_readonly
#define bx_unicode_sqlite3_db_release_memory      bx_unicode_sqlite3_api->db_release_memory
#define bx_unicode_sqlite3_errstr                 bx_unicode_sqlite3_api->errstr
#define bx_unicode_sqlite3_stmt_busy              bx_unicode_sqlite3_api->stmt_busy
#define bx_unicode_sqlite3_stmt_readonly          bx_unicode_sqlite3_api->stmt_readonly
#define bx_unicode_sqlite3_stricmp                bx_unicode_sqlite3_api->stricmp
#define bx_unicode_sqlite3_uri_boolean            bx_unicode_sqlite3_api->uri_boolean
#define bx_unicode_sqlite3_uri_int64              bx_unicode_sqlite3_api->uri_int64
#define bx_unicode_sqlite3_uri_parameter          bx_unicode_sqlite3_api->uri_parameter
#define bx_unicode_sqlite3_uri_vsnprintf          bx_unicode_sqlite3_api->vsnprintf
#define bx_unicode_sqlite3_wal_checkpoint_v2      bx_unicode_sqlite3_api->wal_checkpoint_v2
#endif /* SQLITE_CORE */

#define SQLITE_EXTENSION_INIT1     const bx_unicode_sqlite3_api_routines *bx_unicode_sqlite3_api = 0;
#define SQLITE_EXTENSION_INIT2(v)  const bx_unicode_sqlite3_api_routines *bx_unicode_sqlite3_api = v;

#endif /* FILE_SQLITE3EXT_H_ */
