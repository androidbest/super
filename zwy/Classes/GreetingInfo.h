//
//  GreetingInfo.h
//  zwy
//
//  Created by cqsxit on 13-11-26.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GreetDetaInfo.h"
@interface GreetingInfo : NSObject
@property (strong ,nonatomic)NSMutableArray *arrGreetList;
@property (strong ,nonatomic)GreetDetaInfo *detaInfo;
@end
