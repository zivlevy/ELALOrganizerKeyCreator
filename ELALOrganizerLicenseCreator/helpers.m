//
//  helpers.m
//  ELALOrganaizer
//
//  Created by Ziv Levy on 3/28/13.
//  Copyright (c) 2013 Ziv Levy. All rights reserved.
//

#import "helpers.h"
@implementation helpers
+(void) createColoredButton:(UIButton *) button color:(NSString *)colorName{

    UIImage * buttonImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",colorName]]resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage * buttonImageHighlight = [[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlight.png",colorName]] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];


    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
}


@end
