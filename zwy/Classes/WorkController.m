//
//  WorkController.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "WorkController.h"
#import "NewsScheduleView.h"
@implementation WorkController


- (id)init{
    self =[super init];
    if (self) {
        
    }
    return self;
}

- (void)initWithData{

}

#pragma mark - 按钮实现方法
-  (void)btnEditing{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NewsScheduleView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"NewsScheduleView"];
    [self.workViews presentViewController:detaView animated:YES completion:nil];
}

@end
