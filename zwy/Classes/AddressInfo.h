//
//  AddressInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-28.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject
@property (strong ,nonatomic)NSString *eccode;//ID
@property (strong ,nonatomic)NSString *groupid;//名称
@property (strong ,nonatomic)NSString *groupname;//内容
@property (strong ,nonatomic)NSString *userName;//姓名
@property (strong ,nonatomic)NSString *userTel;//用户电话
@property (strong ,nonatomic)NSString *idno;//临时部门
@property (strong ,nonatomic)NSString *sex;//性别
@property (strong ,nonatomic)NSString *email;//邮箱
@property (strong ,nonatomic)NSString *contactphone;//职务
@property (strong ,nonatomic)NSString *isadmin;//0.管理员 1.普通成员
@property (strong ,nonatomic)NSString *statusid;//0.部门 1.人员
@property (strong ,nonatomic)NSString *no;//排序字段
@end
