//
//  GroupInfo.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-9.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfo : NSObject
@property (strong ,nonatomic)NSString *groupID;//部门ID
@property (strong ,nonatomic)NSString *Name;//部门名字
@property (strong ,nonatomic)NSString *superID;//上级ID
@property (strong ,nonatomic)NSString *Count;//人数
@property (strong ,nonatomic)NSString *letter;
@property (strong ,nonatomic)NSString *tel;
@end
