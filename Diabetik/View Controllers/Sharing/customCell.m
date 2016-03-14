//
//  customCell.m
//  Diabetik
//
//  Created by project on 3/9/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "customCell.h"

@interface customCell ()

@end

@implementation customCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        // configure control(s)
        self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, 300, 30)];
        self.cellLabel.textColor = [UIColor blackColor];
        self.cellLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:17];
        
        [self addSubview:self.cellLabel];
        
        self.cellSubtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 300, 30)];
        self.cellSubtitleLabel.textColor = [UIColor blackColor];
        self.cellSubtitleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        
        [self addSubview:self.cellSubtitleLabel];

        self.checkBoxButton = [[Checkbox alloc] initWithFrame:CGRectMake(15,13,30,30)];
        [self.checkBoxButton setBackgroundColor:[UIColor whiteColor]];
//        BOOL checkBoxSelected;
 /*       self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(1,20,20,20)];
                    // 20x20 is the size of the checckbox that you want
                    // create 2 images sizes 20x20 , one empty square and
                    // another of the same square with the checkmark in it
                    // Create 2 UIImages with these new images, then:
        
//        [self.checkoxButton setBackgroundImage:[UIImage imageNamed:@"notselectedcheckbox.png"]
//                                        forState:UIControlStateNormal];
        [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"ListMenuIconReminders"] forState:UIControlStateSelected];
        [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"ListMenuIconReminders"] forState:UIControlStateHighlighted];
        self.checkBoxButton.adjustsImageWhenHighlighted=YES; */
//               //     [checkbox addTarget.....]
        [self addSubview:self.checkBoxButton];
    }

    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
