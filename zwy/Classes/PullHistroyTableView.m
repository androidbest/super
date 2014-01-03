//
//  PullHistroyTableView.m
//  ChatHistroy
//
//  Created by cqsxit on 13-12-30.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#define ContentInsetTop 44

#define LableTextTitle @"没有了"

#import "PullHistroyTableView.h"

@implementation PullHistroyTableView
{
    BOOL isupdataing;
    BOOL isInitTableView;
    UILabel *labelText;
    float updateContentHeightBefore;
    float updateContentHeightAfter;
}

- (id)initWithFrame:(CGRect)frame WithDelegate:(id)delegate{
    self =[super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        isInitTableView=YES;
        _PullDelegate=delegate;
        //中心指示灯
        self.centerActivity =[[UIActivityIndicatorView alloc]
                              initWithFrame : CGRectMake(ScreenWidth/2.0f-32.0f/2.0f, -20.0f, 32.0f, 32.0f)];
        [_centerActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        _centerActivity.color=[UIColor grayColor];
        [self addSubview:_centerActivity];
        
        //无刷新内容提示
        labelText =[[UILabel alloc] init];
        labelText.frame =CGRectMake(ScreenWidth/2.0f-150.0f/2, -20.0, 150, 20);
        labelText.text=LableTextTitle;
        labelText.textColor=[UIColor grayColor];
        labelText.font=[UIFont systemFontOfSize:12];
        labelText.textAlignment=NSTextAlignmentCenter;
        labelText.hidden=YES;
        [self addSubview:labelText];
        
    }
    return self;
}


- (void)reloadData:(BOOL)animation{
    if (!animation) return;
    //获取插前内容后的长度
    updateContentHeightBefore=self.contentSize.height;
    
    [super reloadData];
    
    //获取插入内容后的长度(为0表示为第一次初始化)
    if (updateContentHeightBefore==0.0)updateContentHeightAfter=0.0;
    else updateContentHeightAfter =self.contentSize.height;
    NSLog(@"之前%f---之后%f",updateContentHeightBefore,updateContentHeightAfter);
    //当内容不足view.height时，不准许刷新
    if (isInitTableView) {//保证该方法只调用一次
        isInitTableView=NO;
        if (self.contentSize.height>self.frame.size.height) {
            self.contentInset=UIEdgeInsetsMake(ContentInsetTop, 0, 0, 0);
        }else{
            self.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            _reachedTheEnd=YES;
        }
    }
    
    //保证刷新后内容位置不变(通过插入前与插入后进行对比)
    if (updateContentHeightAfter-updateContentHeightBefore==0.0)self.contentOffset=CGPointMake(self.contentOffset.x,0.0);
    else self.contentOffset=CGPointMake(self.contentOffset.x,updateContentHeightAfter-updateContentHeightBefore-ContentInsetTop);
    
    if (_reachedTheEnd) {
        labelText.hidden=NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentInset=UIEdgeInsetsZero;
        }];
    }
    
    isupdataing=NO;
    [_centerActivity stopAnimating];
}

- (void)pullScrollViewDidScroll:(UIScrollView *)scrollView{
    if (_reachedTheEnd)return;
    
    //划出内容调用获取历史数据方法
    if (scrollView.contentOffset.y<0&&!isupdataing&&self.contentSize.height>self.frame.size.height) {
        [_centerActivity startAnimating];
        self.contentInset=UIEdgeInsetsMake(ContentInsetTop, 0, 0, 0);
        [self.PullDelegate PullHistroyDataWithTableView:self];
        isupdataing=YES;
    }
}

@end
