//
//  ExerciseObject.m
//  StrengthApp
//
//  Created by Jonny Torcivia on 11/18/11.
//  Copyright (c) 2011 Elegance Applications. All rights reserved.
//

#import "ExerciseObject.h"

@implementation ExerciseObject



-(id) initWithDictionary:(NSDictionary*)dict {

#warning check to make sure all of these are set OK
    
    exDefReps = [[dict objectForKey:@"DefReps"] intValue];
    exDefWeight = [[dict objectForKey:@"DefWeight"] floatValue];
    exID = [[dict objectForKey:@"IDNumber"] intValue];
    exName = [dict objectForKey:@"Name"];
    group = [[dict objectForKey:@"BodyTarget"] intValue];
    muscle = [[dict objectForKey:@"MuscleTarget"] intValue];
    
    cable = [[dict objectForKey:@"Cable"] boolValue];
    barbell = [[dict objectForKey:@"Barbell"] boolValue];
    dumbbell = [[dict objectForKey:@"Dumbbell"] boolValue];
    lever = [[dict objectForKey:@"Lever"] boolValue];
    gym = [[dict objectForKey:@"Gym"] boolValue];
    spotter = [[dict objectForKey:@"Spotter"] boolValue];
    difficulty = [[dict objectForKey:@"Difficulty"] boolValue];
    familiarity = [[dict objectForKey:@"Familiarity"] boolValue];
    recSets = [[dict objectForKey:@"Sets"] intValue];

    currentSet = 1;
    exReps = 0;
    exWeight = 0.0;
    totalVolume = 0.0;
    currentReps = 0;
    currentWeight = 0;
    return self;
}


//
// Set Methods
//
-(void) setExerciseReps:(NSInteger)reps {
    exReps = reps;
    if (exReps < 0.0) {
        exReps = 0.0;
    }
}
-(void) setExerciseWeight:(float)weight {
    exWeight = weight;
    if (exWeight < 0.0) {
        exWeight = 0.0;
    }
}

-(void) setExerciseID:(NSInteger)ident {exID = ident;}
-(void) setLastReps:(NSInteger)lreps {exLastReps = lreps;}
-(void) setLastWeight:(float)lweight {exLastWeight = lweight;}
-(void) setGroup:(NSInteger)grp {group = grp;}
-(void) setMuscle:(NSInteger)mscl {muscle = mscl;}
-(void) increaseSetNumber {currentSet++;}
-(void) increaseTotalVolume:(float)addVolume {totalVolume = totalVolume + addVolume;}
-(void) setRecSets:(NSInteger)rsets {recSets = rsets;}
-(void) setCurrentReps:(NSInteger)curReps {currentReps = curReps;}
-(void) setCurrentWeight:(float)curWeight {currentWeight = curWeight;}

-(void) increaseCurrentExerciseReps:(NSInteger)curRepIncrease {currentReps += curRepIncrease;}
    


//
// Return Methods
//
-(NSInteger) returnID {return exID;}
-(NSInteger) returnReccomendedSets {return recSets;}
-(NSString*) returnName {return exName;}
-(NSString*) returnLastDatePerformed {return lastDatePerformed;}
-(NSInteger) returnReps {return exReps;}
-(NSInteger) returnLastReps {return exLastReps;}
-(NSInteger) returnDefReps {return exDefReps;}
-(NSInteger) returnCurrentSet {return currentSet;}
-(NSInteger) returnGroup {return group;}
-(NSInteger) returnMuscle {return muscle;}
-(NSInteger) returnCurrentVolume {
    if (!exReps | !exWeight) {
        // No current reps/weight value.
        return 0;
    }
    return (exReps * exWeight);
}

-(void) decreaseCurrentExerciseReps:(NSInteger)curRepDecrease {currentReps = currentReps - curRepDecrease;}

-(NSInteger) returnCurrentReps{return currentReps;}
-(float) returnCurrentWeight {return currentWeight;}

-(float) returnLastWeight {return exLastWeight;}
-(float) returnDefWeight {return exDefWeight;}
-(float) returnWeight {return exWeight;}
-(float) returnTotalVolume {return totalVolume;}

-(bool) returnCable {return cable;}
-(bool) returnBarbell {return barbell;}
-(bool) returnDumbbell {return dumbbell;}
-(bool) returnLever {return lever;}
-(bool) returnGym {return gym;}
-(bool) returnSpotter {return spotter;}
-(bool) returnDifficulty {return difficulty;}
-(bool) returnFamiliarity {return familiarity;}


@end
