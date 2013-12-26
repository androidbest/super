//
//  Tuser.h
//  zwy
//
//  Created by wangshuang on 10/7/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tuser : NSObject
@property (strong ,nonatomic)NSString * msisdn;//用户电话
@property (strong ,nonatomic)NSString * eccode;//单位ID
@property (strong ,nonatomic)NSString * ecname;//单位名称
@property (strong ,nonatomic)NSString * ecsignname;//单位别名
@property (strong ,nonatomic)NSString * username;//用户姓名
@property (strong ,nonatomic)NSString * respcode;//返回结果
@property (strong ,nonatomic)NSString * ecSgin;//发送EC标识
@property (strong ,nonatomic)NSString * headurl;//头像
@property (strong ,nonatomic)NSString * job;//职务
@property (strong ,nonatomic)NSString * groupname;//部门名称
@property (strong ,nonatomic)NSString * userid;//用户id
@end
