//
//  HTTPRequest.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HTTPRequest : NSObject

+ (void)JSONRequestOperation:(id)delegate Request:(NSMutableURLRequest *)request;

+ (void)JSONRequestOperation:(id)delegate Request:(NSMutableURLRequest *)request SELType:(NSString *)sel;

+(void)LoadDownFile:(id)delegate URL:(NSString *)strUrl filePath:(NSString *)path  HUD:(MBProgressHUD *)hud;

+ (void)data;
@end
