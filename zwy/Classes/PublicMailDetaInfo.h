//
//  PublicMailDetaInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PublicMailDetaInfo : NSObject
@property (strong ,nonatomic)NSString *PublicMail;//类名
@property (strong ,nonatomic)NSString *infoid;//记录ID
@property (strong ,nonatomic)NSString *msisdn;//手机号码
@property (strong ,nonatomic)NSString *content;//记录
@property (strong ,nonatomic)NSString *contetnType;//内容风格
@property (strong ,nonatomic)NSString *senddate;//发送时间
@property (strong ,nonatomic)NSString *sendtype;//0、语音 1、短信 2、人工录入
@property (strong ,nonatomic)NSString *msgtype;//问题目的:0、未分类 1、参政类 2、举报类 3、申诉类4、求决类 5、其它
@property (strong ,nonatomic)NSString *type;//0.办理 1.审核
@property (assign ,nonatomic)NSInteger row;//刷新列表哪一行
@property (assign ,nonatomic)UITableView *listview;//刷新列表哪一行
@property (assign ,nonatomic)NSMutableArray *arr;//刷新列表哪一行
@end
