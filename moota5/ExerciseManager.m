//
//  ExerciseManager.m
//  StrengthApp
//
//  Created by Jonny Torcivia on 11/18/11.
//  Copyright (c) 2011 Elegance Applications. All rights reserved.
//



#import "ExerciseManager.h"
#import <stdlib.h>
#import "sqlite3.h"
#import "ExerciseObject.h"
#import "TraineeManager.h"
#import "SQLiteManager.h"
#import "DatabaseManager.h"
#import "resultsContainerObject.h"

#define DB_VERSION 1

@implementation ExerciseManager

static ExerciseManager*_sharedExerciseManager = nil;

+(id)sharedExerciseManager
{
	@synchronized([ExerciseManager class])
	{
		if (!_sharedExerciseManager) {
			_sharedExerciseManager = [[self alloc] init];
        }
		return _sharedExerciseManager;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([ExerciseManager class])
	{
		NSAssert(_sharedExerciseManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedExerciseManager = [super alloc];
		return _sharedExerciseManager;
	}
	return nil;
}

-(NSArray*) returnCulmativeResults:(NSInteger) workoutGroup specificMuscle:(NSInteger)muscleGroup {
    // Here will search for all of the applicable workouts in the database and then 
    // find which ones have been completed.  Then return all of the results by date
    // with their volume calculations
    
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"strengthtrainer.sqlite"];
    resultsManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"myrecord.sqlite"];
    
    // Get a list of all of the exercises targeting the same Muscle Group
    
    NSArray *sqlResponse = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT IDNumber FROM weights WHERE BodyTarget=%d AND MuscleTarget=%d", workoutGroup, muscleGroup]];

    // Get a count of the results
    NSInteger numbRows = [sqlResponse count];
    
    // Create array of tables
    NSMutableArray *volumeByDay = [[NSMutableArray alloc] init];

    // Loop through the results and pull the data for each exercise and store

    NSInteger fulldata = 0;
    if (numbRows > 0) {
        // You have results
        //  These results are saying X exercises match the perameters...still have to see if you did
        //  any of them.
        
        NSLog(@"There is results, %d", numbRows);
        for (int i = 0; i < numbRows; i++) {
            // Loop through.  Check to see if current array object IDNumber exists as a table
            NSString *exerciseID = [NSString stringWithFormat:@"%d", [[[sqlResponse objectAtIndex:i] objectForKey:@"IDNumber"] intValue]];

            // Doesn't take into account multiple sets
            NSArray *sqlResponse2 = [resultsManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM X%@ ORDER BY year DESC, month DESC, day DESC LIMIT 25", exerciseID]];
            NSLog(@"Select Statement: SELECT * FROM X%@ ORDER BY year DESC, month DESC, day DESC LIMIT 25", exerciseID);
            
            if ([sqlResponse2 count] == 0) {
                fulldata++;
            }
            
            NSInteger year;
            NSInteger day;
            NSInteger month;
            
            NSInteger dayCount = 0;
            //NSLog(@"1");
            for (int j = 0; j < [sqlResponse2 count]; j++) {
                NSLog(@"There is a second response, %d", [sqlResponse2 count]);
                //NSLog(@"Results of SQL %d: %@", j, [[sqlResponse2 objectAtIndex:j] objectForKey:@"WO_Reps"]);

                // Current date's day, month, and year
                //NSLog(@"2: j: %d  :: SQLREsp %@", j, [[sqlResponse2 objectAtIndex:j] objectForKey:@"year"]);
                year = [[[sqlResponse2 objectAtIndex:j] objectForKey:@"year"] intValue];
                month= [[[sqlResponse2 objectAtIndex:j] objectForKey:@"month"] intValue];
                day= [[[sqlResponse2 objectAtIndex:j] objectForKey:@"day"] intValue];
                
                //NSLog(@"2.5");
                
                NSInteger day1 = 0;
                for (int k = j; k < [sqlResponse2 count]; k++) {
                    //NSLog(@"3");
                    if ([[[sqlResponse2 objectAtIndex:k] objectForKey:@"year"] intValue] == year && [[[sqlResponse2 objectAtIndex:k] objectForKey:@"month"] intValue] == month && [[[sqlResponse2 objectAtIndex:k] objectForKey:@"day"] intValue] == day) {
                        //NSLog(@"4");
                        // Equal to last one
                        day1 = day1 + [[[sqlResponse2 objectAtIndex:k] objectForKey:@"WO_Reps"] intValue] * (int)[[[sqlResponse2 objectAtIndex:k] objectForKey:@"WO_Weight"] floatValue];
                        //NSLog(@"Current Day:%d %@", k, [[sqlResponse2 objectAtIndex:k] objectForKey:@"day"]);
                        NSLog(@"RUNNING DAY VOLUME: %d", day1);
                        //if (k + 1 < [sqlResponse2 count]) {
                        //    j = k + 1;
                        //} else {
                            j = k;
                        //}
                        
                    } else {
                        dayCount++;
                        break;
                    }
                }
                
                
                NSLog(@"Add to volume by day");
                [volumeByDay addObject:[[resultsContainerObject alloc] initWithData:day1 years:[[[sqlResponse2 objectAtIndex:j] objectForKey:@"year"] intValue] months:[[[sqlResponse2 objectAtIndex:j] objectForKey:@"month"] intValue] days:[[[sqlResponse2 objectAtIndex:j] objectForKey:@"day"] intValue]]];
                if (dayCount == 5) {
                    break;
                }
                
                //
                // Need to do something here in case all of the searched exercises are blank
                //
            }
            if ([sqlResponse2 count] == 0) {
                //No specific exercises
                NSLog(@"No Results 1");
                //[volumeByDay addObject:@"No Results1"];
                [volumeByDay addObject:[[resultsContainerObject alloc] initWithData:0 years:2999 months:12 days:31]];
            }
        }
        if (fulldata == numbRows) {
            //No data
            NSLog(@"No Results 2");
            //[volumeByDay addObject:@"No Results2"];
            [volumeByDay addObject:[[resultsContainerObject alloc] initWithData:0 years:2999 months:12 days:31]];
        }
    } else {
        // No results, add no results string (might want to change this eventually for data integrity.
        NSLog(@"No results 3");
        //[volumeByDay addObject:@"No Results3"];
        [volumeByDay addObject:[[resultsContainerObject alloc] initWithData:0 years:2999 months:12 days:31]];
    }
    
    //
    // Have array of exercises that have been done
    // Need to now combine arrays into 5 days
    //
    
    // Need to remove no results?
    
    // Need to combine same days
    NSLog(@"Day combination");
    NSLog(@"volumeByDay: %@", volumeByDay);
    NSLog(@"volumByDay count: %d", [volumeByDay count]);
    for (int r = 0; r < [volumeByDay count]; r++) {
        NSLog(@"First For, r = %d",r);
        for (int g = r + 1; g < [volumeByDay count]; g++) {
            NSLog(@"Second For, r = %d, g = %d",r,g);
            NSLog(@"Object at index: %@", [volumeByDay objectAtIndex:g]);
            if ([[volumeByDay objectAtIndex:r] compareObjects:[volumeByDay objectAtIndex:g]]) {
                NSLog(@"if statement");
                // The two are equal
                // Add them
                [[volumeByDay objectAtIndex:r] addTwoObjects:[volumeByDay objectAtIndex:g]];
                [volumeByDay removeObjectAtIndex:g];
                g--;
            }
        }
    }
    
    // Sort from most recent to least recent
    
    [volumeByDay sortUsingSelector:@selector(compareYears:)];
    [volumeByDay sortUsingSelector:@selector(compareMonths:)];
    [volumeByDay sortUsingSelector:@selector(compareDays:)];
    
    for (int t = 0; t < [volumeByDay count]; t++) {
        [[volumeByDay objectAtIndex:t] displayData];
    }
    
    // Delete all but the first five
    NSMutableArray *volumeByDay2 = [[NSMutableArray alloc] init];
    
    if ([volumeByDay count] > 5) {
        for (int y = 0; y < 5; y++) {
            [volumeByDay2 addObject:[volumeByDay objectAtIndex:y]];
        }
        NSLog(@"If Return");
        return volumeByDay2;
    }
    NSLog(@"Last Return, Vol by Day: %@", volumeByDay);
    
    return volumeByDay;
}

-(void) setUpWorkout {
    [[DatabaseManager sharedDatabaseManager] verify:@"strengthtrainer.sqlite"];
    [[DatabaseManager sharedDatabaseManager] verify:@"myrecord.sqlite"];
      
    int ChosenWorkout = [[TraineeManager sharedTraineeManager] returnWorkoutType];

    [self setDatabase];
    
    if (workoutExercises == nil) {
        // Set up and allocate space for the workoutExercises array
        workoutExercises = [[NSMutableArray alloc] init];
    } else {
        // Remove the current workout
        [workoutExercises removeAllObjects];
    }

    [self selectExercises:ChosenWorkout];
        
}

-(void) setDatabase {
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"strengthtrainer.sqlite"];
    resultsManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"myrecord.sqlite"];
    
}


-(void) selectExercises:(NSInteger)workoutTarget {
    //
    // Generate the 9 exercises
    //
    
    //
    // First, check to see if there was a previous set of exercises to use
    //
    NSMutableString *bodyTarget;
    if (workoutTarget == 1) {
        //upperbody
        [bodyTarget setString:@"ublast"];
        //bodyTarget = @"ublast";
    } else if (workoutTarget == 2) {
        //lowerbody
        [bodyTarget setString:@"lblast"];
    } else if (workoutTarget == 3) {
        //core
        [bodyTarget setString:@"cblast" ];
    } else if (workoutTarget == 4) {
        //fullbody
        [bodyTarget setString:@"fblast"];
    }
    
    NSArray *sqlResponse = [resultsManager getRowsForQuery:[NSString stringWithFormat:@"SELECT exercise FROM record WHERE %@=1", bodyTarget]];
    NSInteger numbRows = [sqlResponse count];

    if (numbRows > 0) {
        // There was a previous workout
        // Pull exercise from dbManager and assign to the dictionary
        for (int i=0; i < numbRows; i++) {
            NSDictionary *selectedExercise = [[NSDictionary alloc] initWithDictionary:[sqlResponse objectAtIndex:i]];
            NSArray *sqlResponseExercise = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT IDNumber, Name, Cable, Barbell, Dumbbell, Lever, Gym, Spotter, Difficulty, Familiarity, DefWeight, DefReps, BodyTarget, MuscleTarget FROM weights WHERE IDNumber = %d", [[selectedExercise objectForKey:@"exercise"] intValue]]];
            
            // Assign the dictionary to an exercise object
            ExerciseObject *generatedExercise = [[ExerciseObject alloc] initWithDictionary:[sqlResponseExercise objectAtIndex:0]];
            
            
            // This *should* be the last three times the exercise was done below
            NSArray *tmpExDataArray = [resultsManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM %d WHERE set=1 ORDER BY year DESC, month DESC, day DESC LIMIT 3", [[selectedExercise objectForKey:@"exercise"] intValue]]];
            
            // Determine if there was three days 
            BOOL threeDays = false;
            
            // If the tmpExDataArray returns more than two values, it means there are three to work with
            // else there are less than three and so there are not enough days to check for a plateau
            if ([tmpExDataArray count] > 2) {
                threeDays = true;
            } else {
                threeDays = false;
            }
            
            // Declare date integers
            NSInteger lastExerciseDay1 = 0;
            NSInteger lastExerciseDay2 = 0;
            NSInteger lastExerciseDay3 = 0;
            NSInteger lastExerciseMonth1 = 0;
            NSInteger lastExerciseMonth2 = 0;
            NSInteger lastExerciseMonth3 = 0;
            NSInteger lastExerciseYear1 = 0;
            NSInteger lastExerciseYear2 = 0;
            NSInteger lastExerciseYear3 = 0;
             
            
            // There should always be at least one entry in order to get here
            if ([tmpExDataArray count] > 0) {
                NSDictionary *tmpExDataDictionary1 = [[NSDictionary alloc] initWithDictionary:[tmpExDataArray objectAtIndex:0]];
            
                // get last day, month, year information for most recent date (1)
                lastExerciseDay1 = [[tmpExDataDictionary1 objectForKey:@"day"] intValue];
                lastExerciseMonth1 = [[tmpExDataDictionary1 objectForKey:@"month"] intValue];
                lastExerciseYear1 = [[tmpExDataDictionary1 objectForKey:@"year"] intValue];
                
                
            }
            if ([tmpExDataArray count] > 1) {
                NSDictionary *tmpExDataDictionary2 = [[NSDictionary alloc] initWithDictionary:[tmpExDataArray objectAtIndex:1]];
                
                // get last day, month, year information for second most recent date (2)
                lastExerciseDay2 = [[tmpExDataDictionary2 objectForKey:@"day"] intValue];
                lastExerciseMonth2 = [[tmpExDataDictionary2 objectForKey:@"month"] intValue];
                lastExerciseYear2 = [[tmpExDataDictionary2 objectForKey:@"year"] intValue];
            }
            if ([tmpExDataArray count] > 2) {
                NSDictionary *tmpExDataDictionary3 = [[NSDictionary alloc] initWithDictionary:[tmpExDataArray objectAtIndex:2]];
                
                // get last day, month, year information for third most recent date (3)
                lastExerciseDay3 = [[tmpExDataDictionary3 objectForKey:@"day"] intValue];
                lastExerciseMonth3 = [[tmpExDataDictionary3 objectForKey:@"month"] intValue];
                lastExerciseYear3 = [[tmpExDataDictionary3 objectForKey:@"year"] intValue];
            }
            
            
            BOOL plateau = FALSE;
            
            if ([tmpExDataArray count] < 3) {
                // Not enough data, no plateau
                plateau = false;
            } else {
                // Get the last three days of data
                NSArray *firstDayArray = [resultsManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM %d WHERE day=%d AND month = %d AND year = %d ORDER BY set ASC", [[selectedExercise objectForKey:@"exercise"] intValue],lastExerciseDay1,lastExerciseMonth1,lastExerciseYear1]];
                NSArray *secondDayArray = [resultsManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM %d WHERE day=%d AND month = %d AND year = %d ORDER BY set ASC", [[selectedExercise objectForKey:@"exercise"] intValue],lastExerciseDay2,lastExerciseMonth2,lastExerciseYear2]];
                NSArray *thirdDayArray = [resultsManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM %d WHERE day=%d AND month = %d AND year = %d ORDER BY set ASC", [[selectedExercise objectForKey:@"exercise"] intValue],lastExerciseDay3,lastExerciseMonth3,lastExerciseYear3]];
                
                // Calculate Volumes for each of the days
                float volumeDay1 = 0.0;
                float volumeDay2 = 0.0;
                float volumeDay3 = 0.0;
                
                for (int cnt = 0; cnt < [firstDayArray count]; cnt++) {
                    volumeDay1 = volumeDay1 + ([[[firstDayArray objectAtIndex:cnt] objectForKey:@"WO_Reps"] floatValue] * [[[firstDayArray objectAtIndex:cnt] objectForKey:@"WO_Weight"] floatValue]);
                }
                for (int cnt = 0; cnt < [secondDayArray count]; cnt++) {
                    volumeDay2 = volumeDay2 + ([[[secondDayArray objectAtIndex:cnt] objectForKey:@"WO_Reps"] floatValue] * [[[secondDayArray objectAtIndex:cnt] objectForKey:@"WO_Weight"] floatValue]);
                }
                for (int cnt = 0; cnt < [thirdDayArray count]; cnt++) {
                    volumeDay3 = volumeDay3 + ([[[thirdDayArray objectAtIndex:cnt] objectForKey:@"WO_Reps"] floatValue] * [[[thirdDayArray objectAtIndex:cnt] objectForKey:@"WO_Weight"] floatValue]);
                }
                
                // Take three volume totals and check for plateau
                // creat an int and cast the float averages into it for total average
                float runningVolumeAverage = (volumeDay1 + volumeDay2 + volumeDay3) / 3;
                float deviationValue = volumeDay1 - runningVolumeAverage;
                if (deviationValue > (runningVolumeAverage * 0.05)) {
                    // Deviation greater than 5% of average volume
                    plateau = TRUE;
                } else {
                    plateau = FALSE;
                }
            }
            
            // Plateau is true or false here
            
            if (plateau) {
                // Plataeu, assign new exercise
                NSInteger exNumb = [[[sqlResponseExercise objectAtIndex:0] objectForKey:@"BodyTarget"] intValue];
                NSInteger exMusc = [[[sqlResponseExercise objectAtIndex:0] objectForKey:@"MuscleTarget"] intValue];
                [self pullExercise:exNumb selMuscle:exMusc];
            } else {
                // No plataeu, assign last reps and weight
                // sqlResponseExercise object at index 0, has the BodyTarget and MuscleTarget information from the last recorded set
                NSArray *sqlExerciseRepsWeight = [resultsManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM %d ORDER BY year DESC, month DESC, day DESC, set DESC LIMIT 1", [[selectedExercise objectForKey:@"exercise"] intValue]]];
                [generatedExercise setLastReps:[[[sqlExerciseRepsWeight objectAtIndex:0] objectForKey:@"WO_Reps"] intValue]];
                [generatedExercise setLastWeight:[[[sqlExerciseRepsWeight objectAtIndex:0] objectForKey:@"WO_Weight"] floatValue]];
                
                // Place this Exercise object into our array of exercises being generated.
                [workoutExercises addObject:generatedExercise]; 
            }
        }
    } else {
        // If no previous set, generate a new one
        NSLog(@"GENERATE NEW SET OF EXERCISES, workout target: %d", workoutTarget);
        if (workoutTarget == 1) {
            [self setNewUpperBodyWorkout];
        } else if (workoutTarget == 2) {
            [self setNewLowerBodyWorkout];
        } else if (workoutTarget == 3) {
            [self setNewCoreWorkout];
        } else if (workoutTarget == 4) {
            [self setNewFullBodyWorkout];
        }
        
    }
}

//
// Pull functions
//
-(void) pullExercise:(int)group selMuscle:(int)muscle {
    NSArray *sqlResponse = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT IDNumber, Name, Cable, Barbell, Dumbbell, Lever, Gym, Spotter, Difficulty, Familiarity, DefWeight, DefReps, BodyTarget, MuscleTarget FROM weights WHERE BodyTarget = %d AND MuscleTarget = %d %@", group, muscle, [[TraineeManager sharedTraineeManager] returnSQLString]]];
    
    // Count the number of objects in the resonse
    NSInteger numbObjects = [sqlResponse count];

    if (numbObjects == 0) {
        return;
    }
    
    // Form a random number between 0 and (numbObjects - 1)
    NSInteger radomAssign = arc4random() % numbObjects;
    
    // Assign selected exercise to dictionary
    NSDictionary *selectedExercise = [[NSDictionary alloc] initWithDictionary:[sqlResponse objectAtIndex:radomAssign]];
    //NSLog(@"The selected Exercise: %@", selectedExercise);
    
    // Assign the dictionary to an exercise object
    ExerciseObject *generatedExercise = [[ExerciseObject alloc] initWithDictionary:selectedExercise];
    
    // Determine how many sets, and place one for each object in.
    for (int i = 0; i < 3; i++) {
        // Place this Exercise object into our array of exercises being generated.
        [workoutExercises addObject:generatedExercise];   
        [generatedExercise increaseSetNumber]; 
    }
}




-(void) pullExercisebyID:(NSInteger)exerciseIDNumber {
    //NSLog(@"In the exercise by ID function");
    //NSArray *sqlResponse = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT IDNumber, Name, Cable, Barbell, Dumbbell, Lever, Gym, Spotter, Difficulty, Familiarity, DefWeight, DefReps, BodyTarget, MuscleTarget FROM weights WHERE IDNumber = %d", exerciseIDNumber]];
    NSArray *sqlResponse = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM weights WHERE IDNumber = %d", exerciseIDNumber]];
    NSLog(@"ARRAY: %@",sqlResponse);
    
    // Count the number of objects in the resonse
    NSInteger numbObjects = [sqlResponse count];
    
    if (numbObjects == 0) {
        return;
    }
    
    // Assign selected exercise to dictionary
    NSDictionary *selectedExercise = [[NSDictionary alloc] initWithDictionary:[sqlResponse objectAtIndex:0]];
  
    // Assign the dictionary to an exercise object (need to do three
    ExerciseObject *generatedExercise1 = [[ExerciseObject alloc] initWithDictionary:selectedExercise];
    ExerciseObject *generatedExercise2 = [[ExerciseObject alloc] initWithDictionary:selectedExercise];
    ExerciseObject *generatedExercise3 = [[ExerciseObject alloc] initWithDictionary:selectedExercise];

    [generatedExercise2 increaseSetNumber];
    [generatedExercise3 increaseSetNumber];
    [generatedExercise3 increaseSetNumber];
    
    [workoutExercises addObject:generatedExercise1];   
    [workoutExercises addObject:generatedExercise2];   
    [workoutExercises addObject:generatedExercise3];   
    
    
    //NSLog(@"GENERATED EXERCISE 1: %d", [[workoutExercises objectAtIndex:0] returnCurrentSet]);
    //NSLog(@"GENERATED EXERCISE 2: %d", [[workoutExercises objectAtIndex:1] returnCurrentSet]);
    //NSLog(@"GENERATED EXERCISE 3: %d", [[workoutExercises objectAtIndex:2] returnCurrentSet]);
    
    //NSLog(@"It has been added, workoutExercises has %d objects", [workoutExercises count]);

}

//
// Set functions
//

-(void) setNewUpperBodyWorkout {
    //NSLog(@"SetNewUpperBodyWorkout Function");
    [self pullExercisebyID:1];
    [self pullExercisebyID:5];
    [self pullExercisebyID:8];
    [self pullExercisebyID:15];
    [self pullExercisebyID:13];
    [self pullExercisebyID:22];
    [self pullExercisebyID:19];
    [self pullExercisebyID:26];
    [self pullExercisebyID:27];
    //NSLog(@"Finished Upper Body Workout Function");
    
    /*
    // This version is random.
    [self pullExercise:5 selMuscle:1];
    [self pullExercise:4 selMuscle:1];
    [self pullExercise:5 selMuscle:3];
    [self pullExercise:4 selMuscle:2];
    [self pullExercise:1 selMuscle:1];
    [self pullExercise:1 selMuscle:2];
    [self pullExercise:2 selMuscle:1];
    [self pullExercise:2 selMuscle:2];
    [self pullExercise:4 selMuscle:3];
     */
}

#warning Here is where we need to generate lower, core, full workouts.
-(void) setNewLowerBodyWorkout {
    //Non random first workout, pull by specific exercise numbers
    [self pullExercisebyID:29];
    [self pullExercisebyID:33];
    [self pullExercisebyID:35];
    [self pullExercisebyID:39];
    [self pullExercisebyID:41];
    [self pullExercisebyID:45];
    [self pullExercisebyID:47];
    [self pullExercisebyID:49];
    [self pullExercisebyID:51];
    
    /*
     // This version is random.
     [self pullExercise:8 selMuscle:1];
     [self pullExercise:8 selMuscle:2];
     [self pullExercise:8 selMuscle:3];
     [self pullExercise:9 selMuscle:1];
     [self pullExercise:6 selMuscle:1];
     [self pullExercise:7 selMuscle:2];
     [self pullExercise:8 selMuscle:5];
     [self pullExercise:7 selMuscle:3];
     [self pullExercise:6 selMuscle:3];
     */
}

-(void) setNewCoreWorkout {
    //Non random first workout, pull by specific exercise numbers
    [self pullExercisebyID:41];
    [self pullExercisebyID:45];
    [self pullExercisebyID:47];
    [self pullExercisebyID:49];
    [self pullExercisebyID:51];
    
    /*
     // This version is random.
     [self pullExercise:6 selMuscle:1];
     [self pullExercise:7 selMuscle:2];
     [self pullExercise:8 selMuscle:5];
     [self pullExercise:7 selMuscle:3];
     [self pullExercise:6 selMuscle:3];
     */
}

-(void) setNewFullBodyWorkout {
    //Non random first workout, pull by specific exercise numbers
    
}
-(void) setExerciseNumber:(NSInteger)exNumber {exerciseNumber = exNumber;}

//
// Return functions
//
-(NSMutableArray*) returnExercises {return workoutExercises;}
-(NSInteger) returnExerciseNumber {return exerciseNumber;}
-(NSInteger) returnExerciseID {return [[workoutExercises objectAtIndex:exerciseNumber] returnID];}
-(NSInteger) returnNumberOfExercises {return [workoutExercises count];}
-(ExerciseObject*) returnSpecificExercise:(NSInteger)exerciseIndex {
    return [workoutExercises objectAtIndex:exerciseIndex];
}
-(NSArray*) returnCombinedExercises {return combinedExercises;}
-(NSString*) returnLocalDay {
    // Set up local date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Date format
    dateFormatter.dateFormat = @"dd";
    // Set local timezone
    NSTimeZone *localTime = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTime];
    return [dateFormatter stringFromDate:[NSDate date]];
    
}
-(NSString*) returnLocalMonth {
    // Set up local date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Date format
    dateFormatter.dateFormat = @"MM";
    // Set local timezone
    NSTimeZone *localTime = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTime];
    return [dateFormatter stringFromDate:[NSDate date]];
    
}
-(NSString*) returnLocalYear {
    // Set up local date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Date format
    dateFormatter.dateFormat = @"yyyy";
    // Set local timezone
    NSTimeZone *localTime = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTime];
    return [dateFormatter stringFromDate:[NSDate date]];
    
}

//
// Update functions
//
-(void) updateExerciseReps:(NSInteger) reps {[[workoutExercises objectAtIndex:exerciseNumber] setExerciseReps:reps];}
-(void) updateExerciseWeight:(float) weight {[[workoutExercises objectAtIndex:exerciseNumber] setExerciseWeight:weight];}
 
//
// Combine functions
//
-(void) combineLikeExercises {
    // Create a final array that will have the condensed exercise objects
    NSMutableArray *condensedArray = [[NSMutableArray alloc] init];
    // Create a temporary array object to hold the workoutExercises array (to manipulate)
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    // Load the temporary array with all the execise objects
    for (int i = 0; i < [workoutExercises count]; i++) {
        [tmpArray addObject:[workoutExercises objectAtIndex:i]];
    }
    
    int j = 0;
    
    while ([tmpArray count]) {
        //[condensedArray addObject:[tmpArray objectAtIndex:j]];
        [condensedArray addObject:[tmpArray objectAtIndex:0]];

        //NSLog(@"Condensed Array %d: %@", j, [[condensedArray objectAtIndex:j] returnName]);
        //NSLog(@"Remove in first while: %d %@", j, [[tmpArray objectAtIndex:j] returnName]);

        //[tmpArray removeObjectAtIndex:j];
        [tmpArray removeObjectAtIndex:0];

        // Set initial global volume tracker here...
        [[condensedArray objectAtIndex:j] increaseTotalVolume:((float)[[condensedArray objectAtIndex:j] returnReps] * [[condensedArray objectAtIndex:j] returnWeight])];
        //NSLog(@"Total Volume Initial: %1.1f", [[condensedArray objectAtIndex:j] returnTotalVolume]);
        
        int k = 0;
        while (k < [tmpArray count]) {
            //NSLog(@"Exercises: %d %@", k, [[tmpArray objectAtIndex:k] returnName]);
            if ([[condensedArray objectAtIndex:j] returnID] == [[tmpArray objectAtIndex:k] returnID]) {
                //NSLog(@"Are elements the same? 1: %@, 2: %@", [[condensedArray objectAtIndex:j] returnName],[[tmpArray objectAtIndex:k] returnName]);
                //Add elements together
                [[condensedArray objectAtIndex:j] increaseTotalVolume:((float)[[tmpArray objectAtIndex:k] returnReps] * [[tmpArray objectAtIndex:k] returnWeight])];
                //NSLog(@"Added Total Volume: %1.1f", [[condensedArray objectAtIndex:j] returnTotalVolume]);
                
                //Delete object
                //NSLog(@"Delete: %d %@", k, [[tmpArray objectAtIndex:k] returnName]);
                [tmpArray removeObjectAtIndex:k];
            } else { 
                k++;
            }
        }
        j++;
    }
    
    combinedExercises = condensedArray;
    // Now have an array of all the objects, condensedArray
}


//
// Swap functions
//

-(void) swapExercise {
    NSArray *sqlResponse = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT IDNumber, Name, Cable, Barbell, Dumbbell, Lever, Gym, Spotter, Difficulty, Familiarity, DefWeight, DefReps, BodyTarget, MuscleTarget FROM weights WHERE BodyTarget = %d AND MuscleTarget = %d", [[self returnSpecificExercise:exerciseNumber] returnGroup], [[self returnSpecificExercise:exerciseNumber] returnMuscle]]];
    
    // Count the number of objects in the resonse
    NSInteger numbObjects = [sqlResponse count];
    
    if (numbObjects == 0) {
        // No swapable objects
        return;
    }
    
    // Form a random number between 0 and (numbObjects - 1)
    NSInteger radomAssign = arc4random() % numbObjects;
    
    // Assign selected exercise to dictionary
    NSDictionary *selectedExercise = [[NSDictionary alloc] initWithDictionary:[sqlResponse objectAtIndex:radomAssign]];
    //NSLog(@"The selected Exercise: %@", selectedExercise);
    
    // Assign the dictionary to an exercise object
    ExerciseObject *generatedExercise = [[ExerciseObject alloc] initWithDictionary:selectedExercise];
    
    // Now need to swap out current exercise with this new exercise, as well as any additional exercises that are the same as the old one.
    // Doesn't replace previous exercises.
    [workoutExercises replaceObjectAtIndex:(exerciseNumber-1) withObject:generatedExercise];
    
    for (int i = exerciseNumber; i < [workoutExercises count]; i++) {
        if ([[workoutExercises objectAtIndex:i] returnID] == [generatedExercise returnID]) {
            //Same exercise
            [workoutExercises replaceObjectAtIndex:i withObject:generatedExercise];
#warning All of these will be set '1'
        }
    }
    
}

-(NSString*) returnExerciseHelp {
    NSInteger exID = [[workoutExercises objectAtIndex:exerciseNumber] returnID];
    return @"string";
}

@end
