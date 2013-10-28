//
//  CheckAccessoryView.h
//  zwy
//
//  Created by cqsxit on 13-10-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface CheckAccessoryView : BaseView

@property (weak, nonatomic) IBOutlet UIWebView *webAccessory;
- (void)showAccessoryWithUrl:(NSString *)url;
@property (strong ,nonatomic)NSString * url;;
@end
