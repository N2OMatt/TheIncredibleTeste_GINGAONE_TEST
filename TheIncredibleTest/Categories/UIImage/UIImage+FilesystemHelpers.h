//
//  UIImage+FilesystemHelpers.h
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/8/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Cocoa
#import <UIKit/UIKit.h>

// Public Interface //
@interface UIImage (FilesystemHelpers)

///@brief Shorthand to load a image from disk.
///The actual location is the Documents dir.
///@param filename The *final* component of the image file path.
///@returns A valid UIImage if the image with the filename
///exists or nil otherwise.
+ (UIImage *)loadFromDisk:(NSString *)filename;

///@brief Shorthand to save a image from disk.
///The actual location is the Documents dir.
///@param filename The *final* component of the image file path.
- (void)saveToDisk:(NSString *)filename;

@end
