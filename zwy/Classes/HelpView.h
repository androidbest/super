//
//  HelpView.h
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"

@interface HelpView : BaseView<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *helpWebPage;
- (void)loadWebPageWithString:(NSString*)urlString;
@end
