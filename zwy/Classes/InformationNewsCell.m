//
//  InformationNewsCell.m
//  zwy
//
//  Created by cqsxit on 13-12-11.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

/*热点新闻的Cell*/


#import "InformationNewsCell.h"
#import "InformationCellContentView.h"
@implementation InformationNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDelegate:(id)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float selfViewHeight=ScreenHeight-64-44;
        CGRect viewFrame = CGRectMake(0.0, 0.0,
                                      self.contentView.bounds.size.width,
                                      ScreenHeight-64-44);
        InformationCellContentView *informationView =[[InformationCellContentView alloc] initWithFrame:viewFrame];
        informationView.backgroundColor=[UIColor clearColor];


        //头新闻图片
         UITapGestureRecognizer *tapToImageFirstNews =[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(PushToNewsDetaView:)];
        _imageFirstNews=[[UIImageView alloc] init];
        viewFrame.size.height=selfViewHeight*0.35;
        _imageFirstNews.frame=viewFrame;
        _imageFirstNews.image=[UIImage imageNamed:@"newsBanner1.jpg"];
        _imageFirstNews.userInteractionEnabled=YES;
        [_imageFirstNews addGestureRecognizer:tapToImageFirstNews];
        [informationView addSubview:_imageFirstNews];
        
        //头新闻label
        _labelTitle1 =[[UILabel alloc] init];
        viewFrame.origin.y=viewFrame.size.height-20.0f;
        viewFrame.size.height=20.0f;
        _labelTitle1.frame=viewFrame;
        _labelTitle1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        _labelTitle1.font =[UIFont systemFontOfSize:14];
        _labelTitle1.textColor=[UIColor whiteColor];
        _labelTitle1.textAlignment=NSTextAlignmentCenter;
        [informationView addSubview:_labelTitle1];
        
        //新闻label
        _labelTitle2 =[[UILabel alloc] init];
        float labelLeftX=10.0f;
        float labelContentWidth=145.0f;
        float labelContentY=informationView.ContextHeight*0.2;
        float labelContentHeight =informationView.ContextHeight*0.12;
        viewFrame=CGRectMake(labelLeftX, informationView.SegmentationTopY-labelContentY, labelContentWidth, labelContentHeight);
        _labelTitle2.frame=viewFrame;
        _labelTitle2.font=[UIFont boldSystemFontOfSize:16];
        _labelTitle2.textColor =[UIColor blackColor];
        _labelTitle2.numberOfLines=2;
        _labelTitle2.userInteractionEnabled=YES;
         UITapGestureRecognizer *tapToLabelTitle2 =[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(PushToNewsDetaView:)];
        [_labelTitle2 addGestureRecognizer:tapToLabelTitle2];
        [informationView addSubview:_labelTitle2];
        
        viewFrame.origin.x+=ScreenWidth/2;
        _labelTitle3 =[[UILabel alloc] init];
        _labelTitle3.frame=viewFrame;
        _labelTitle3.font=[UIFont boldSystemFontOfSize:16];
        _labelTitle3.textColor =[UIColor blackColor];
        _labelTitle3.numberOfLines=2;
        _labelTitle3.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapToLabelTitle3 =[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(PushToNewsDetaView:)];
        [_labelTitle3 addGestureRecognizer:tapToLabelTitle3];
        [informationView addSubview:_labelTitle3];
        
        viewFrame.origin.x=labelLeftX;
        viewFrame.origin.y=informationView.SegmentationButtonY-labelContentY;
        _labelTitle4 =[[UILabel alloc] init];
        _labelTitle4.frame=viewFrame;
        _labelTitle4.font=[UIFont boldSystemFontOfSize:16];
        _labelTitle4.textColor =[UIColor blackColor];
        _labelTitle4.numberOfLines=2;
        _labelTitle4.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapToLabelTitle4 =[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(PushToNewsDetaView:)];
        [_labelTitle4 addGestureRecognizer:tapToLabelTitle4];
        [informationView addSubview:_labelTitle4];
        
        viewFrame.origin.x+=ScreenWidth/2;
        _labelTitle5 =[[UILabel alloc] init];
        _labelTitle5.frame=viewFrame;
        _labelTitle5.font=[UIFont boldSystemFontOfSize:16];
        _labelTitle5.textColor =[UIColor blackColor];
        _labelTitle5.numberOfLines=2;
        _labelTitle5.userInteractionEnabled=YES;
         UITapGestureRecognizer *tapToLabelTitle5 =[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(PushToNewsDetaView:)];
        [_labelTitle5 addGestureRecognizer:tapToLabelTitle5];
        [informationView addSubview:_labelTitle5];
        
        viewFrame=CGRectMake(labelLeftX, informationView.frame.size.height-labelContentY+10, ScreenWidth-20, informationView.ContextHeight*0.1);
        _labelTitle6 =[[UILabel alloc] init];
        _labelTitle6.frame=viewFrame;
        _labelTitle6.font=[UIFont boldSystemFontOfSize:16];
        _labelTitle6.textColor =[UIColor blackColor];
        _labelTitle6.numberOfLines=2;
        _labelTitle6.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapToLabelTitle6 =[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(PushToNewsDetaView:)];
        [_labelTitle6 addGestureRecognizer:tapToLabelTitle6];
        [informationView addSubview:_labelTitle6];
        
        //新闻来源label
        viewFrame=CGRectMake(labelLeftX, informationView.SegmentationTopY-25, labelContentWidth, 15);
        _labelAddress2=[[UILabel alloc] init];
        _labelAddress2.frame=viewFrame;
        _labelAddress2.font=[UIFont systemFontOfSize:13];
        _labelAddress2.textColor=[UIColor grayColor];
        [informationView addSubview:_labelAddress2];
        
        viewFrame.origin.x+=ScreenWidth/2;
        _labelAddress3=[[UILabel alloc] init];
        _labelAddress3.frame=viewFrame;
        _labelAddress3.font=[UIFont systemFontOfSize:13];
        _labelAddress3.textColor=[UIColor grayColor];
        [informationView addSubview:_labelAddress3];
        
        viewFrame.origin.x=labelLeftX;
        viewFrame.origin.y=informationView.SegmentationButtonY-25;
        _labelAddress4=[[UILabel alloc] init];
        _labelAddress4.frame=viewFrame;
        _labelAddress4.font=[UIFont systemFontOfSize:13];
        _labelAddress4.textColor=[UIColor grayColor];
        [informationView addSubview:_labelAddress4];
        
        viewFrame.origin.x+=ScreenWidth/2;
        _labelAddress5=[[UILabel alloc] init];
        _labelAddress5.frame=viewFrame;
        _labelAddress5.font=[UIFont systemFontOfSize:13];
        _labelAddress5.textColor=[UIColor grayColor];
        [informationView addSubview:_labelAddress5];
        
        viewFrame=CGRectMake(labelLeftX, informationView.frame.size.height-25, ScreenWidth/2-20, 15);
        _labelAddress6=[[UILabel alloc] init];
        _labelAddress6.frame=viewFrame;
        _labelAddress6.font=[UIFont systemFontOfSize:13];
        _labelAddress6.textColor=[UIColor grayColor];
        [informationView addSubview:_labelAddress6];
        
        //新闻时间
        viewFrame=CGRectMake(labelLeftX+labelContentWidth, informationView.SegmentationTopY-25, labelContentWidth, 15);
        _labelTime2=[[UILabel alloc] init];
        _labelTime2.frame=viewFrame;
        _labelTime2.font=[UIFont systemFontOfSize:13];
        _labelTime2.textAlignment=NSTextAlignmentRight;
        _labelTime2.textColor=[UIColor grayColor];
        [informationView addSubview:_labelTime2];
        
        viewFrame.origin.x+=ScreenWidth/2;
        _labelTime3=[[UILabel alloc] init];
        _labelTime3.frame=viewFrame;
        _labelTime3.font=[UIFont systemFontOfSize:13];
        _labelTime3.textAlignment=NSTextAlignmentRight;
        _labelTime3.textColor=[UIColor grayColor];
        [informationView addSubview:_labelTime3];
        
        viewFrame.origin.x=labelLeftX+labelContentWidth;
        viewFrame.origin.y=informationView.SegmentationButtonY-25;
        _labelTime4=[[UILabel alloc] init];
        _labelTime4.frame=viewFrame;
        _labelTime4.font=[UIFont systemFontOfSize:13];
        _labelTime4.textAlignment=NSTextAlignmentRight;
        _labelTime4.textColor=[UIColor grayColor];
        [informationView addSubview:_labelTime4];

        viewFrame.origin.x+=ScreenWidth/2;
        _labelTime5=[[UILabel alloc] init];
        _labelTime5.frame=viewFrame;
        _labelTime5.font=[UIFont systemFontOfSize:13];
        _labelTime5.textAlignment=NSTextAlignmentRight;
        _labelTime5.textColor=[UIColor grayColor];
        [informationView addSubview:_labelTime5];
        
        viewFrame=CGRectMake(labelLeftX+ScreenWidth/2-20, informationView.frame.size.height-25, ScreenWidth/2, 15);
        _labelTime6=[[UILabel alloc] init];
        _labelTime6.frame=viewFrame;
        _labelTime6.font=[UIFont systemFontOfSize:13];
        _labelTime6.textAlignment=NSTextAlignmentRight;
        _labelTime6.textColor=[UIColor grayColor];
        [informationView addSubview:_labelTime6];
        
        [self.contentView addSubview:informationView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)PushToNewsDetaView:(UITapGestureRecognizer *)tapGestureRecognizer{
    NSLog(@"ok!!");
}
@end
