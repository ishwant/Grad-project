//
//  NSObject+TESTEvent.m
//  Diabetik
//
//  Created by project on 1/11/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "CoreEvent.h"

@implementation CoreEvent
@synthesize eventCategory, eventName, eventTimestamp, eventNotes, eventMedicineAmount, eventMedicineType, eventReadingValue, eventMealAmount, eventActivityTime, eventmessage, eventDetails;

-(id) initWitheventCategory : (NSString *) eCategory andeventName: (NSString *) eName andeventTimestamp: (NSString *) eTimestamp andeventNotes: (NSString *) eNotes andeventMedicineAmount: (NSNumber *) eMedicineAmount andeventMedicineType: (NSString *) eMedicineType andeventReadingValue: (NSNumber *) eReadingValue andeventMealAmount: (NSNumber *) eMealAmount andeventActivityTime: (NSNumber *) eActivityTime andeventDetails: (NSString *)eDetails
{
    self = [super init];
    if (self)
    {
        eventCategory = eCategory;
        eventName = eName;
        eventTimestamp = eTimestamp;
        eventNotes = eNotes;
        eventMedicineAmount = eMedicineAmount;
        eventMedicineType = eMedicineType;
        eventReadingValue = eReadingValue;
        eventMealAmount = eMealAmount;
        eventActivityTime = eActivityTime;
        eventDetails = eDetails;
    }
    
    return self;
}
-(id) initWithMessage: (NSString *) emessage
{
    eventmessage = emessage;
    return self;
}
@end




