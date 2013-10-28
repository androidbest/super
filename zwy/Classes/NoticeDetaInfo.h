//
//  NoticeDetaInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeDetaInfo : NSObject
@property (strong ,nonatomic)NSString *PublicInfo;//返回码
@property (strong ,nonatomic)NSString *infoid;//返回消息
@property (strong,nonatomic)NSString *title;//标题
@property (strong ,nonatomic)NSString *statusid;//开始ID
@property (strong ,nonatomic)NSString *content;//内容
@property (strong ,nonatomic)NSString *publicdate;//时间
@end
