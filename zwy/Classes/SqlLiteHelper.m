//
//  SqlLiteHelper.m
//  zwy
//
//  Created by wangshuang on 12/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "SqlLiteHelper.h"

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
            const char *msgSql = "CREATE TABLE IF NOT EXISTS msgtab(ID INTEGER PRIMARY KEY AUTOINCREMENT, memberid TEXT, membername TEXT,msisdn TEXT,eccode TEXT,groupid TEXT,times TEXT,content TEXT)";
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
@end
