//
//  UASummaryWidgetListTableViewCell.m
//  Diabetik
//
//  Created by Nial Giacomelli on 24/04/2014.
//  Copyright (c) 2014 UglyApps. All rights reserved.
//

#import "UASummaryWidgetListTableViewCell.h"

@interface UASummaryWidgetListTableViewCell()
@property (nonatomic, strong) UIView *buttonView;
@end

@implementation UASummaryWidgetListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.buttonView = [[UIView alloc] initWithFrame:CGRectZero];
        self.buttonView.layer.borderColor = [UIColor colorWithRed:3.0f/255.0f green:211.0f/255.0f blue:173.0f/255.0f alpha:1.0f].CGColor;
        self.buttonView.layer.borderWidth = 1.0f;
        self.buttonView.layer.cornerRadius = 5.0f;
        [self.contentView addSubview:self.buttonView];
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1];
        self.textLabel.font = [UAFont standardBoldFontWithSize:16.0f];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.textColor = [UIColor colorWithRed:108.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1.0f];
        self.detailTextLabel.numberOfLines = 2;
        self.detailTextLabel.font = [UAFont standardRegularFontWithSize:14.0f];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.buttonView.frame = CGRectInset(self.bounds, 15, 5);
    
    self.textLabel.frame = CGRectMake(20.0f, self.textLabel.frame.origin.y, self.bounds.size.width - 40, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(20.0f, self.detailTextLabel.frame.origin.y, self.bounds.size.width - 40, self.detailTextLabel.frame.size.height);
//    self.textLabel.frame = CGRectInset(self.bounds, 10, 5);
}

- (void)awakeFromNib
{
    // Initialization code
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if(highlighted)
    {
        self.buttonView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:211.0f/255.0f blue:173.0f/255.0f alpha:1.0f];
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.buttonView.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1];
        self.detailTextLabel.textColor = [UIColor colorWithRed:108.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1.0f];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        self.buttonView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:211.0f/255.0f blue:173.0f/255.0f alpha:1.0f];
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.buttonView.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1];
        self.detailTextLabel.textColor = [UIColor colorWithRed:108.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1.0f];
    }
}

@end
