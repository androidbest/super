//
//  InfomaDetaController.h
//  zwy
//
//  Created by cqsxit on 13-12-13.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "InformationDetail.h"
#import "WeiboApi.h"
@interface InfomaDetaController : BaseController<WeiboRequestDelegate,WeiboAuthDelegate>

@property (strong ,nonatomic)InformationDetail *informaView;
@property (nonatomic , retain) WeiboApi *wbapi;
@end
