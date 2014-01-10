//
//  warningDataInfo.h
//  zwy
//
//  Created by cqsxit on 13-11-22.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface warningDataInfo : NSObject

@property (strong ,nonatomic)NSString *content;//内容
@property (strong ,nonatomic)NSString *warningID;//提醒ID
@property (strong ,nonatomic)NSString *RequestType;//重复类型
@property (strong ,nonatomic)NSString *warningDate;//提醒时间
@property (strong ,nonatomic)NSString *warningType;//提醒类型
@property (strong ,nonatomic)NSString *DateType;//数据类型
@property (strong ,nonatomic)NSString *UserTel;//电话号码
@property (strong ,nonatomic)NSString *remainTime;//剩余天数
@property (assign ,nonatomic)int      remainTimeInt;//剩余天数
@property (strong ,nonatomic)NSString *greetingType;//短信模版类型
@property (strong ,nonatomic)NSString *brithdayDate;//生日时间
@property (strong ,nonatomic)NSString *isUserHandAdd;//是否为手动添加

@end
