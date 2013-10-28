//
//  FlowDocInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-28.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowDocInfo : NSObject
@property (strong ,nonatomic)NSString *rowCount;//列表长度
@property (strong ,nonatomic)NSString *status;//公文状态标识:1.待审或待办 2.审核通过或已办理 3.审核未通过
@property (strong ,nonatomic)NSString *membername;//办理人
@property (strong ,nonatomic)NSString *startTime;//开始时间
@property (strong ,nonatomic)NSString *overTime;//结束时间
@property (strong ,nonatomic)NSString *describe;//状态标识，例如：审核未通过
@property (strong ,nonatomic)NSString *doStatus;//流程状态
@property (strong ,nonatomic)NSString *content;//办理意见或审核意见
@end
