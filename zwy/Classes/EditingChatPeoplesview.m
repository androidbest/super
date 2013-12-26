//
//  EditingChatPeoplesview.m
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "EditingChatPeoplesview.h"
#import "EditingChatPeoplesController.h"
@interface EditingChatPeoplesview ()

@end

@implementation EditingChatPeoplesview

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        EditingChatPeoplesController *editingController =[EditingChatPeoplesController new];
        editingController.editingView=self;
        self.controller=editingController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 13.0, 20.0);
    [backButton setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back_out"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
	[self.controller initWithData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self.controller BasePrepareForSegue:segue sender:sender];
}


- (void)btnBack{
    if ([self.chatView.arrPeoples containsObject:@"10000"]) {
        [self.chatView.arrPeoples removeObject:@"10000"];
    }
    if ([self.chatView.arrPeoples containsObject:@"10001"]) {
        [self.chatView.arrPeoples removeObject:@"10001"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
