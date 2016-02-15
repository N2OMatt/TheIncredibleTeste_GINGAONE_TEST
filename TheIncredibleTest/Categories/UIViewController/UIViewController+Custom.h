//
//  UINavigationController+Transparency.h
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/9/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Cocoa 
#import <UIKit/UIKit.h>

@interface UIViewController (Custom)

///@brief Short hand to set the Custom Arrow in
///UINavigationBar BackButton.
- (void)setupCustomBackButton;

///@brief Short hand to set the Custom Title in
///UINavigationBar Tile.
- (void)setupCustomBarTitle;

@end
