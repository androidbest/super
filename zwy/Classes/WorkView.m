//
//  WorkView.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "WorkView.h"
#import "WorkController.h"
#import "DetailTextView.h"
@interface WorkView ()

@end

@implementation WorkView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        WorkController *contro =[WorkController new];
        self.controller=contro;
        contro.workViews=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *  btnEditing =[UIButton buttonWithType:UIButtonTypeCustom];
    btnEditing.frame=CGRectMake(0, 0, 20, 20);
    [btnEditing setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEditing addTarget:self.controller action:@selector(btnEditing) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temAddPeople = [[UIBarButtonItem alloc] initWithCustomView:btnEditing];
    temAddPeople.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem=temAddPeople;
	// Do any additional setup after loading the view.
}

-  (void)btnEditing{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
