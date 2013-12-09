//
//  warningDataInfo.m
//  zwy
//
//  Created by cqsxit on 13-11-22.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "warningDataInfo.h"

@implementation warningDataInfo

+ (UIImageView *)bubbleView:(NSString *)text{
    UIImageView *returnView = [[UIImageView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    UIImage *bubble =[UIImage imageNamed:@"chat_localhost_bg.9.png"];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    UIFont *font = [UIFont systemFontOfSize:13];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(150.0f, 1000.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                      context:nil];
    
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(24.0f+20, 14.0f-9, textRect.size.width+10, textRect.size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.text =text;
    
    bubbleImageView.frame = CGRectMake(0.0f+20+5, 0.0f, textRect.size.width+50, textRect.size.height+30.0f-10);
    returnView.frame = CGRectMake(200-textRect.size.width, 0.0f, textRect.size.width+50, textRect.size.height+50.0f-10);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView ;
    
}
@end
