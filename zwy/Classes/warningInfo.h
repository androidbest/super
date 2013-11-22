//
//  warningInfo.h
//  zwy
//
//  Created by cqsxit on 13-11-22.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "warningDataInfo.h"
@interface warningInfo : NSObject

@property (strong ,nonatomic)NSMutableArray *warningList;//所有日程
@property (strong ,nonatomic)warningDataInfo *dataInfo;
@property (assign )int AllCount;//总数
@end
