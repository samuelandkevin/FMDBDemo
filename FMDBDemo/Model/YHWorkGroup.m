//
//  YHWorkGroup.m
//  PikeWay
//
//  Created by YHIOS002 on 16/5/5.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHWorkGroup.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;
extern CGFloat maxContentRepostLabelHeight;
extern const CGFloat kMarginContentLeft;
extern const CGFloat kMarginContentRight;

@implementation YHWorkGroup
{
    CGFloat _lastContentWidth;
}


//YHSERIALIZE_DESCRIPTION();

@synthesize msgContent = _msgContent;

- (void)setMsgContent:(NSString *)msgContent
{
    _msgContent = msgContent;
}



- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end
