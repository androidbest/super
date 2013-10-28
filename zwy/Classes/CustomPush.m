//
//  CustomPush.m
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "CustomPush.h"

@implementation CustomPush

- (void)perform{
    
    UIViewController *current = self.sourceViewController;
    
    UIViewController *next = self.destinationViewController;
    
    
    [current addChildViewController:next];
//    [current.view addSubview:next.view];
    [next didMoveToParentViewController:current];
    UIView *view = [[current.childViewControllers objectAtIndex:0] view];
    [current.view addSubview:view];
    
    
    
//    CATransition *transition = [CATransition animation];
//    
//    transition.duration = 0.3f;
//    
//    transition.timingFunction = [CAMediaTimingFunctionfunctionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    transition.type = kCATransitionPush;
//    
//    transition.subtype = kCATransitionFromRight;
//    
//    transition.delegate = self;
//    
//    [self.contentView.layer addAnimation:transition forKey:nil];
//    
//    
//    
//    [self.contentView addSubview:self.productDetailController.view];
    
//    next.view.frame = (CGRect){0, -next.view.frame.size.height, next.view.frame.size};
//    [current.view addSubview:next.view];
//    [UIView animateWithDuration:.15f
//                     animations:^{
//                         next.view.frame = (CGRect){0, 0, next.view.bounds.size};
//                     }];
//    [current.navigationController pushViewController:next animated:YES];
    
}
@end
