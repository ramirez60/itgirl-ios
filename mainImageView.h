//
//  mainImageView.h
//  itgirl
//
//  Created by gnamit on 10/22/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import <UIKit/UIKit.h>

//Impelementing some delegate callbacks so that my main view knows whats going on with this imageview.
@protocol imageDelegate<NSObject>;
//delegate methods
@optional
//delegate call
-(void)expandImage:(NSString *)imageTag;
-(void)viewLoaded:(NSObject *)thisView;
@end

@interface mainImageView : UIViewController
{
    UIImage *bgImage;
    NSString *picKey;
    BOOL favView;
}

@property(nonatomic, retain)NSString *picKey;
@property (nonatomic, assign)BOOL favView;
@property (assign) id <imageDelegate> delegate;
- (IBAction)tappedImage:(id)sender;
@property (retain, nonatomic)    IBOutlet UIImageView *mainImageViewer;

@property (nonatomic, retain)UIImage *bgImage;
-(void)setImageForButton:(UIImage*)newimage;
@property (retain, nonatomic) IBOutlet UIButton *btnImageView;
@end
