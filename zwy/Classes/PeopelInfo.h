//
//  PeopelInfo.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-9.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopelInfo : NSObject
@property (strong ,nonatomic)NSString * userID;//用户ID
@property (strong ,nonatomic)NSString * Name;//名字
@property (strong ,nonatomic)NSString * job;//职务
@property (strong ,nonatomic)NSString * area;//地区
@property (strong ,nonatomic)NSString * tel;//电话
@property (strong ,nonatomic)NSString * groupID;//部门
@property (strong ,nonatomic)NSString * superID;//父ID
@property (strong ,nonatomic)NSString * letter;//名字全拼音
@property (strong ,nonatomic)NSString *Firetletter;//首字母
@property (strong ,nonatomic)NSString * number;//不用的
@property (strong ,nonatomic)NSString * isecnumer;//1.成员
@property (strong ,nonatomic)NSString * headPath;//头像
@property (strong ,nonatomic)NSString * eccode;//eccode
@property (strong ,nonatomic)NSString * status;//0.联系人界面 1.聊天界面
@end
