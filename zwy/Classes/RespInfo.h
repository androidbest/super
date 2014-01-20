//
//  RespInfo.h
//  zwy
//
//  Created by wangshuang on 10/7/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespInfo : NSObject
@property (strong ,nonatomic)NSString * errorMsg;//返回错误信息
@property (strong ,nonatomic)NSString * respCode;//返回数据id
@property (strong ,nonatomic)NSString * respMsg;//返回信息
@property (strong ,nonatomic)NSString * updatetime;//最后更新时间
@property (strong ,nonatomic)NSString * resultcode;//返回头id
@property (strong ,nonatomic)NSString * officeSum;//政务办公总数
@property (strong ,nonatomic)NSString * mailSum;//群众信箱总数
@property (strong ,nonatomic)NSString *ID;//日程提醒ID
@end
