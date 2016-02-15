//
//  UIColor+BackgroundImage.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/10/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "UIColor+BackgroundImage.h"

// Constants //
//CODEREVIEW: Should we use NSString const * instead?
#define kBackgroundImageName @"bg_captainamerica.png"

// Public Implementation //
@implementation UIColor (BackgroundImage)

+ (UIColor *)defaultBackgroundImage
{
    id image = [UIImage imageNamed:kBackgroundImageName];
    return [UIColor colorWithPatternImage:image];
}

@end
