//
//  DetailTextView.h
//  
//
//  Created by Mac Pro on 4/27/12.
//  Copyright (c) 2012 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTextView : UILabel{
    NSMutableAttributedString *AttributedString;
}

/*设置标题字体*/
+ (NSMutableAttributedString *)setDateAttributedString:(NSString *)Title;

/*设置列表Cell的字体*/
+ (NSMutableAttributedString *)setCellTimeAttributedString:(NSString *)time;

@end
