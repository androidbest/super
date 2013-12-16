//
//  CommentListView.h
//  zwy
//
//  Created by cqsxit on 13-12-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "InformationInfo.h"
@interface CommentListView : BaseView
@property (strong, nonatomic) IBOutlet UILabel *commentCount;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) IBOutlet UIButton *btnBack1;
@property (strong, nonatomic) InformationInfo *InfoNewsDeta;
@property (strong,nonatomic) PullRefreshTableView *tableViewComment;

@end
