//
//  PullHistroyTableView.h
//  ChatHistroy
//
//  Created by cqsxit on 13-12-30.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PullHistroyTableView;
@protocol PullHistroyTableViewDelegate <NSObject>

- (void)PullHistroyDataWithTableView:(PullHistroyTableView *)tableView;

@end

@interface PullHistroyTableView : UITableView

@property (assign,nonatomic) id <PullHistroyTableViewDelegate> PullDelegate;

@property (nonatomic ,strong)UIActivityIndicatorView * centerActivity;//中心指示灯

@property (nonatomic ,assign)BOOL reachedTheEnd;


- (id)initWithFrame:(CGRect)frame WithDelegate:(id)delegate;

- (void)pullScrollViewDidScroll:(UIScrollView *)scrollView;

@end
