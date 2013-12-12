//
//  MessageView.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MessageView.h"
#import "MessageController.h"
@interface MessageView ()

@end

@implementation MessageView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        self.tabBarItem=[self.tabBarItem initWithTitle:@"消息" image:[UIImage imageNamed:@"home_out"] selectedImage:[UIImage imageNamed:@"home_over"]];
        MessageController *contacts=[MessageController new];
        contacts.messageView=self;
        self.controller=contacts;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.navigationItem.leftBarButtonItem =self.temporaryBarButtonItem;
    if (self.navigationController.navigationBarHidden) self.navigationController.navigationBarHidden=NO;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self.controller;
    [_searchBar sizeToFit];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topLayout, ScreenWidth, ScreenHeight-topLayout-NavigationBarHeight)];
    _tableView.dataSource = self.controller;
    _tableView.delegate = self.controller;
    _tableView.tableHeaderView = self.searchBar;
    _tableView.contentOffset = CGPointMake(0, CGRectGetHeight(_searchBar.bounds));
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self.controller;
    self.searchDisplayController.searchResultsDelegate = self.controller;
    self.searchDisplayController.delegate = self.controller;
}


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.title=@"最近消息";
}

- (void)backButtonToHome{
    if (!self.navigationController.navigationBarHidden)self.navigationController.navigationBarHidden=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
