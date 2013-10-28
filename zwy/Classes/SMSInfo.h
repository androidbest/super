//
//  SMSInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSDetaInfo.h"
@interface SMSInfo : NSObject

//获取短信模板分类列表
@property (strong ,nonatomic)NSString *TemplateTypeInfo;//返回消息的类
@property (strong ,nonatomic)NSMutableArray * AllSMSLate;//所有短信分类

//获取短信模板信息
@property (strong ,nonatomic)NSString *TemplateDataInfo;//返回消息的类
@property (strong ,nonatomic)NSMutableArray * AllSMSContent;//所有短信内容
@property (strong ,nonatomic)NSString * rowCount;//所有内容数量

//短信标题、内容详情
@property (strong ,nonatomic)SMSDetaInfo * detas;
@end
