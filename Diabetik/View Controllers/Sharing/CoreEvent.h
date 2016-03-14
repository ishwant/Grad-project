//
//  NSObject+TESTEvent.h
//  Diabetik
//
//  Created by project on 1/11/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreEvent : NSObject

@property (nonatomic, strong) NSString * eventCategory;
@property (nonatomic, strong) NSString * eventName;

@property (nonatomic, strong) NSString * eventTimestamp;
@property (nonatomic, strong) NSString * eventNotes;

//Medicine
@property (nonatomic, strong) NSNumber * eventMedicineAmount;
@property (nonatomic, strong) NSString * eventMedicineType;

//Reading
@property (nonatomic, strong) NSNumber * eventReadingValue;

//Meal
@property (nonatomic, strong) NSNumber * eventMealAmount;

//Activity
@property (nonatomic, strong) NSNumber * eventActivityTime;

//Message
@property (nonatomic, strong) NSString * eventmessage;

//Details
@property (nonatomic, strong) NSString * eventDetails;

//Methods

-(id) initWitheventCategory : (NSString *) eCategory andeventName: (NSString *) eName andeventTimestamp: (NSString *) eTimestamp andeventNotes: (NSString *) eNotes andeventMedicineAmount: (NSNumber *) eMedicineAmount andeventMedicineType: (NSString *) eMedicineType andeventReadingValue: (NSNumber *) eReadingValue andeventMealAmount: (NSNumber *) eMealAmount andeventActivityTime: (NSNumber *) eActivityTime andeventDetails: (NSString *)eDetails;
-(id) initWithMessage: (NSString *) emessage;

@end
