//
//  ParseXML.m
//  Test
//
//  Created by zhangzhao on 11-7-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParseXML.h"
NSString *const kXMLReaderTextNodeKey = @"text";

@interface ParseXML (Internal)

- (id)initWithError:(NSError **)error;
- (NSDictionary *)objectWithData:(NSData *)data;

@end

@implementation ParseXML
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
{
    ParseXML *reader = [[ParseXML alloc] initWithError:error];
    NSDictionary *rootDictionary = [reader objectWithData:data];
    return rootDictionary;
}

+ (NSDictionary *)dicTIonaryForXML:(NSXMLParser *)XML error:(NSError **)error{
    ParseXML *reader = [[ParseXML alloc] initWithError:error];
    NSDictionary *rootDictionary = [reader objectwithXML:XML];
    return rootDictionary;
}

#pragma mark -
#pragma mark Parsing

- (id)initWithError:(NSError **)error
{
    if (self = [super init])
    {
        errorPointer = nil;
    }
    return self;
}


- (NSDictionary *)objectwithXML:(NSXMLParser *)XML{
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    //初始化字典栈
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // 解析
    NSXMLParser *parser = XML;
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // 成功返回根字典
    if (success)
    {
        NSDictionary *resultDict = [dictionaryStack objectAtIndex:0];
        return resultDict;
    }
    return nil;

}

- (NSDictionary *)objectWithData:(NSData *)data
{    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    //初始化字典栈
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // 解析
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // 成功返回根字典
    if (success)
    {
        NSDictionary *resultDict = [dictionaryStack objectAtIndex:0];
        return resultDict;
    }
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    // 得到最上的字典
    NSMutableDictionary *parentDict = [dictionaryStack lastObject];
    
    // 创建一个子字典
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // 如果已经存在，就创建一个数组来存放
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue){
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]]){
            // 数组已经有了就直接使用
            array = (NSMutableArray *) existingValue;
        }
        else{
            // 如果没有就创建
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // 取代子字典
            [parentDict setObject:array forKey:elementName];
        }
        // 添加一个子字典到数组
        [array addObject:childDict];
    }
    else{
        // 没有存在值
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // 刷新字典栈
    [dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    // 刷新父字典
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    // 设置属性
    if ([textInProgress length] > 0){
        
        [dictInProgress setObject:textInProgress forKey:kXMLReaderTextNodeKey];
        
        textInProgress = [[NSMutableString alloc] init];
    }
    // 移除最后一个
    [dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // 建立文本值
    [textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    //出错
    errorPointer = parseError;
}
@end
