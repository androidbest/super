//
//  DocContentInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocContentInfo : NSObject

@property (strong ,nonatomic)NSString *ID;//ID
@property (strong ,nonatomic)NSString *title;//名称
@property (strong ,nonatomic)NSString *type;//类型
@property (strong ,nonatomic)NSString *content;//内容
@property (strong ,nonatomic)NSString *infoType;//公文类型：1、内部公文 2、外部公文
@property (strong ,nonatomic)NSString *textUrl;//wordurl
@property (strong ,nonatomic)NSString *affixUrl;//网页url
@property (strong ,nonatomic)NSString *fileSize;//正文word大小
@property (strong ,nonatomic)NSString *time;//时间
@property (strong ,nonatomic)NSString *name;//发送者
@property (assign ,nonatomic)NSInteger row;//选择行数
@property (strong ,nonatomic)NSString *transactdocid;//全网处理ID 
@property (assign ,nonatomic)UITableView *listview;
@property (assign ,nonatomic)NSMutableArray *arr;
@end
