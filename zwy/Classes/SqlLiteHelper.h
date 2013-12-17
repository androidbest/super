//
//  SqlLiteHelper.h
//  zwy
//
//  Created by wangshuang on 12/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MessageRecord.h"
#import "ChatRecord.h"
@interface SqlLiteHelper : NSObject
-(BOOL)createDB;
-(BOOL)insertTableMsgtab:(MessageRecord *)msgRecord;
-(BOOL)insertTableChattab:(ChatRecord *) chatRecord;
-(BOOL)deleteTableMsgtab:(MessageRecord *) msgRecord;
-(BOOL)deleteTableChattab:(ChatRecord *) chatRecord;
-(BOOL)updateTableMsgtab:(MessageRecord *) msgRecord;
-(BOOL)updateTableChattab:(ChatRecord *) chatRecord;
-(NSMutableArray *)selectTableMsgtab:(NSString *) memberid;
-(NSMutableArray *) selectTableChattab:(ChatRecord *) chatRecord;
@end
