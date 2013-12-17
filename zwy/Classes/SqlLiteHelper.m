//
//  SqlLiteHelper.m
//  zwy
//
//  Created by wangshuang on 12/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "SqlLiteHelper.h"
#import "MessageRecord.h"
#import "ChatRecord.h"
@implementation SqlLiteHelper{
   sqlite3 *contactDB;
    NSString *databasePath;
}

-(void)getDBPath{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contacts.db"]];
}

-(BOOL)createDB{
    // Do any additional setup after loading the view, typically from a nib.
    /*根据路径创建数据库并创建一个表contact(id nametext addresstext phonetext)*/
   
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
        {
            char *errMsg;
            const char *msgSql = "CREATE TABLE IF NOT EXISTS msgtab(ID INTEGER PRIMARY KEY AUTOINCREMENT, memberid TEXT, membername TEXT,msisdn TEXT,eccode TEXT,groupid TEXT,times TEXT,content TEXT,msgType TEXT)";
            const char *chatSql="CREATE TABLE IF NOT EXISTS chattab(ID INTEGER PRIMARY KEY AUTOINCREMENT, memberid TEXT, sendmsisdn TEXT,sendeccode TEXT,sendecontent TEXT,sendetime TEXT,voiceurl TEXT,receivermsisdn TEXT,receivereccode TEXT,receivercontent TEXT,receivertime TEXT)";
            if (sqlite3_exec(contactDB, msgSql, NULL, NULL, &errMsg)!=SQLITE_OK&&sqlite3_exec(contactDB, chatSql, NULL, NULL, &errMsg)!=SQLITE_OK) {
//                status.text = @"创建表失败\n";
                return NO;
            }else{
                return YES;
            }
            sqlite3_close(contactDB);
        }
        else
        {
//            status.text = @"创建/打开数据库失败";
            return NO;
        }
        
    }else{
        return YES;
    }
}
-(BOOL)insertTableMsgtab:(MessageRecord *)msgRecord{
    BOOL ret=NO;
    
    
    
    
    
    return ret;
}
-(BOOL)insertTableChattab:(ChatRecord *) chatRecord{
    BOOL ret=NO;
    return ret;
}
-(BOOL)deleteTableMsgtab:(MessageRecord *) msgRecord{
    BOOL ret=NO;
    return ret;
}
-(BOOL)deleteTableChattab:(ChatRecord *) chatRecord{
    BOOL ret=NO;
    return ret;
}
-(BOOL)updateTableMsgtab:(MessageRecord *) msgRecord{
    BOOL ret=NO;
    return ret;
}
-(BOOL)updateTableChattab:(ChatRecord *) chatRecord{
    BOOL ret=NO;
    return ret;
}
-(NSMutableArray *)selectTableMsgtab:(NSString *) memberid{
    NSMutableArray *arr=[NSMutableArray new];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from msgtab where memberid='%@'",memberid];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                MessageRecord *msg=[MessageRecord new];
                msg.mid=[NSString stringWithFormat:@"%d",(int)sqlite3_column_int(statement,0)];
                msg.memberid=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                msg.membername=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                msg.msisdn=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                msg.eccode=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                msg.groupid=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                msg.time=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                msg.content=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                msg.msgType=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
            }
            
        }
        
        sqlite3_close(contactDB);
    }
    return arr;
}
-(NSMutableArray *) selectTableChattab:(NSString *) memberid{
    NSMutableArray *arr=[NSMutableArray new];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from chattab where memberid='%@'",memberid];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                //sendmsisdn TEXT,sendeccode TEXT,sendecontent TEXT,sendetime TEXT,voiceurl TEXT,receivermsisdn TEXT,receivereccode TEXT,receivercontent TEXT,receivertime TEX
                ChatRecord *chat=[ChatRecord new];
                chat.cid=[NSString stringWithFormat:@"%d",(int)sqlite3_column_int(statement,0)];
                chat.memberid=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                chat.sendmsisdn=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                chat.sendeccode=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                chat.sendecontent=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                chat.sendetime=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                chat.voiceurl=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                chat.receivermsisdn=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                chat.receivereccode=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                chat.receivertime=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
            }
        }
        sqlite3_close(contactDB);
    }
    return arr;
}
@end
