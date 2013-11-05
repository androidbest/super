//
//  AlterPasswordController.m
//  zwy
//
//  Created by cqsxit on 13-11-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "AlterPasswordController.h"

@implementation AlterPasswordController



- (id)init{
    self =[super init];
    if (self) {
        //注册通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    }
    return self;
}
//处理网络数据
-(void)handleData:(NSNotification *)notification{
    [self.HUD hide:YES];

}
@end
