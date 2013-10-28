//
//  SMSDetaInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmsSonDetaInto.h"
@interface SMSDetaInfo : NSObject

//获取短信模板分类列表
@property (strong ,nonatomic)NSString *templateid;//分类ID
@property (strong ,nonatomic)NSString *templatename;//分类名
@property (strong ,nonatomic)NSMutableArray *Alltitle;//所有子标题
@property (strong ,nonatomic)SmsSonDetaInto *sonDetas;//

//获取短信模板信息
@property (strong ,nonatomic)NSString *content;//短信的内容
@property (strong ,nonatomic)NSString *contentid;//短信ID
@end
