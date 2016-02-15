//
//  CoverPhotoViewController.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/9/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "CoverPhotoViewController.h"
//Categories
#import "UIImageView+ImageCache.h"
#import "UIViewController+Custom.h"
#import "UIColor+BackgroundImage.h"


// Constants //
//CODEREVIEW: Should we use NSString *const instead?
#define kCellReusableIdentifier @"CoverCell"
#define kFooterReusableView     @"kReusableViewFooter"
#define kListToDetailSegue      @"kListToDetailSegue"
#define kListToAboutSegue       @"kListToAboutSegue"

#define kCollectionViewSectionsCount 1

#define kDownloadFailedAlertController_Title @"Download Failed."
#define kDownloadFailedAlertController_Ok    @"Ok"


// Private Interface //
@interface CoverPhotoViewController ()
    <UIScrollViewDelegate>

// Private Properties //
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (nonatomic) UIActivityIndicatorView *loadIndicator;

@end


// Implementation //
@implementation CoverPhotoViewController

// Lifecycle //
- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set the background.
    [self.view setBackgroundColor:[UIColor defaultBackgroundImage]];

    ///Setup NavBar.
    [self setupCustomBarTitle];
    [self setupCustomBackButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Create and setup the Load Indicator.
    self.loadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.loadIndicator startAnimating];
    
    //Add the Load Indicator to NavBar.
    id item = [[UIBarButtonItem alloc] initWithCustomView:self.loadIndicator];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.coverImage imageForURL:self.model.coverBigURL
                         success:^(UIImage *image) {
                             //Image is already assigned.
                             //So just stop and remove the loading idicator.
                             [self.loadIndicator stopAnimating];
                             self.navigationItem.rightBarButtonItem = nil;
                         }
                         failure:^(NSError *error) {
                             //Stop and remove the loading idicator.
                             [self.loadIndicator stopAnimating];
                             self.navigationItem.rightBarButtonItem = nil;
                             
                             [self presentDownloadErrorAlertController:error];
                         }];
}


// Helper Methods //
- (void)presentDownloadErrorAlertController:(NSError *)error
{
    //Create the alert
    id alert = [UIAlertController alertControllerWithTitle:kDownloadFailedAlertController_Title
                                                   message:[error localizedDescription]
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    //Create the OK action.
    id okAction = [UIAlertAction actionWithTitle:kDownloadFailedAlertController_Ok
                                           style:UIAlertActionStyleCancel
                                         handler:nil];
    [alert addAction:okAction];
    
    
    //Present the alert.
    [self presentViewController:alert animated:YES completion:nil];
}


// ScrollView Delegate //
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.coverImage;
}

@end
