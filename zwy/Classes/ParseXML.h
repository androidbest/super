//
//  ParseXML.h
//  Test
//
//  Created by zhangzhao on 11-7-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ParseXML : NSObject <NSXMLParserDelegate>{
	NSMutableArray *dictionaryStack;//字典栈数组
    NSMutableString *textInProgress;
    NSError *errorPointer;//错误指针
}
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;

+ (NSDictionary *)dicTIonaryForXML:(NSXMLParser *)XML error:(NSError **)errorPointer;
@end
