//
//  InformationDetail.m
//  zwy
//
//  Created by wangshuang on 10/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "InformationDetail.h"
#import "InformationInfo.h"
@interface InformationDetail ()

@end

@implementation InformationDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	InformationInfo *info=self.data.informationInfo;
    _navigationBar.topItem.title=info.title;
    _textView.text=info.content;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
