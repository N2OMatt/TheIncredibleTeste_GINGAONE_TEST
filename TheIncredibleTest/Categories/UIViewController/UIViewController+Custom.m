//
//  UINavigationController+Transparency.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/9/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "UIViewController+Custom.h"


// Constants //
//CODEREVIEW: Should we use the NSString const * instead?
#define kBackButtonImageName @"ic_back.png"
#define kTitleImageName      @"img_marvel_logo.png"
// Public Implementation //
@implementation UIViewController (Custom)

- (void)setupCustomBackButton
{
    id image = [UIImage imageNamed:kBackButtonImageName];
    self.navigationController.navigationBar.backIndicatorImage = image;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = image;
    
    //The strings with spaces is to hide the default "back" string.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" "
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];

}

- (void)setupCustomBarTitle
{
    id marvelImage     = [UIImage imageNamed:kTitleImageName];
    id marvelImaveView = [[UIImageView alloc] initWithImage:marvelImage];
    self.navigationItem.titleView = marvelImaveView;
}

@end
