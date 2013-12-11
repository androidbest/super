//
//  BaseView.h
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControllerProtocol.h"
#import "PullRefreshTableView.h"
#import "UpdataDate.h"
@interface BaseView : UIViewController
@property(strong,nonatomic)id<ControllerProtocol> controller;
@property (strong, nonatomic) PullRefreshTableView *listview;
@property (strong, nonatomic) PullRefreshTableView *listview1;
@property (strong, nonatomic) PullRefreshTableView *listview2;
@property (strong, nonatomic) PullRefreshTableView *listview3;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIBarButtonItem *temporaryBarButtonItem;
@end
