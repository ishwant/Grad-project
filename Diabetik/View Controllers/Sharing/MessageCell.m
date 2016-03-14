//
//  customCell.m
//  Diabetik
//
//  Created by project on 3/9/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@end

@implementation MessageCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        // configure control(s)
        self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, 200, 300)];
        self.cellLabel.textColor = [UIColor blackColor];
        self.cellLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:17];
        
        [self addSubview:self.cellLabel];

    }
    
    return self;
}

@end
