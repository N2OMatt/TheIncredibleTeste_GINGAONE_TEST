//
//  CoverCell.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/7/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "CoverCell.h"
//Categories
#import "UIImageView+ImageCache.h"

// Constants //
//CODEREVIEW: Should we use NSString *const instead?
#define kNibName @"CoverCell"

// Private Interface //
@interface CoverCell()

// Private Properties //
@property (weak, nonatomic) IBOutlet UIImageView             *coverImage;
@property (weak, nonatomic) IBOutlet UILabel                 *issueLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UIImageView             *bookmarkImage;

// Private Methods //
- (void)setupCell;

@end


// Implementation //
@implementation CoverCell

// Lifecycle //
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //Initialization code.
        NSArray *viewsArr = [[NSBundle mainBundle] loadNibNamed:kNibName
                                                              owner:self
                                                            options:nil];
        //Something went wrong at loading.
        if([viewsArr count] < 1)
            return nil;
        
        //Assing itself to the first view.
        self = viewsArr[0];
    }
    return self;
}

// Overriden Methods //
- (void)setModel:(ComicModel *)model
{
    //Nothing to change...
    if(_model == model)
        return;
    
    _model = model;
    [self setupCell];
}

// Private Methods //
- (void)setupCell
{
    //Spins while the image is loading.
    self.loadIndicator.hidden = NO;
    [self.loadIndicator startAnimating];
    
    //Load the image async.
    [self.coverImage imageForURL:self.model.coverSmallURL
                         success:^(UIImage *image) {
                             //Image is already assigned, so just
                             //stops the loadIndicator.
                             [self.loadIndicator stopAnimating];
                             self.loadIndicator.hidden = YES;
                         }
                         failure:^(NSError *error) {
                             //CODEREVIEW: FIX ME
                             //Is better to keep the indicator animating?
                             //Fire a error alert?
                             //Or fallback to a default image?
                         }];
    
    //Set the issue number.
    self.issueLabel.text = self.model.issueNumber;
    
    //Set the bookmark image.
    self.bookmarkImage.hidden = !self.model.isFavorited;
}

@end
