//
//  CommentListInfo.h
//  zwy
//
//  Created by cqsxit on 13-12-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentDetaInfo.h"
@interface CommentListInfo : NSObject
@property (strong ,nonatomic)NSMutableArray *arrCommentList;
@property (strong ,nonatomic)CommentDetaInfo *detaInfo;
@end
