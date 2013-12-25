//
//  OptionChatPeopleView.m
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "OptionChatPeopleView.h"
#import "OptionChatPeopleController.h"
@interface OptionChatPeopleView ()

@end

@implementation OptionChatPeopleView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        OptionChatPeopleController *optionController=[OptionChatPeopleController new];
        optionController.optionView=self;
        self.controller=optionController;
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
    
    UIEdgeInsets insets=_tableViewPeople.contentInset;
    insets.top=0;
    _tableViewPeople.contentInset=insets;
    _tableViewPeople.dataSource = self.controller;
    _tableViewPeople.delegate = self.controller;
    _tableViewPeople.tableHeaderView = self.searchBar;
    //    _uitableview.contentOffset = CGPointMake(0, CGRectGetHeight(_searchBar.bounds));
    _tableViewPeople.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self.navigationController];
    [_displayController setDelegate:self.controller];
    [_displayController setSearchResultsDataSource:self.controller];
    [_displayController setSearchResultsDelegate:self.controller];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
