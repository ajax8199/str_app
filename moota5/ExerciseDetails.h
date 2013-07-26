//
//  ExeciseDetails.h
//  moota5
//
//  Created by Ajax on 5/27/13.
//  Copyright (c) 2013 eleganceapplications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseInfo;

@interface ExerciseDetails : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * setNumber;
@property (nonatomic, retain) NSDate * setTime;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * workoutDay;
@property (nonatomic, retain) NSNumber * workoutMonth;
@property (nonatomic, retain) NSNumber * workoutYear;
@property (nonatomic, retain) ExerciseInfo *info;

@end
