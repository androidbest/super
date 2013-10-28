//
//  DocContentView.h
//  zwy
//
//  Created by wangshuang on 10/23/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import  "DocContentInfo.h"
@interface DocContentView : BaseView<UIWebViewDelegate,NSURLConnectionDataDelegate>
@property (strong, nonatomic)  DocContentInfo *detailInfo;
@end
