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
        ContactsController *contacts=[ContactsController new];
        contacts.contactsView=self;
        self.controller=contacts;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.controller initData:self];
    [(ContactsController *)(self.controller) initECnumerData];
    _indexBar.delegate=self.controller;
//    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden=NO;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self.controller;
    [_searchBar sizeToFit];
    
    UIEdgeInsets insets=_uitableview.contentInset;
    insets.top=64;
    _uitableview.contentInset=insets;
    _uitableview.dataSource = self.controller;
    _uitableview.delegate = self.controller;
    _uitableview.tableHeaderView = self.searchBar;
    
    
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self.tabBarController];
    [_displayController setDelegate:self.controller];
    [_displayController setSearchResultsDataSource:self.controller];
    [_displayController setSearchResultsDelegate:self.controller];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //将page2设定成Storyboard Segue的目标UIViewController
    id page2 = segue.destinationViewController;
    //将值透过Storyboard Segue带给页面2的string变数
    [page2 setValue:_info forKey:@"data"];
}



-(void)viewWillAppear:(BOOL)animated{

    self.tabBarController.navigationItem.rightBarButtonItem=nil;
    self.tabBarController.navigationItem.title=@"联系人";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
