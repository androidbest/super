//
//  memberInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface memberInfo : NSObject
@property (strong ,nonatomic)NSString *UserList;//返回消息的类
@property (strong ,nonatomic)NSString *rowCount;//
@property (strong ,nonatomic)NSString *UserInfo;//返回消息类
@property (strong ,nonatomic)NSString *eccode;// ID
@property (strong ,nonatomic)NSString *groupid;//名称
@property (strong ,nonatomic)NSString *groupname;//内容
@property (strong ,nonatomic)NSString *userName;//姓名
@property (strong ,nonatomic)NSString *usernumber;//用户电话
@property (strong ,nonatomic)NSString *sex;//性别
@property (strong ,nonatomic)NSString *email;//邮箱
@end
