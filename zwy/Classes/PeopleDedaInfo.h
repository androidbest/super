//
//  PeopleDedaInfo.h
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleDedaInfo : NSObject

//通讯录成员信息
@property (strong ,nonatomic)NSString *ecCode;//ID
@property (strong ,nonatomic)NSString *userName;//姓名
@property (strong ,nonatomic)NSString *userTel;//用户电话
@property (strong ,nonatomic)NSString *sex;//性别
@property (strong ,nonatomic)NSString *email;//邮箱
@property (strong ,nonatomic)NSString *groupid;//部门ID
@property (strong ,nonatomic)NSString *groupname;//部门名字

@end
