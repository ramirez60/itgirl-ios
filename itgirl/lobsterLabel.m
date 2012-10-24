//
//  lobsterLabel.m
//  itgirl
//
//  Created by gnamit on 10/16/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import "lobsterLabel.h"

@implementation lobsterLabel

-(void)awakeFromNib{
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"Lobster 1.3" size:self.font.pointSize];

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
