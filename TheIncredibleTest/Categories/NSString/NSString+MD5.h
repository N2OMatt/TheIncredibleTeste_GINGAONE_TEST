//
//  NSString+MD5.h
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/8/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Cocoa
#import <Foundation/Foundation.h>

// Public Interface //
@interface NSString (MD5)

///@brief Hash the string using the MD5 algorithm.
///@returns A new string composed with the MD5 hash.
///@see http://stackoverflow.com/questions/1524604/md5-algorithm-in-objective-c
- (NSString *)MD5String;

@end
