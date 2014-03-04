//
//  TimerGetMessages.h
//  zwy
//
//  Created by cqsxit on 14-2-28.
//  Copyright (c) 2014年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerGetMessages : NSObject

+ (TimerGetMessages*)sharedInstance;

@property (strong ,nonatomic) NSTimer *timerGetMsg;

- (void)onTimer;

- (void)offTimer;

- (void)deleteTimer;
@end
