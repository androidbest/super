//
//  DetailTextView.m
//
//
//  Created by Mac Pro on 4/27/12.
//  Copyright (c) 2012 Dawn. All rights reserved.
//

#import "DetailTextView.h"
#import <CoreText/CoreText.h>

@implementation DetailTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        AttributedString=[[NSMutableAttributedString alloc] init];
    }
    return self;
}
+ (NSMutableAttributedString  *)setDateAttributedString:(NSString *)Title{
    NSString *strTitle =[NSString stringWithFormat:@"还有 %@ 天",Title];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:strTitle]
    ;
    //把"还有"的字体颜色变为白色色
    NSDictionary *refreshAttributesFirst = @{NSForegroundColorAttributeName:[UIColor whiteColor],};
    [attriString setAttributes:refreshAttributesFirst range:NSMakeRange(0, 2)];
    
    //把"天"的字体颜色变为白色色
    NSDictionary *refreshAttributesLast = @{NSForegroundColorAttributeName:[UIColor whiteColor],};
    [attriString setAttributes:refreshAttributesLast range:NSMakeRange(attriString.length-1, 1)];
    
    //把"11"变为黄色
    NSDictionary *refreshAttributesTime = @{NSForegroundColorAttributeName:[UIColor yellowColor],};
    [attriString setAttributes:refreshAttributesTime range:NSMakeRange(3, attriString.length-5)];
    
    
    //改变"还有"的字体，value必须是一个CTFontRef
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:20].fontName,20,NULL))
                        range:NSMakeRange(0, 2)];
    
    //改变"天"的字体，value必须是一个CTFontRef
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:20].fontName,20,NULL))
                        range:NSMakeRange(attriString.length-1, 1)];
    
    //改变"11"的字体，value必须是一个CTFontRef
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:25].fontName,25,NULL))
                        range:NSMakeRange(3, attriString.length-5)];
    return attriString;
}

+ (NSMutableAttributedString *)setCellTimeAttributedString:(NSString *)time{
    NSString *strTitle =[NSString stringWithFormat:@"还有 %@ 天",time];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:strTitle]
    ;
    //把"还有"的字体颜色变为白色色
    NSDictionary *refreshAttributesFirst = @{NSForegroundColorAttributeName:[UIColor blackColor],};
    [attriString setAttributes:refreshAttributesFirst range:NSMakeRange(0, 2)];
    
    //把"天"的字体颜色变为白色色
    NSDictionary *refreshAttributesLast = @{NSForegroundColorAttributeName:[UIColor blackColor],};
    [attriString setAttributes:refreshAttributesLast range:NSMakeRange(attriString.length-1, 1)];
    
    //把"11"变为黄色
    NSDictionary *refreshAttributesTime = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.25 green:0.59 blue:1.0 alpha:1.0],};
    [attriString setAttributes:refreshAttributesTime range:NSMakeRange(3, attriString.length-5)];
    
    //改变"还有"的字体，value必须是一个CTFontRef
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:16].fontName,16,NULL))
                        range:NSMakeRange(0, 2)];
    
    //改变"天"的字体，value必须是一个CTFontRef
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:16].fontName,16,NULL))
                        range:NSMakeRange(attriString.length-1, 1)];
    
    //改变"11"的字体，value必须是一个CTFontRef
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:19].fontName,19,NULL))
                        range:NSMakeRange(3, attriString.length-5)];
    return attriString;
}


/*设置列表Cell标题字体*/
+ (NSMutableAttributedString *)setCellTitleAttributedString:(NSString *)title{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:title];
    
    //把"人明"的字体颜色变为白色色
    NSDictionary *refreshAttributesFirst = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.25 green:0.59 blue:1.0 alpha:1.0],};
    [attriString setAttributes:refreshAttributesFirst range:NSMakeRange(0, attriString.length-3)];
    
    //把"的生日"的字体颜色变为黑色色
    NSDictionary *refreshAttributesLast = @{NSForegroundColorAttributeName:[UIColor blackColor],};
    [attriString setAttributes:refreshAttributesLast range:NSMakeRange(attriString.length-3, 3)];
    
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:16].fontName,16,NULL))
                        range:NSMakeRange(0, attriString.length)];
    return attriString;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    NSAttributedString *attriString = AttributedString;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
}


@end

