    //
//  DetailViewController.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/8/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "DetailViewController.h"
//SocialKit
#import <Social/Social.h>
//Categories
#import "UIImageView+ImageCache.h"
#import "UIColor+BackgroundImage.h"
#import "UIViewController+Custom.h"
//Controllers
#import "CoverPhotoViewController.h"
#import "ComicInfoViewController.h"

// Constants //
//CODEREVIEW: Should we use NSString const * instead?
#define kDetailToCoverPhotoSegue @"kDetailToCoverPhotoSegue"
#define kDetailToComicInfoSegue  @"kDetailToComicInfoSegue"

#define kShareAlertController_Title       @"Share :)"
#define kShareAlertController_Cancel      @"Cancel"
#define kShareAlertController_Facebook    @"Facebook"
#define kShareAlertController_Twitter     @"Twitter"
#define kShareAlertController_HelpMessage @"You must be logged to share..."

#define kShareComposer_TextFormat @"I'm seeing (%@) on The Incredible Test."


// Private Interface //
@interface DetailViewController ()

// Private Properties //
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView  *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel     *publishedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel     *pagesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkImage;

@property (nonatomic) UIBarButtonItem *bookmarkToggleButton;

@end

// Implementation //
@implementation DetailViewController

// Lifecycle //
- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set the background.
    [self.view setBackgroundColor:[UIColor defaultBackgroundImage]];
    
    [self setupNavbar];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupUI];
}


// Navigation //
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    //Segue to ComicInfoViewController
    if([segue.identifier isEqualToString:kDetailToCoverPhotoSegue])
    {
        CoverPhotoViewController *controller = (CoverPhotoViewController *)segue.destinationViewController;
        controller.model = self.model;
    }
    //Segue to ComicInfoViewController
    else if([segue.identifier isEqualToString:kDetailToComicInfoSegue])
    {
        ComicInfoViewController *controller = (ComicInfoViewController *)segue.destinationViewController;
        controller.model = self.model;
    }
}


// Overriden Methods //
- (void)setModel:(ComicModel *)model
{
    if(_model == model)
        return;
    
    _model = model;
}


// Private Methods //
- (void)setupUI
{
    //Set the labels.
    self.titleLabel.text         = self.model.title;
    self.descriptionText.text    = self.model.comicDescription;
    self.publishedDateLabel.text = self.model.dateOnSale;
    self.priceLabel.text         = self.model.pricePrint;

    //Set the cover image.
    [self.coverImage imageForURL:self.model.coverSmallURL
                         success:^(UIImage *image) {
                             //Image is already assigned.
                         }
                         failure:^(NSError *error) {
                             //CODEREVIEW: FIX ME
                             //Fire a error alert?
                             //Or fallback to a default image?
                         }];
    
    [self updateBookmarkIcons];
}

- (void)setupNavbar
{
    //BackButton.
    [self setupCustomBackButton];
    //NavBar Title.
    [self setupCustomBarTitle];
    
    //Right Buttons. 
    //Share Button.
    id shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                   target:self
                                                                   action:@selector(onShareButtonPressed)];
    //Bookmark Button.
    id bookmarkImage  = [UIImage imageNamed:@"ic_bookmark_off.png"];
    self.bookmarkToggleButton = [[UIBarButtonItem alloc] initWithImage:bookmarkImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(onBookmarkTogglePressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[self.bookmarkToggleButton,
                                                  shareButton]];
}

- (void)updateBookmarkIcons
{
    UIImage *image = nil;

    if(self.model.isFavorited)
        image = [UIImage imageNamed:@"ic_bookmark_on.png"];
    else
        image = [UIImage imageNamed:@"ic_bookmark_off.png"];
    
    self.self.bookmarkToggleButton.image = image;
    self.bookmarkImage.hidden            = !self.model.isFavorited;
}

- (void)presentShareAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kShareAlertController_Title
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    //Cancel.
    id cancelAction = [UIAlertAction actionWithTitle:kShareAlertController_Cancel
                                               style:UIAlertActionStyleCancel
                                             handler:^(UIAlertAction *action) {
                                                 // Do nothing...
                                             }];
    [alertController addAction:cancelAction];
    
    
    //Facebook.
    UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:kShareAlertController_Facebook
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               //Present the Facebook Composer.
                                                               [self presentShareComposerController:SLServiceTypeFacebook];
                                                           }];
    //Only add if is available.
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        [alertController addAction:facebookAction];

    
    //Twitter.
    UIAlertAction *twitterAction = [UIAlertAction actionWithTitle:kShareAlertController_Twitter
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              //Present the Twitter Composer.
                                                              [self presentShareComposerController:SLServiceTypeTwitter];
                                                          }];
    //Only add if is available.
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        [alertController addAction:twitterAction];
    
    //Check if any action is available, if none of them are enabled
    //set the message to help user to know what to do.
    if([[alertController actions] count] == 1) //1 is for Cancel Action.
        alertController.message = kShareAlertController_HelpMessage;
    
    
    //Finally present it.
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentShareComposerController:(NSString *)type
{
    //Create.
    SLComposeViewController *composer = [SLComposeViewController
                                           composeViewControllerForServiceType:type];
    
    //Configure.
    [composer setInitialText:[NSString stringWithFormat:kShareComposer_TextFormat,
                                self.model.title]];
    [composer addImage:self.coverImage.image];
    
    //Present.
    [self presentViewController:composer
                       animated:YES
                     completion:nil];
}


// Button Callbacks //
- (void)onBookmarkTogglePressed:(id)sender
{
    self.model.isFavorited = !self.model.isFavorited;
    [self updateBookmarkIcons];
}
- (IBAction)onShareButtonPressed
{
    [self presentShareAlertController];
}

@end

