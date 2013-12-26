//
//  MessageView.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MessageView.h"
#import "MessageController.h"
#import "CoreDataManageContext.h"
@interface MessageView ()

@end

@implementation MessageView{
    BOOL isfirst;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
//        self.tabBarItem=[self.tabBarItem initWithTitle:@"消息" image:[UIImage imageNamed:@"im_message"] selectedImage:[UIImage imageNamed:@"home_over"]];
        MessageController *contacts=[MessageController new];
        contacts.messageView=self;
        self.controller=contacts;
        
//        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
//        if (order == NSOrderedSame || order == NSOrderedDescending)
//        {
//            // OS version >= 7.0
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
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
    [_displayController setDelegate:self.controller];
    [_displayController setSearchResultsDataSource:self.controller];
    [_displayController setSearchResultsDelegate:self.controller];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.title=@"最近消息";
    UIBarButtonItem *rightButton  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self.controller action:@selector(btnAddPeople)];
    self.tabBarController.navigationItem.rightBarButtonItem=rightButton;
    NSString *strSelfID =[NSString stringWithFormat:@"%@%@",user.msisdn,user.eccode];
    ((MessageController *)self.controller).arrSession = [[NSMutableArray alloc]initWithArray:[[CoreDataManageContext new] getSessionListWithSelfID:strSelfID]];
    if(isfirst){
        isfirst=YES;
    }else{
    [_uitableview reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessageViewToOptionChatView"]) {
        [self.controller BasePrepareForSegue:segue sender:sender];
        return;
    }else if ([segue.identifier isEqualToString:@"msgtochat"]){
        [self.controller BasePrepareForSegue:segue sender:sender];
        return;
    }
    //将page2设定成Storyboard Segue的目标UIViewController
    id page2 = segue.destinationViewController;
    //将值透过Storyboard Segue带给页面2的string变数
    [page2 setValue:_info forKey:@"chatData"];
}

- (void)btnAddPeople
{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
