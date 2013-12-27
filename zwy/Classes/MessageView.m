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
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0, 0.0, 35.0, 25.0);
    [rightButton setImage:[UIImage imageNamed:@"addGroup"] forState:UIControlStateNormal];
    [rightButton addTarget:self.controller action:@selector(btnAddPeople) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.tabBarController.navigationItem.rightBarButtonItem=temporaryBarButtonItem;
    
//    UIBarButtonItem *rightButton  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self.controller action:@selector(btnAddPeople)];
//    self.tabBarController.navigationItem.rightBarButtonItem=rightButton;
}

-(void)viewWillAppear:(BOOL)animated{
    _info=nil;
    self.tabBarController.navigationItem.title=@"最近消息";
    NSString *strSelfID =[NSString stringWithFormat:@"%@%@",user.msisdn,user.eccode];
    ((MessageController *)self.controller).arrSession = [[NSMutableArray alloc]initWithArray:[[CoreDataManageContext new] getSessionListWithSelfID:strSelfID]];
    if(isfirst){
        isfirst=YES;
    }else{
    [_uitableview reloadData];
    }
    //添加观察者
    [self addMessageObserver];
}

- (void)viewWillDisappear:(BOOL)animated{
    //移除观察者
    [self removeMessageObserver];
}


#pragma mark - 移除接受消息观察者
- (void)removeMessageObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self.controller name:NOTIFICATIONCHAT object:nil];//移除事件
}

#pragma mark - 添加接受消息观察者
- (void)addMessageObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self.controller selector:@selector(getMessage:) name:NOTIFICATIONCHAT object:nil];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessageViewToOptionChatView"]) {
        [self.controller BasePrepareForSegue:segue sender:sender];
    }else if ([segue.identifier isEqualToString:@"msgtochat"]){
        if(_info){
            //将page2设定成Storyboard Segue的目标UIViewController
            id page2 = segue.destinationViewController;
            //将值透过Storyboard Segue带给页面2的string变数
            [page2 setValue:_info forKey:@"chatData"];
        }else{
            [self.controller BasePrepareForSegue:segue sender:sender];
        }
    }
}

- (void)btnAddPeople
{}

- (void)getMessage:(id)notification{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
