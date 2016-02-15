//
//  ComicInfoViewController.h
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/10/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Cocoa
#import <UIKit/UIKit.h>
//Model
#import "ComicModel.h"

// Public Interface //
@interface ComicInfoViewController : UITableViewController

// Public Properties //
@property (nonatomic) ComicModel *model;

@end
