//
//  CommentListController.m
//  zwy
//
//  Created by cqsxit on 13-12-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "CommentListController.h"

@implementation CommentListController

#pragma  mark - 按钮触发
//返回
- (void)btnBack{
    [self.comListView.navigationController popViewControllerAnimated:YES];
}

//评论
- (void)btnComment{

}

//刷新
- (void)btnRefresh{

}
@end
