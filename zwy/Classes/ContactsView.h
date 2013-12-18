//
//  ContactsView.h
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "PeopelInfo.h"
@interface ContactsView : BaseView
@property (strong, nonatomic) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchDisplayController *displayController;
@property (strong, nonatomic) IBOutlet UITableView *uitableview;

@property (strong, nonatomic) PeopelInfo *info;
@end
