//
//  GroupDetaInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupDetaInfo : NSObject

//通讯录分组信息
@property (strong ,nonatomic)NSString *groupId;//ID
@property (strong ,nonatomic)NSString *groupName;//名称
@property (strong ,nonatomic)NSString *count;//内容
@property (strong ,nonatomic)NSString *rowCount;

@end
