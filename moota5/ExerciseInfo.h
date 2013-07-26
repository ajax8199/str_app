//
//  ExerciseInfo.h
//  moota5
//
//  Created by Ajax on 5/27/13.
//  Copyright (c) 2013 eleganceapplications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExeciseDetails;

@interface ExerciseInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * muscle;
@property (nonatomic, retain) NSNumber * muscle_group;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * last;
@property (nonatomic, retain) NSSet *details;
@end

@interface ExerciseInfo (CoreDataGeneratedAccessors)

- (void)addDetailsObject:(ExeciseDetails *)value;
- (void)removeDetailsObject:(ExeciseDetails *)value;
- (void)addDetails:(NSSet *)values;
- (void)removeDetails:(NSSet *)values;

@end
