//
//  InfomaDetaController.m
//  zwy
//
//  Created by cqsxit on 13-12-13.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "InfomaDetaController.h"

@implementation InfomaDetaController


- (void)initWithData{
    float scrollViewContentHeight=10;
    
    InformationInfo *info=_informaView.data.informationInfo;
//标题
   _informaView.labelTitle.text=info.title;
   _informaView.labelSource.text=info.sourceName;
   _informaView.labelContent.text=info.content;
    if (info.imagePath) {
        [HTTPRequest imageWithURL:info.imagePath
                        imageView:_informaView.imageContentView
                 placeholderImage:@"list_NoData.jpg"];
        scrollViewContentHeight+=_informaView.imageContentView.frame.size.height+10;
    }else{
        _informaView.imageContentView.hidden=YES;
    }
    CGRect textRect = [_informaView.labelContent.text boundingRectWithSize:CGSizeMake(300.0f, 10000.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:_informaView.labelContent.font}
                                                      context:nil];
    scrollViewContentHeight=_informaView.layerTitleBackView.bounds.size.height+scrollViewContentHeight;
    _informaView.labelContent.frame=CGRectMake(10, scrollViewContentHeight, 300, textRect.size.height);
    _informaView.scrollView.contentSize=CGSizeMake(0, scrollViewContentHeight);
}
@end
