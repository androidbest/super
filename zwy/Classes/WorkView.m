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
    
    UIBarButtonItem *rightButton  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self.controller action:@selector(btnEditing)];
    self.navigationItem.rightBarButtonItem=rightButton;
	// Do any additional setup after loading the view.
    [self.controller initWithData];
}

-  (void)btnEditing{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
