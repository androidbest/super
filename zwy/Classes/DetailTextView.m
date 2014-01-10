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
    int Day =[Title intValue];
    NSString *strTitle;
    UIColor *colorFirst;
    if (Day<0) {
        strTitle =[NSString stringWithFormat:@"已过 %@ 天",[Title stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        colorFirst=[UIColor whiteColor];
    }else if(Day==0){
        strTitle =[NSString stringWithFormat:@"今天"];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:strTitle];
        NSDictionary *refreshAttributesFirst = @{NSForegroundColorAttributeName:[UIColor brownColor],};
        [attriString setAttributes:refreshAttributesFirst range:NSMakeRange(0, attriString.length)];
        return attriString;
    }else{
        strTitle =[NSString stringWithFormat:@"还有 %@ 天",Title];
        colorFirst=[UIColor whiteColor];
    }
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:strTitle]
    ;
    //把"还有"的字体颜色变为白色色
    NSDictionary *refreshAttributesFirst = @{NSForegroundColorAttributeName:colorFirst,};
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
    int Day =[time intValue];
    NSString *strTitle;
    UIColor *colorFirst;
    if (Day<0) {
       strTitle =[NSString stringWithFormat:@"已过 %@ 天",[time stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        colorFirst=[UIColor redColor];
    }else if(Day==0){
       strTitle =[NSString stringWithFormat:@"今天"];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:strTitle];
        NSDictionary *refreshAttributesFirst = @{NSForegroundColorAttributeName:[UIColor brownColor],};
        [attriString setAttributes:refreshAttributesFirst range:NSMakeRange(0, attriString.length)];
        return attriString;
    }else{
       strTitle =[NSString stringWithFormat:@"还有 %@ 天",time];
        colorFirst=[UIColor blackColor];
    }
    
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:strTitle];
    //把"还有"的字体颜色变为白色色
    NSDictionary *refreshAttributesFirst = @{NSForegroundColorAttributeName:colorFirst,};
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

/*设置人气标题字体*/
+ (NSMutableAttributedString *)setGreetingTitleAttributedString:(NSString *)title{
    NSString * strTitle  =[NSString stringWithFormat:@"人气 (%@)",title];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:strTitle];
    
    
    //把"人气"的字体颜色变为白色
    NSDictionary *refreshAttributesFirst = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.25 green:0.59 blue:1.0 alpha:1.0],};
    [attriString setAttributes:refreshAttributesFirst range:NSMakeRange(0, 2)];
    
    //把"的生日"的字体颜色变为黑色
    NSDictionary *refreshAttributesLast = @{NSForegroundColorAttributeName:[UIColor colorWithRed:1.00 green:0.00 blue:1.0 alpha:1.0],};
    [attriString setAttributes:refreshAttributesLast range:NSMakeRange(2, attriString.length-2)];
    
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:14].fontName,14,NULL))
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

