//
//  UIColor+BackgroundImage.h
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/10/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Cocoa
#import <UIKit/UIKit.h>

@interface UIColor (BackgroundImage)

///@brief Creates a UIColor with the App Background Image.
///@returns A UIColor composed with the App Background Image.
///@example The usage:
/// [UIColor defaultBackgroundImage]
///is equivalent of:
/// [UIColor colorWithPatternImage:image];
///So to use it to set the view background:
/// [self.view setBackgroundColor:[UIColor defaultBackgroundImage]];
+ (UIColor *)defaultBackgroundImage;

@end
