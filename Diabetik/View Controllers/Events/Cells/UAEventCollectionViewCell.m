//
//  UAEventCollectionViewCell.m
//  Diabetik
//
//  Created by Nial Giacomelli on 11/02/2014.
//  Copyright (c) 2013-2014 Nial Giacomelli
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "UAEventCollectionViewCell.h"

@implementation UAEventCollectionViewCell

#pragma mark - Setup
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.viewController = nil;
}

#pragma mark - Setters
- (void)setViewController:(UIViewController *)theVC
{
    if(_viewController)
    {
        [_viewController.view removeFromSuperview];
        
    }
    
    if(theVC)
    {
        _viewController = theVC;
        _viewController.view.frame = self.contentView.bounds;
        [self.contentView addSubview:_viewController.view];
    }
}

@end
