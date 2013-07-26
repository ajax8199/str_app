//
//  TraineeManager.m
//  StrengthApp
//
//  Created by Jonny Torcivia on 11/18/11.
//  Copyright (c) 2011 William & Mary Law. All rights reserved.
//

#import "TraineeManager.h"
#import "ExerciseObject.h"
#import "sqlite3.h"
#import "SQLiteManager.h"
#import "DatabaseManager.h"
#import "ExerciseInfo.h"
#import "ExerciseDetails.h"

#define kFilename @"options.plist"

@implementation TraineeManager

@synthesize managedObjectContext;


static TraineeManager*_sharedTraineeManager = nil;

+(id)sharedTraineeManager
{
	@synchronized([TraineeManager class])
	{
		if (!_sharedTraineeManager)
			_sharedTraineeManager = [[self alloc] init];
		return _sharedTraineeManager;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([TraineeManager class])
	{
		NSAssert(_sharedTraineeManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedTraineeManager = [super alloc];
		return _sharedTraineeManager;
	}
	return nil;
}

//===========================================================================
//
// Set Methods
//
//===========================================================================

-(void) setGym:(bool)gymBool {haveGym = gymBool;}
-(void) setFacebook:(BOOL)fb {facebook = fb;}
-(void) setTwitter:(BOOL)tw {twitter = tw;}
-(void) setDatabase {dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"strengthtrainer.sqlite"];}
-(void) setWorkoutType:(NSInteger)workoutType {WorkoutType = workoutType;}


//===========================================================================
//
// Return methods
//
//===========================================================================

-(BOOL) returnFacebook {return facebook;}
-(BOOL) returnTwitter {return twitter;}
-(ExerciseObject*) returnCurrentExercise {return CurrentExercise;}
-(ExerciseObject*) returnExercise:(NSInteger) indx {return [workoutExercises objectAtIndex:indx];}
-(NSArray*) returnWorkout {return workoutExercises;}
-(NSInteger) returnWorkoutType {return WorkoutType;}


//===========================================================================
//
// Set the data file's path
//
//===========================================================================

-(NSString*) dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

//===========================================================================
//
// Clear exercises for refresh.
//
//===========================================================================

-(void) clearExercises {[workoutExercises removeAllObjects];}



//===========================================================================
//
// Controler that oversees generating a workout.  First checks for current workout and clears it.
// Second, checks for previous workout of the same time to adapt.
// Third, creates a workout based on workoutType of none of the above exist.
//
//===========================================================================

-(void) generateWorkout:(NSInteger)workoutType {

    // Here is where the workout is generated from workoutType
    // Verify that the strengthtrainer.sqlite database exists,and if not, copy to the file storage.
    
    //[self setManagedObjectContext:managedContext];
    
    [[DatabaseManager sharedDatabaseManager] verify:@"strengthtrainer.sqlite"];
    //[[DatabaseManager sharedDatabaseManager] verify:@"myrecord.sqlite"];
    
    [self setDatabase]; // Sets the strengthtrainer.sqlite database as the one that holds the exercises
    
    // Check to see if the workout exists, and if it does remove all the objects to create a new one
    // otherwise set up the space for the object
    
    if (workoutExercises == nil) {
        // Set up and allocate space for the workoutExercises array
        workoutExercises = [[NSMutableArray alloc] init];
    } else {
        // Remove the current workout
        [workoutExercises removeAllObjects];
    }
    
    // Get an Array of the previous workout of this workoutType if any (returns nil if none)
    NSMutableArray* lastWorkoutofType = (NSMutableArray *)[self returnLastWorkoutofType:workoutType];
    
    // Send to function to create the next workout.  lastWorkoutType will be nil if no previous ones.
    [self defineWorkout:lastWorkoutofType wrkType:workoutType];
}

//===========================================================================
//
// Function to define the workout.  Takes an NSArray of ExerciseObjects and the
// workout type (upper, lower, etc) in numeric form.  Returns true or false
//
//===========================================================================
#warning Should this (workouttype) be enumerated?

-(bool)defineWorkout:(NSMutableArray*) excerciseList wrkType:(NSInteger)workoutType {
    if ([excerciseList count] == 0) {
        // Exercise count is false, first time doing the exercise.
        // Create an exercised based on 'workoutType' variable
        // This is a list of exercises (not set numbers).  Although the set numbers can be indirectly
        // accessed by pulling the most recent exercises from ExerciseDetails related to the ExerciseInfo ID
        // number and see how many sets were on the last used day.
        
        if (workoutType == 1) {
            [self loadNewExercise:[self pullExercisebyID:1]];
            [self loadNewExercise:[self pullExercisebyID:5]];
            [self loadNewExercise:[self pullExercisebyID:8]];
            [self loadNewExercise:[self pullExercisebyID:15]];
            [self loadNewExercise:[self pullExercisebyID:13]];
            [self loadNewExercise:[self pullExercisebyID:22]];
            [self loadNewExercise:[self pullExercisebyID:19]];
            [self loadNewExercise:[self pullExercisebyID:26]];
            [self loadNewExercise:[self pullExercisebyID:27]];
        } else if (workoutType == 2) {
            [self loadNewExercise:[self pullExercisebyID:29]];
            [self loadNewExercise:[self pullExercisebyID:33]];
            [self loadNewExercise:[self pullExercisebyID:35]];
            [self loadNewExercise:[self pullExercisebyID:39]];
            [self loadNewExercise:[self pullExercisebyID:41]];
            [self loadNewExercise:[self pullExercisebyID:45]];
            [self loadNewExercise:[self pullExercisebyID:47]];
            [self loadNewExercise:[self pullExercisebyID:49]];
            [self loadNewExercise:[self pullExercisebyID:51]];
        } else if (workoutType ==3) {
#warning These might not be the best starter core exercises.
            [self loadNewExercise:[self pullExercisebyID:41]];
            [self loadNewExercise:[self pullExercisebyID:45]];
            [self loadNewExercise:[self pullExercisebyID:47]];
            [self loadNewExercise:[self pullExercisebyID:49]];
            [self loadNewExercise:[self pullExercisebyID:51]];
        }
        
    } else {
        // There are exercises that have been recorded for said workout, already retrieved from coredata in the array
        // Once retrieved from core data, need to fill the exercise object with the data from SQLite database for
        // the associated exercise.  Then update the object with the previous data from coredata
        
        
         for (ExerciseInfo *info in excerciseList) {
             // Can find the name, group, group_muscle, id, etc. here
             // Grab ID and then grab the exercise from SQLite.
             NSInteger idNumber = [[info valueForKey:@"id"] intValue];

             // Create the temporary exercise object
             ExerciseObject* tmpExercise = [self pullExercisebyID:idNumber];
             
             // Can then grab the Exericse details object related to the Exercise info object
             //ExerciseDetails *dt = [info valueForKey:@"details"];
             // Grabbing all ExerciseDetails objects and inserting them into an NSArray
             NSArray *all_details = [[info details] allObjects];
             NSMutableArray *tmpDetails = [[NSMutableArray alloc] init];
             
             int highestYear = 0000;
             int highestMonth = 00;
             int highestDay = 00;
             // Search through array first by year, then month, then date to find the most recent.
             
             // Find the most recent year...
             for (int i = 0; i < [all_details count]; i++) {
                 if ([[[all_details objectAtIndex:i] valueForKey:@"workoutYear"] intValue] > highestYear) {
                     highestYear = [[[all_details objectAtIndex:i] valueForKey:@"workoutYear"] intValue];
                 }
             }
             // Find the most recent month limited by year...
             for (int i = 0; i < [all_details count]; i++) {
                 if ([[[all_details objectAtIndex:i] valueForKey:@"workoutYear"] intValue] == highestYear && [[[all_details objectAtIndex:i] valueForKey:@"workoutMonth"] intValue] >= highestMonth) {
                     highestMonth = [[[all_details objectAtIndex:i] valueForKey:@"workoutMonth"] intValue];
                 }
             }
             // Find most recent day limited by year and month
             for (int i = 0; i < [all_details count]; i++) {
                 if ([[[all_details objectAtIndex:i] valueForKey:@"workoutYear"] intValue] == highestYear && [[[all_details objectAtIndex:i] valueForKey:@"workoutMonth"] intValue] == highestMonth && [[[all_details objectAtIndex:i] valueForKey:@"workoutDay"] intValue] >= highestDay) {
                     highestDay = [[[all_details objectAtIndex:i] valueForKey:@"workoutDay"] intValue];
                 }
             }
             
             // Now have most recent date (highestDay / highestMonth / highestYear)  Retreive the objects that meet the criteria for this particular exercise (info) and that should be the last done
             
             for (int i = 0; i < [all_details count]; i++) {
                 if ([[[all_details objectAtIndex:i] valueForKey:@"workoutYear"] intValue] == highestYear && [[[all_details objectAtIndex:i] valueForKey:@"workoutMonth"] intValue] == highestMonth && [[[all_details objectAtIndex:i] valueForKey:@"workoutDay"] intValue] == highestDay) {
                     
                     [tmpDetails addObject:[all_details objectAtIndex:i]];
                 }
             }
             
             // tmpDetails now has all of the sets of exercise tmpExercise
#warning How to do the decision for next workout as far as reps and weight?  Should use just the last set from the previous workout or an average of the three?
             // Assuming just use the last set...look for highest setNumber
             
             int tmpSetNumber = 0;
             int tmpObjectIndex = 0;
             for (int i = 0; i < [tmpDetails count]; i++) {
                 if ([[[tmpDetails objectAtIndex:i] valueForKey:@"setNumber"] intValue] > tmpSetNumber) {
                     // This is a higher set.  Save the place
                     tmpObjectIndex = i;
                     tmpSetNumber = [[[tmpDetails objectAtIndex:i] valueForKey:@"setNumber"] intValue];
                 }
             }
             
             // At this point, the highest set is tmpSetNumber and the object index for that set is tmpObjectIndex
             // Set number of last reps for the tmpExercise
             [tmpExercise setLastReps:[[[tmpDetails objectAtIndex:tmpObjectIndex] valueForKey:@"reps"] intValue]];
             // Set last weight for the tmpExercise
             [tmpExercise setLastWeight:[[[tmpDetails objectAtIndex:tmpObjectIndex] valueForKey:@"weight"] floatValue]];
             
             // Now need to save the exercise object to the workout queue
         
             [self loadNewExercise:tmpExercise];
        }
        
        NSArray *tmpWorkout = [[NSArray alloc] initWithArray:[[TraineeManager sharedTraineeManager] returnWorkout]];
        
        if (workoutType == 1) {
            // Check to make sure there is a full contigent of upper body workouts
            bool exerciseList[9];
            for (int i =0; i < [tmpWorkout count]; i++) {
                
                NSInteger tmpgrp = [[tmpWorkout objectAtIndex:i] returnGroup];
                NSInteger tmpmsc = [[tmpWorkout objectAtIndex:i] returnMuscle];
                
                if (tmpgrp == 1) {
                    if (tmpmsc == 1) exerciseList[4] = true;
                    else if (tmpmsc == 2) exerciseList[6] = true;
                } else if (tmpgrp == 2) {
                    if (tmpmsc == 1) exerciseList[5] = true;
                    else if (tmpmsc == 2) exerciseList[7] = true;
                } else if (tmpgrp == 4) {
                    if (tmpmsc == 1) exerciseList[1] = true;
                    else if (tmpmsc == 2) exerciseList[3] = true;
                    else if (tmpmsc == 3) exerciseList[8] = true;
                } else if (tmpgrp == 5) {
                    if (tmpmsc == 1) exerciseList[0] = true;
                    else if (tmpmsc == 3) exerciseList[2] = true;
                }
            }
            
            // Set the missing exercises here.
            if (!exerciseList[0]) [self loadNewExercise:[self pullExercisebyID:1]];
            if (!exerciseList[1]) [self loadNewExercise:[self pullExercisebyID:5]];
            if (!exerciseList[2]) [self loadNewExercise:[self pullExercisebyID:8]];
            if (!exerciseList[3]) [self loadNewExercise:[self pullExercisebyID:15]];
            if (!exerciseList[4]) [self loadNewExercise:[self pullExercisebyID:13]];
            if (!exerciseList[5]) [self loadNewExercise:[self pullExercisebyID:22]];
            if (!exerciseList[6]) [self loadNewExercise:[self pullExercisebyID:19]];
            if (!exerciseList[7]) [self loadNewExercise:[self pullExercisebyID:26]];
            if (!exerciseList[8]) [self loadNewExercise:[self pullExercisebyID:27]];
        }
        
        if (workoutType == 2) {
            // Check to make sure there is a full contigent of upper body workouts
            bool exerciseList[9];
            for (int i =0; i < [tmpWorkout count]; i++) {
                
                NSInteger tmpgrp = [[tmpWorkout objectAtIndex:i] returnGroup];
                NSInteger tmpmsc = [[tmpWorkout objectAtIndex:i] returnMuscle];
                
                if (tmpgrp == 6) {
                    if (tmpmsc == 1) exerciseList[4] = true;
                    else if (tmpmsc == 3) exerciseList[8] = true;
                } else if (tmpgrp == 7) {
                    if (tmpmsc == 2) exerciseList[5] = true;
                    else if (tmpmsc == 3) exerciseList[7] = true;
                } else if (tmpgrp == 8) {
                    if (tmpmsc == 1) exerciseList[0] = true;
                    else if (tmpmsc == 2) exerciseList[1] = true;
                    else if (tmpmsc == 3) exerciseList[2] = true;
                    else if (tmpmsc == 5) exerciseList[6] = true;
                } else if (tmpgrp == 9) {
                    if (tmpmsc == 1) exerciseList[3] = true;
                }
            }
            
            // Set the missing exercises here.
            if (!exerciseList[0]) [self loadNewExercise:[self pullExercisebyID:29]];
            if (!exerciseList[1]) [self loadNewExercise:[self pullExercisebyID:33]];
            if (!exerciseList[2]) [self loadNewExercise:[self pullExercisebyID:35]];
            if (!exerciseList[3]) [self loadNewExercise:[self pullExercisebyID:39]];
            if (!exerciseList[4]) [self loadNewExercise:[self pullExercisebyID:41]];
            if (!exerciseList[5]) [self loadNewExercise:[self pullExercisebyID:45]];
            if (!exerciseList[6]) [self loadNewExercise:[self pullExercisebyID:47]];
            if (!exerciseList[7]) [self loadNewExercise:[self pullExercisebyID:49]];
            if (!exerciseList[8]) [self loadNewExercise:[self pullExercisebyID:51]];
        }
        
        if (workoutType == 3) {
            // Check to make sure there is a full contigent of upper body workouts
            bool exerciseList[9];
            for (int i =0; i < [tmpWorkout count]; i++) {
                
                NSInteger tmpgrp = [[tmpWorkout objectAtIndex:i] returnGroup];
                NSInteger tmpmsc = [[tmpWorkout objectAtIndex:i] returnMuscle];
                
                if (tmpgrp == 6) {
                    if (tmpmsc == 1) exerciseList[4] = true;
                    else if (tmpmsc == 3) exerciseList[8] = true;
                } else if (tmpgrp == 7) {
                    if (tmpmsc == 2) exerciseList[5] = true;
                    else if (tmpmsc == 3) exerciseList[7] = true;
                } else if (tmpgrp == 8) {
                    if (tmpmsc == 5) exerciseList[6] = true;
                } 
            }
            
            // Set the missing exercises here.
            if (!exerciseList[4]) [self loadNewExercise:[self pullExercisebyID:41]];
            if (!exerciseList[5]) [self loadNewExercise:[self pullExercisebyID:45]];
            if (!exerciseList[6]) [self loadNewExercise:[self pullExercisebyID:47]];
            if (!exerciseList[7]) [self loadNewExercise:[self pullExercisebyID:49]];
            if (!exerciseList[8]) [self loadNewExercise:[self pullExercisebyID:51]];
        }
    }
    
    CurrentExercise = [workoutExercises objectAtIndex:0];
    return true;
}

//===========================================================================
//
// Save the current exercise.
//
//===========================================================================

-(void) saveExercise {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Check to see if object exists first?
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ExerciseInfo" inManagedObjectContext:context]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", [[self returnCurrentExercise] returnID]];
    NSError *error = nil;
    [request setPredicate:predicate];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSLog(@"2");
    
    if (error) {
        NSLog(@"ERROR!!!!!");
    }
    
    //NSManagedObject *exerciseInfo = [[NSManagedObject alloc] init];
    NSEntityDescription *exerciseinf = [NSEntityDescription entityForName:@"ExerciseInfo" inManagedObjectContext:self.managedObjectContext];
    
    //ExerciseInfo *exerciseInfo = [[ExerciseInfo alloc]initWithEntity:exerciseinf insertIntoManagedObjectContext:self.managedObjectContext];
    ExerciseInfo *exerciseInfo;
    
    NSLog(@"3");
    
    if ([results count] == 0) {
        //Object doesn't exist
        // Create object since it doesn't exist
        //exerciseInfo = [NSEntityDescription insertNewObjectForEntityForName:@"ExerciseInfo" inManagedObjectContext:context];
        exerciseInfo = [[ExerciseInfo alloc]initWithEntity:exerciseinf insertIntoManagedObjectContext:self.managedObjectContext];
    } else if ([results count] == 1) {
        // One object, set it into exerciseInfo
        exerciseInfo = [results objectAtIndex:0];
    } else {
        NSLog(@"More than one object is returned with this ID!");
    }
    
    NSLog(@"4");
    // Create the date information
    
    //NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    //Create the details object (new) and save it
    
    NSManagedObject *exerciseDetails = [NSEntityDescription insertNewObjectForEntityForName:@"ExerciseDetails" inManagedObjectContext:context];
    [exerciseDetails setValue:[[self returnCurrentExercise] returnName] forKey:@"name"];
    [exerciseDetails setValue:[NSNumber numberWithInt:[[self returnCurrentExercise] returnReps]] forKey:@"reps"];
    [exerciseDetails setValue:[NSNumber numberWithInt:[[self returnCurrentExercise] returnCurrentSet]] forKey:@"setNumber"];
    [exerciseDetails setValue:[NSNumber numberWithFloat:[[self returnCurrentExercise] returnCurrentWeight]] forKey:@"weight"];
    [exerciseDetails setValue:[NSNumber numberWithInt:[[[DatabaseManager sharedDatabaseManager] returnLocalDay] intValue]] forKey:@"workoutDay"];
    
    [exerciseDetails setValue:[NSNumber numberWithInt:[[[DatabaseManager sharedDatabaseManager] returnLocalMonth] intValue]] forKey:@"workoutMonth"];
    
    [exerciseDetails setValue:[NSNumber numberWithInt:[[[DatabaseManager sharedDatabaseManager] returnLocalYear] intValue]] forKey:@"workoutYear"];
    [exerciseDetails setValue:[NSNumber numberWithInt:[[[DatabaseManager sharedDatabaseManager] returnLocalTime] intValue]] forKey:@"setTime"];
    [exerciseDetails setValue:exerciseInfo forKey:@"info"];
    [exerciseInfo setValue:exerciseDetails forKey:@"details"];
    
    NSError *error2;
    
    if(![context save:&error2]) {
        NSLog(@"Failed to save the data: %@", [error2 localizedDescription]);
    }
    
    
}

//===========================================================================
//
// Incriment the exercise index and move on to the next exercise.  Return true
// means moved on to the next one, false means ran out of exercises.
//
//===========================================================================

-(BOOL) moveToNextExercise {
    CurrentExerciseIndex++;
    if ([workoutExercises count] > CurrentExerciseIndex) {
        CurrentExercise = [workoutExercises objectAtIndex:CurrentExerciseIndex];
        return true;
    }
    return false;
}

//===========================================================================
//
// Update Last reps/weight
//
//===========================================================================

-(BOOL) checkLastRepsWeight {
    NSError *error = nil; // Set up an error variable.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; // Create an NSFetchRequest object
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExerciseInfo" inManagedObjectContext:managedObjectContext]; // Set up the NSEntityDescription (the description of what you're fetching)
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id == %d", [CurrentExercise returnID]];
    
    // Grabbed all the objects from the fetch request and put them into an Array
    NSMutableArray *fetchedPredicateArray = [NSMutableArray arrayWithArray:[[managedObjectContext executeFetchRequest:fetchRequest error:&error] filteredArrayUsingPredicate:predicate]];

    //NSMutableSet *detailsSet = [[fetchedPredicateArray objectAtIndex:0] mutableSetValueForKey:@"details"];
    
    if([fetchedPredicateArray count] == 0) return false;
    NSMutableArray *detailsArray = [NSMutableArray arrayWithArray:[[[fetchedPredicateArray objectAtIndex:0] mutableSetValueForKey:@"details"] allObjects]];
    // Now I have an array of all of the details.  Need to sort this in order by date, keeping in mind the month, day and year are all independent of each other.
    NSSortDescriptor *yearSorter = [[NSSortDescriptor alloc] initWithKey:@"workoutYear" ascending:NO];
    NSSortDescriptor *monthSorter = [[NSSortDescriptor alloc] initWithKey:@"workoutMonth" ascending:NO];
    NSSortDescriptor *daySorter = [[NSSortDescriptor alloc] initWithKey:@"workoutDay" ascending:NO];
    
    // Sort the array according to the above sorters, going by year then month then day.
    [detailsArray sortUsingDescriptors:[NSArray arrayWithObjects:yearSorter, monthSorter, daySorter, nil]];

    // Have the final weight & reps in detailsArray:objectatindex:0
    if ([detailsArray objectAtIndex:0]) {
        ExerciseDetails *details = [detailsArray objectAtIndex:0];
        NSNumber *lastReps = details.reps;
        NSNumber *lastWeight = details.weight;
    
        [[[TraineeManager sharedTraineeManager] returnCurrentExercise] setLastReps:[lastReps intValue]];
        [[[TraineeManager sharedTraineeManager] returnCurrentExercise] setLastWeight:[lastWeight floatValue]];
        return true;
    } else
        return false;
    
    NSLog(@"Should never get here!");
}


//===========================================================================
//
// Returns the last workout of type exerciseType from the core data store.
//
//===========================================================================

-(NSArray*)returnLastWorkoutofType:(NSInteger) exerciseType {
    // First, check to see if there was a previous set of exercises to use
    // To do this, need to check in Core data based on the exerciseType sent in.
    // Fetch data from core data
    
    NSError *error = nil; // Set up an error variable.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; // Create an NSFetchRequest object

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExerciseInfo" inManagedObjectContext:managedObjectContext]; // Set up the NSEntityDescription (the description of what you're fetching)
    
    // Set the entity flag in the FetchRequest object so it knows what to fetch (the NSEntityDescription)
    [fetchRequest setEntity:entity];
    // retrive the objects with a given value for a certain property
    // property is the number sent int (core = 1, upper =2, lower =3, full =4) and contained in exerciseType
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"last == %d", exerciseType];
    
    // Actually fetch the request.
    //[fetchRequest setPredicate:predicate];
    // Edit the sort key as appropriate.
    // This is an example of sorting by number...might not want to do this, or maybe keep track and sort?
    /*
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"muscle" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
     */
    
    
    // Grabbed all the objects from the fetch request and put them into an Array
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Return the NSArray of fetched objects
    return [fetchedObjects filteredArrayUsingPredicate:predicate];
    /*
     for (ExerciseInfo *info in fetchedObjects) {
        
        // Can find the name, group, group_muscle, id, etc. here
        
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        
        // Can then grab the Exericse details object related to the Exercise info object
        
        ExerciseDetails *details = [info valueForKey:@"details"];
        
        NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
    }
     */
}

//===========================================================================
//
// Retrieve an exercise directly by ID number
//
//===========================================================================

-(ExerciseObject*) pullExercisebyID:(NSInteger)exerciseIDNumber {
    
    NSArray *sqlResponse = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM weights WHERE IDNumber = %d", exerciseIDNumber]];
    
    // Count the number of objects in the resonse
    NSInteger numbObjects = [sqlResponse count];
    
    if (numbObjects == 0)
        return nil;
    
    // Assign selected exercise to dictionary
    NSDictionary *selectedExercise = [[NSDictionary alloc] initWithDictionary:[sqlResponse objectAtIndex:0]];
    
    // Assign the dictionary to an exercise object and then return to controller.
    ExerciseObject *generatedExercise = [[ExerciseObject alloc] initWithDictionary:selectedExercise];
    return generatedExercise;
}

//===========================================================================
//
// Add an exerise to workoutExercises array.  Passed in as an ExerciseObject
//
//===========================================================================

-(void) loadNewExercise:(ExerciseObject*)exercise {
    for (int i = 0; i < [exercise returnReccomendedSets]; i++) {
        [workoutExercises addObject:exercise];
    }
}

//===========================================================================
//
// Set the initial options for the shared trainee manager
//
//===========================================================================
#warning Should this be done in the constructor instead?

-(void) setInitialOptions {
    Spotter = false;
    // Check to see if file exists
    NSString *filePath = [self dataFilePath];
    NSLog(@"In the initial options");
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // File exists
        // Call up plist file with options
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
        // option1 = [array objectAtIndex:0] ... etc.
        haveGym = [[array objectAtIndex:0] boolValue];
        Barbell = [[array objectAtIndex:1] boolValue];
        Dumbbell = [[array objectAtIndex:2] boolValue];
        Lever = [[array objectAtIndex:3] boolValue];
        Cable = [[array objectAtIndex:4] boolValue];
        NSLog(@"Barbell: %@", Barbell ? @"YES" : @"NO");
    } else {
        // Initial options if logging on for the first time.
        haveGym = 1;
        Barbell = 1;
        Dumbbell = 1;
        Lever = 1;
        Cable = 1;
        
        twitter = 0;
        facebook = 0;
    
        // Save initial options here, so they become the next log on options if not changed by user
#warning This should be saved some other way...perhaps a web service
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[NSString stringWithFormat:@"%@", haveGym ? @"YES" : @"NO"]];
        [array addObject:[NSString stringWithFormat:@"%@", Barbell ? @"YES" : @"NO"]];
        [array addObject:[NSString stringWithFormat:@"%@", Dumbbell ? @"YES" : @"NO"]];
        [array addObject:[NSString stringWithFormat:@"%@", Lever ? @"YES" : @"NO"]];
        [array addObject:[NSString stringWithFormat:@"%@", Cable ? @"YES" : @"NO"]];
        [array addObject:[NSString stringWithFormat:@"%@", twitter ? @"YES" : @"NO"]];
        [array addObject:[NSString stringWithFormat:@"%@", facebook ? @"YES" : @"NO"]];
        [array writeToFile:[self dataFilePath] atomically:YES];
    }
}

- (NSDictionary*) returnOptions {
    // Set up option list
    NSMutableDictionary* optionDictionary = [[NSMutableDictionary alloc] init];
    NSArray* optionList1 = [[NSArray alloc] initWithObjects:@"Gym", @"Spotter", nil];
    NSArray* optionList2 = [[NSArray alloc] initWithObjects:@"Barbells", @"Dumbbells", @"Weight Machines", @"Cables" , nil];
    [optionDictionary setObject:optionList1 forKey:@"Basic"];
    [optionDictionary setObject:optionList2 forKey:@"Equipment"];
    return optionDictionary;
}

-(bool) checkifchecked:(NSString*)optn {
    if ([optn isEqualToString:@"Gym"]) {
        return haveGym;
    }
    if ([optn isEqualToString:@"Spotter"]) {
        NSLog(@"The Spotter is: %@", Spotter ? @"YES" : @"NO");
        return Spotter;
    }
    if ([optn isEqualToString:@"Barbells"]) {
        return Barbell;
    }
    if ([optn isEqualToString:@"Dumbbells"]) {
        return Dumbbell;
    }
    if ([optn isEqualToString:@"Weight Machines"]) {
        return Lever;
    }
    if ([optn isEqualToString:@"Cables"]) {
        return Cable;
    }
    
    return false;
}

-(void) changeOption:(NSString*)optn YESorNO:(bool)optnbool {
    if ([optn isEqualToString:@"Gym"]) {
        haveGym = optnbool;
    }
    if ([optn isEqualToString:@"Spotter"]) {
        Spotter = optnbool;
    }
    if ([optn isEqualToString:@"Barbells"]) {
        Barbell = optnbool;
    }
    if ([optn isEqualToString:@"Dumbbells"]) {
        Dumbbell = optnbool;
    }
    if ([optn isEqualToString:@"Weight Machines"]) {
        Lever = optnbool;
    }
    if ([optn isEqualToString:@"Cables"]) {
        Cable = optnbool;
    }
    
    // Save the changes
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSString stringWithFormat:@"%@", haveGym ? @"YES" : @"NO"]];
    [array addObject:[NSString stringWithFormat:@"%@", Barbell ? @"YES" : @"NO"]];
    [array addObject:[NSString stringWithFormat:@"%@", Dumbbell ? @"YES" : @"NO"]];
    [array addObject:[NSString stringWithFormat:@"%@", Lever ? @"YES" : @"NO"]];
    [array addObject:[NSString stringWithFormat:@"%@", Cable ? @"YES" : @"NO"]];
    [array writeToFile:[self dataFilePath] atomically:YES];
}



-(NSString*) returnSQLString {
    NSMutableString* optionString = [[NSMutableString alloc] initWithFormat:@""];
    if (!haveGym) {
        [optionString appendString:@"AND Gym = 0"];
        return optionString;
    } else {
        [optionString appendString:@" AND ("];
    }
    if (Cable) {
        [optionString appendString:@"Cable = 1"];
    }
    if (Lever) {
        if (Cable) {
            [optionString appendString:@"OR "];
        }
        [optionString appendString:@"Lever = 1"];
    }
    if (Barbell) {
        if (Cable || Lever) {
            [optionString appendString:@"OR "];
        }
        [optionString appendString:@"Barbell = 1"];
    }
    if (Dumbbell) {
        if (Cable || Lever || Barbell) {
            [optionString appendString:@"OR "];
        }
        [optionString appendString:@"Dumbbell = 1"];
    }
    if (Cable || Lever || Barbell || Dumbbell) {
        [optionString appendString:@"OR "];
    }
    
    [optionString appendString:@"Gym = 0)"];
    
    return optionString;
}

@end
    