//
//  MessageView.h
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"

@interface MessageView : BaseView

@property (strong, nonatomic) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchDisplayController *displayController;
@property(nonatomic, strong) UITableView *tableView;
@end
