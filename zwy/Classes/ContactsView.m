//
//  ContactsView.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ContactsView.h"
#import "ContactsController.h"
@interface ContactsView ()

@end

@implementation ContactsView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
//        self.tabBarItem=[self.tabBarItem initWithTitle:@"联系人" image:[UIImage imageNamed:@"home_out"] selectedImage:[UIImage imageNamed:@"home_over"]];
        ContactsController *contacts=[ContactsController new];
        contacts.contactsView=self;
        self.controller=contacts;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self.controller;
    [_searchBar sizeToFit];
    
    _uitableview.dataSource = self.controller;
    _uitableview.delegate = self.controller;
    _uitableview.tableHeaderView = self.searchBar;
    _uitableview.contentOffset = CGPointMake(0, CGRectGetHeight(_searchBar.bounds));
    _uitableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self.tabBarController];
    self.searchDisplayController.searchResultsDataSource = self.controller;
    self.searchDisplayController.searchResultsDelegate = self.controller;
    self.searchDisplayController.delegate = self.controller;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.title=@"联系人";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
