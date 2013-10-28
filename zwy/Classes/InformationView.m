//
//  InformationView.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "InformationView.h"
#import "InformationController.h"
@interface InformationView ()

@end

@implementation InformationView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        InformationController *information=[InformationController new];
        information.informationView=self;
        self.controller=information;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_selecter addTarget:self.controller action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.listview =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight) withDelegate:self.controller];
    self.listview.tag=0;
    self.listview.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview.separatorStyle = NO;
    [self.view addSubview:self.listview];
    [self.listview LoadDataBegin];/*刷新数据*/
    
    self.listview1 =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight) withDelegate:self.controller];
    self.listview1.tag=1;
    self.listview1.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview1.separatorStyle = NO;
    [self.view addSubview:self.listview1];
    self.listview1.hidden=YES;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *send=segue.destinationViewController;
    [send setValue:self forKey:@"data"];
}

-(void)segmentAction:(UISegmentedControl *)Seg{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
