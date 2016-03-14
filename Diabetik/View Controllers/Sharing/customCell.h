//
//  customCell.h
//  Diabetik
//
//  Created by project on 3/9/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checkbox.h"

@interface customCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) IBOutlet Checkbox *checkBoxButton;
@property (strong, nonatomic) IBOutlet UILabel *cellSubtitleLabel;

@end
