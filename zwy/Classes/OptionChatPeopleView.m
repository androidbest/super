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
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    _tableViewPeople.dataSource = self.controller;
    _tableViewPeople.delegate = self.controller;
    _tableViewPeople.tableHeaderView = self.searchBar;
    
    
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [_displayController setDelegate:self.controller];
    [_displayController setSearchResultsDataSource:self.controller];
    [_displayController setSearchResultsDelegate:self.controller];
    

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 13.0, 20.0);
    [backButton setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back_out"] forState:UIControlStateHighlighted];
    [backButton addTarget:self.controller action:@selector(LeftDown) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
    
    UIBarButtonItem *rightButton  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self.controller action:@selector(rightDown)];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    [self.controller initWithData];
}


- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self.controller;
        [_searchBar sizeToFit];
    }
    return _searchBar;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

- (void)LeftDown{}

- (void)rightDown{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)MessageViewToChatMessageView:(NSMutableArray *)peoples{}
@end
