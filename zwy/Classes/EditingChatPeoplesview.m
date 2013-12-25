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
	// Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
