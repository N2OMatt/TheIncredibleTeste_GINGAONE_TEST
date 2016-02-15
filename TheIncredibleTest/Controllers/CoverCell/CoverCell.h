//
//  CoverCell.h
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/7/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Cocoa
#import <UIKit/UIKit.h>
//Models
#import "ComicModel.h"

@interface CoverCell : UICollectionViewCell

// Public Properties //
@property (nonatomic) ComicModel *model;

@end
