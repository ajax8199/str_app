//
//  SaveData.h
//  moota3
//
//  Created by Ajax on 4/29/13.
//  Copyright (c) 2013 Elegance Applications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExerciseObject.h"

@interface SaveData : NSObject {
    
}

-(void) saveExercise:(ExerciseObject*)exercise;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
