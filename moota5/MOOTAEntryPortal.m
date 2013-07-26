//
//  MOOTAEntryPortal.m
//  moota5
//
//  Created by Ajax on 5/22/13.
//  Copyright (c) 2013 eleganceapplications. All rights reserved.
//

#import "MOOTAEntryPortal.h"
#import "TraineeManager.h"
#import "ExerciseManager.h"
#import "ExerciseObject.h"
#import "DatabaseManager.h"


@interface MOOTAEntryPortal ()

@end

@implementation MOOTAEntryPortal
@synthesize ActualReps, ActualWeight;
@synthesize SuggestedReps, SuggestedWeight;
@synthesize LastReps, LastWeight;
@synthesize weightPicker, weightpickerBorder;
@synthesize ExerciseName, backgroundImage;
@synthesize picktheweight;
@synthesize nextExerciseButton, topMenuBackground;
@synthesize setNumber;
@synthesize hitGoal, recycleButton, goalrepsBackground;
@synthesize socialmediabarButton, whiteBehindSocialMedia;
@synthesize addRep, subtractRep;
@synthesize threeButton, fiveButton, eightButton, twelveButton, fifteenButton, twentyfiveButton;
@synthesize facebutton, twitbutton, tap;
@synthesize currentDisplayBackground, socialBackground;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        progressAsInt = 0;
        socialmenushow = 1;
    }
    return self;
}

-(IBAction)alertmessage:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert Message" message:@"This is an alert" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"Double Tap");
}



-(IBAction)summonSocialMenuBar:(id)sender {
    
    NSLog(@"SOCIAL MENU SHOW: %d", socialmenushow);
    // Move items accordingly
    [self moveimagesby:76.0 upordown:socialmenushow];
    
    // Reverse the bool for next press of the button
    if (socialmenushow) {
        socialmenushow = false;
    } else {
        socialmenushow = true;
    }
}

//========================================================================
//
// Animation of all of the object down to show social media bar
//
//========================================================================

-(void)moveimagesby:(float)movement upordown:(bool)updown {
    float upordown = 0.0;
    
    //
    // Sets up the animation timing for the buttons and images
    //
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35f];
    
    if (updown) {
        //
        // Show social media bar
        //
        CGRect frameRectBackground = socialBackground.frame;
        frameRectBackground.origin.y = 0.0f;
        socialBackground.frame = frameRectBackground;
        [self.view addSubview:socialBackground];
        upordown = movement - 4.0;
        
        
        [self.view addSubview:facebutton];
        CGPoint newfacebook = CGPointMake(30.0f +facebutton.frame.size.width / 2.0f, movement + facebutton.center.y);
        facebutton.center = newfacebook;
        facebutton.hidden = false;
        
        [self.view addSubview:twitbutton];
        CGPoint newtwitter = CGPointMake(100.0 + twitbutton.frame.size.width / 2.0f, movement + twitbutton.center.y);
        twitbutton.center = newtwitter;
        twitbutton.hidden = false;
        
        
        
    } else {
        // Social media bar needs to disapear
        //[socialBackground removeFromSuperview];
        CGRect frameRectBackground = socialBackground.frame;
        frameRectBackground.origin.y = -76.0f;
        socialBackground.frame = frameRectBackground;
        movement = movement * -1.0;
        upordown = movement + 4.0;
        
        // facebook/twitter
        CGPoint newfacebook = CGPointMake(30.0f +facebutton.frame.size.width / 2.0f, movement + facebutton.center.y);
        facebutton.center = newfacebook;
        //facebutton.hidden = true;
        
        CGPoint newtwitter = CGPointMake(100.0 + twitbutton.frame.size.width / 2.0f, movement + twitbutton.center.y);
        twitbutton.center = newtwitter;
        //twitbutton.hidden = true;
        
    }
    
    
    // Make buttons move
    CGPoint newSMSettingsCenter = CGPointMake(5.0f + socialmediabarButton.frame.size.width / 2.0f, upordown + socialmediabarButton.center.y);
    CGPoint newRecycleButton = CGPointMake(58.0f +recycleButton.frame.size.width / 2.0f, movement + recycleButton.center.y); //updown
    CGPoint newSetNumber = CGPointMake(130.0f +setNumber.frame.size.width / 2.0f, movement + setNumber.center.y);
    CGPoint newHitGoal = CGPointMake(215.0f +hitGoal.frame.size.width / 2.0f, movement + hitGoal.center.y); //updown
    CGPoint newNextExButton = CGPointMake(268.0f +nextExerciseButton.frame.size.width / 2.0f, movement + nextExerciseButton.center.y); //updown
    CGPoint newfive = CGPointMake(79.0f +fiveButton.frame.size.width / 2.0f, movement + fiveButton.center.y);
    CGPoint newthree = CGPointMake(19.0f +threeButton.frame.size.width / 2.0f, movement + threeButton.center.y);
    CGPoint neweight = CGPointMake(139.0f +eightButton.frame.size.width / 2.0f, movement + eightButton.center.y);
    CGPoint newtwelve = CGPointMake(19.0f +twelveButton.frame.size.width / 2.0f, movement + twelveButton.center.y);
    CGPoint newfifteen = CGPointMake(79.0f +fifteenButton.frame.size.width / 2.0f, movement + fifteenButton.center.y);
    CGPoint newtwentyfive = CGPointMake(139.0f +twentyfiveButton.frame.size.width / 2.0f, movement + twentyfiveButton.center.y);
    CGPoint newaddrep = CGPointMake(139.0f +addRep.frame.size.width / 2.0f, movement + addRep.center.y);
    CGPoint newpickweight = CGPointMake(83.0f +picktheweight.frame.size.width / 2.0f, movement + picktheweight.center.y);
    CGPoint newsubrep = CGPointMake(19.0f +subtractRep.frame.size.width / 2.0f, movement + subtractRep.center.y);
    //CGPoint newrepslabel = CGPointMake(79.0f +repsLabel.frame.size.width / 2.0f, movement + repsLabel.center.y);
    CGPoint newactualreps = CGPointMake(170.0f +ActualReps.frame.size.width / 2.0f, movement + ActualReps.center.y);
    CGPoint newactualweight = CGPointMake(92.0f +ActualWeight.frame.size.width / 2.0f, movement + ActualWeight.center.y);
    CGPoint newsuggestweight = CGPointMake(234.0f +SuggestedWeight.frame.size.width / 2.0f, movement + SuggestedWeight.center.y);
    CGPoint newsuggestreps = CGPointMake(291.0f +SuggestedReps.frame.size.width / 2.0f, movement + SuggestedReps.center.y);
    CGPoint newlastweight = CGPointMake(234.0f +LastWeight.frame.size.width / 2.0f, movement + LastWeight.center.y);
    CGPoint newlastreps = CGPointMake(291.0f +LastReps.frame.size.width / 2.0f, movement + LastReps.center.y);
    CGPoint newexercisename = CGPointMake(4.0f +ExerciseName.frame.size.width / 2.0f, movement + ExerciseName.center.y);
    //CGPoint newcurrentlabel = CGPointMake(4.0f +currentLabel.frame.size.width / 2.0f, movement + currentLabel.center.y);
    CGPoint newweightpicker = CGPointMake(234.0f +weightPicker.frame.size.width / 2.0f, movement + weightPicker.center.y);
    //CGPoint newlastlabel = CGPointMake(234.0f +lastLabel.frame.size.width / 2.0f, movement + lastLabel.center.y);
    CGPoint newgoalrepsbackground = CGPointMake(235.0 + goalrepsBackground.frame.size.width / 2.0f, movement + goalrepsBackground.center.y);
    //CGPoint newgoallabel = CGPointMake(234.0f +goalLabel.frame.size.width / 2.0f, movement + goalLabel.center.y);
    
    
    
    
    recycleButton.center = newRecycleButton; setNumber.center = newSetNumber; hitGoal.center = newHitGoal; nextExerciseButton.center = newNextExButton; socialmediabarButton.center = newSMSettingsCenter;
    fiveButton.center = newfive; threeButton.center = newthree; eightButton.center = neweight; twelveButton.center = newtwelve; fifteenButton.center = newfifteen; twentyfiveButton.center = newtwentyfive; addRep.center = newaddrep; picktheweight.center = newpickweight; subtractRep.center = newsubrep; ActualReps.center = newactualreps; ActualWeight.center = newactualweight;
    //repsLabel.center = newrepslabel;
    SuggestedReps.center = newsuggestreps; SuggestedWeight.center = newsuggestweight; LastWeight.center = newlastweight; LastReps.center = newlastreps; ExerciseName.center = newexercisename;  weightPicker.center = newweightpicker;
    //lastLabel.center = newlastlabel;
    goalrepsBackground.center = newgoalrepsbackground;
    //goalLabel.center = newgoallabel;
    //currentLabel.center = newcurrentlabel;
    
    //
    // Create the major social media sharing icons (eg. twitter)
    // These need to be buttons actually....
    //
    //
    // set up image frame objects
    //
    CGRect frameRectWhiteBack = whiteBehindSocialMedia.frame;
    CGRect frameBlackBack = topMenuBackground.frame;
    CGRect frameweightpickerborder = weightpickerBorder.frame;
    //CGRect framecurweightback = curWeigBack.frame;
    //CGRect framecurrepsback = curRepsBack.frame;
    CGRect framecurrentdisplaybackground = currentDisplayBackground.frame;
    CGRect framebackgroundimage = backgroundImage.frame;
    //CGRect framerepsbuttonbackground = repsButtonBackground.frame;
    
    
    
    if (updown) {
        // Set UIImages to move
        frameRectWhiteBack.origin.y = movement;
        whiteBehindSocialMedia.frame = frameRectWhiteBack;
        
        frameBlackBack.origin.y = movement;
        topMenuBackground.frame = frameBlackBack;
        frameweightpickerborder.origin.y = movement + 175.0;
        weightpickerBorder.frame = frameweightpickerborder;
        //framecurweightback.origin.y = movement + 130.0;
        //curWeigBack.frame = framecurweightback;
        //framecurrepsback.origin.y = movement + 130.0;
        //curRepsBack.frame = framecurrepsback;
        framecurrentdisplaybackground.origin.y = movement + 130.0;
        currentDisplayBackground.frame = framecurrentdisplaybackground;
        framebackgroundimage.origin.y = movement;
        backgroundImage.frame = framebackgroundimage;
        //framerepsbuttonbackground.origin.y = movement + 207.0;
        //repsButtonBackground.frame = framerepsbuttonbackground;
    } else {
        frameRectWhiteBack.origin.y = 4.0;
        whiteBehindSocialMedia.frame = frameRectWhiteBack;
        frameBlackBack.origin.y = 0.0;
        topMenuBackground.frame = frameBlackBack;
        frameweightpickerborder.origin.y = 175.0;
        weightpickerBorder.frame = frameweightpickerborder;
        //framecurweightback.origin.y = 130.0;
        //curWeigBack.frame = framecurweightback;
        //framecurrepsback.origin.y = 130.0;
        //curRepsBack.frame = framecurrepsback;
        framecurrentdisplaybackground.origin.y = 130.0;
        currentDisplayBackground.frame = framecurrentdisplaybackground;
        framebackgroundimage.origin.y = 0.0;
        backgroundImage.frame = framebackgroundimage;
        //framerepsbuttonbackground.origin.y =  207.0;
        //repsButtonBackground.frame = framerepsbuttonbackground;
    }
    
    // Commit the animations for everything
    [UIView commitAnimations];
}

//========================================================================
//
// Adds a rep for +, or sets the reps at the button number if other pushed
//
//========================================================================

-(IBAction)addRep:(id)sender {
    if ([[sender currentTitle] isEqualToString:@"+"]) [[[TraineeManager sharedTraineeManager] returnCurrentExercise] increaseCurrentExerciseReps:1];
    else [[[TraineeManager sharedTraineeManager] returnCurrentExercise] setCurrentReps:[[sender currentTitle] intValue]];
    
    ActualReps.text = [NSString stringWithFormat:@"%d", [[[TraineeManager sharedTraineeManager] returnCurrentExercise] returnCurrentReps]];    
}

//========================================================================
//
// Subtracts one rep
//
//========================================================================

-(IBAction)subtractRep:(id)sender {
    
    [[[TraineeManager sharedTraineeManager] returnCurrentExercise] decreaseCurrentExerciseReps:1];
    
    ActualReps.text = [NSString stringWithFormat:@"%d", [[[TraineeManager sharedTraineeManager] returnCurrentExercise] returnCurrentReps]];
    
    //[[ExerciseManager sharedExerciseManager] updateExerciseReps:progressAsInt];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
	// Do any additional setup after loading the view.
    //
    // Set up the social background image
    //
    socialBackground = [[UIImageView alloc] initWithFrame:
                        CGRectMake(0.0, -76.0, 320.0, 76.0)];
    socialBackground.image = [UIImage imageNamed:@"socialmenubar.png"];
    socialmenushow = 1;
    
    //
    // Set up the social sharing buttons
    //
    /*
    facebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebutton addTarget:self action:@selector(turnonface:) forControlEvents:UIControlEventTouchDown];
    facebutton.frame = CGRectMake(30.0,-70.0,64.0,64.0);
    facebutton.hidden = true;
    if ([[TraineeManager sharedTraineeManager] returnFacebook]) {
        [facebutton setImage:[UIImage imageNamed:@"facebookSelected.png"] forState:UIControlStateNormal];
        [facebutton setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateHighlighted];
    } else {
        [facebutton setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
        [facebutton setImage:[UIImage imageNamed:@"facebookSelected.png"] forState:UIControlStateHighlighted];
    }
    twitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitbutton addTarget:self action:@selector(turnontwit:) forControlEvents:UIControlEventTouchDown];
    twitbutton.frame = CGRectMake(100.0,-70.0,64.0,64.0);
    twitbutton.hidden = true;
    if ([[TraineeManager sharedTraineeManager] returnTwitter]) {
        [twitbutton setImage:[UIImage imageNamed:@"twitterSelected.png"] forState:UIControlStateNormal];
        [twitbutton setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateHighlighted];
    } else {
        [twitbutton setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
        [twitbutton setImage:[UIImage imageNamed:@"twitterSelected.png"] forState:UIControlStateHighlighted];
    }
     */
    
    //[[ExerciseManager sharedExerciseManager] setExerciseNumber:0];
    NSLog(@"Setupworkout");
    [self setUpWorkout:0]; // Set up the initial workout
}

//========================================================================
//
// What happens when a memory warning is recieved
//
//========================================================================

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//========================================================================
//
// Updates the current weight in the ExerciseObject when the weight picker
// is changed by the user.
//
//========================================================================

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ActualWeight.text = [pickerData objectAtIndex:row];
    [[[TraineeManager sharedTraineeManager] returnCurrentExercise] setCurrentWeight:[[pickerData objectAtIndex:row] floatValue]];
}



 //========================================================================
 //
 // Initialize the workout by setting up the name, reps, etc.
 //
 //========================================================================

-(void) setUpWorkout:(NSInteger)currentExercise {
    /*
     Set up Workout HERE.  We need to set up the last reps (if no record of them, need to set up default reps.  Then set up the last weight (if no record of last weight, set up default weight).  Assign the exercise name to the lable.  Determine suggested reps and weight.
     */
    
    // Set up Picker
    NSArray *array = [[NSArray alloc] initWithObjects:@"0.0", @"0.5", @"1.0", @"1.5", @"2.0", @"2.5", @"3.0", @"3.5", @"4.0", @"4.5", @"5.0", @"5.5", @"6.0", @"6.5", @"7.0", @"7.5", @"8.0", @"8.5", @"9.0", @"9.5", @"10.0", @"10.5", @"11.0", @"11.5", @"12.0", @"12.5", @"13.0", @"13.5", @"14.0", @"14.5", @"15.0", @"15.5", @"16.0", @"16.5", @"17.0", @"17.5", @"18.0", @"18.5", @"19.0", @"19.5", @"20.0", @"20.5", @"21.0", @"21.5", @"22.0", @"22.5", @"23.0", @"23.5", @"24.0", @"24.5", @"25.0", @"25.5", @"26.0", @"26.5", @"27.0", @"27.5", @"28.0", @"28.5", @"29.0", @"29.5", @"30.0", @"30.5", @"31.0", @"31.5", @"32.0", @"32.5", @"33.0", @"33.5", @"34.0", @"34.5", @"35.0", @"35.5", @"36.0", @"36.5", @"37.0", @"37.5", @"38.0", @"38.5", @"39.0", @"39.5", @"40.0", @"40.5", @"41.0", @"41.5", @"42.0", @"42.5", @"43.0", @"43.5", @"44.0", @"44.5", @"45.0", @"45.5", @"46.0", @"46.5", @"47.0", @"47.5", @"48.0", @"48.5", @"49.0", @"49.5", @"50.0", @"50.5", @"51.0", @"51.5", @"52.0", @"52.5", @"53.0", @"53.5", @"54.0", @"54.5", @"55.0", @"55.5", @"56.0", @"56.5", @"57.0", @"57.5", @"58.0", @"58.5", @"59.0", @"59.5", @"60.0", @"60.5", @"61.0", @"61.5", @"62.0", @"62.5", @"63.0", @"63.5", @"64.0", @"64.5", @"65.0", @"65.5", @"66.0", @"66.5", @"67.0", @"67.5", @"68.0", @"68.5", @"69.0", @"69.5", @"70.0", @"70.5", @"71.0", @"71.5", @"72.0", @"72.5", @"73.0", @"73.5", @"74.0", @"74.5", @"75.0", @"75.5", @"76.0", @"76.5", @"77.0", @"77.5", @"78.0", @"78.5", @"79.0", @"79.5", @"80.0", @"80.5", @"81.0", @"81.5", @"82.0", @"82.5", @"83.0", @"83.5", @"84.0", @"84.5", @"85.0", @"85.5", @"86.0", @"86.5", @"87.0", @"87.5", @"88.0", @"88.5", @"89.0", @"89.5", @"90.0", @"90.5", @"91.0", @"91.5", @"92.0", @"92.5", @"93.0", @"93.5", @"94.0", @"94.5", @"95.0", @"95.5", @"96.0", @"96.5", @"97.0", @"97.5", @"98.0", @"98.5", @"99.0", @"99.5", @"100.0", @"100.5", @"101.0", @"101.5", @"102.0", @"102.5", @"103.0", @"103.5", @"104.0", @"104.5", @"105.0", @"105.5", @"106.0", @"106.5", @"107.0", @"107.5", @"108.0", @"108.5", @"109.0", @"109.5", @"110.0", @"110.5", @"111.0", @"111.5", @"112.0", @"112.5", @"113.0", @"113.5", @"114.0", @"114.5", @"115.0", @"115.5", @"116.0", @"116.5", @"117.0", @"117.5", @"118.0", @"118.5", @"119.0", @"119.5", @"120.0", @"120.5", @"121.0", @"121.5", @"122.0", @"122.5", @"123.0", @"123.5", @"124.0", @"124.5", @"125.0", @"125.5", @"126.0", @"126.5", @"127.0", @"127.5", @"128.0", @"128.5", @"129.0", @"129.5", @"130.0", @"130.5", @"131.0", @"131.5", @"132.0", @"132.5", @"133.0", @"133.5", @"134.0", @"134.5", @"135.0", @"135.5", @"136.0", @"136.5", @"137.0", @"137.5", @"138.0", @"138.5", @"139.0", @"139.5", @"140.0", @"140.5", @"141.0", @"141.5", @"142.0", @"142.5", @"143.0", @"143.5", @"144.0", @"144.5", @"145.0", @"145.5", @"146.0", @"146.5", @"147.0", @"147.5", @"148.0", @"148.5", @"149.0", @"149.5", @"150.0", @"150.5", @"151.0", @"151.5", @"152.0", @"152.5", @"153.0", @"153.5", @"154.0", @"154.5", @"155.0", @"155.5", @"156.0", @"156.5", @"157.0", @"157.5", @"158.0", @"158.5", @"159.0", @"159.5", @"160.0", @"160.5", @"161.0", @"161.5", @"162.0", @"162.5", @"163.0", @"163.5", @"164.0", @"164.5", @"165.0", @"165.5", @"166.0", @"166.5", @"167.0", @"167.5", @"168.0", @"168.5", @"169.0", @"169.5", @"170.0", @"170.5", @"171.0", @"171.5", @"172.0", @"172.5", @"173.0", @"173.5", @"174.0", @"174.5", @"175.0", @"175.5", @"176.0", @"176.5", @"177.0", @"177.5", @"178.0", @"178.5", @"179.0", @"179.5", @"180.0", @"180.5", @"181.0", @"181.5", @"182.0", @"182.5", @"183.0", @"183.5", @"184.0", @"184.5", @"185.0", @"185.5", @"186.0", @"186.5", @"187.0", @"187.5", @"188.0", @"188.5", @"189.0", @"189.5", @"190.0", @"190.5", @"191.0", @"191.5", @"192.0", @"192.5", @"193.0", @"193.5", @"194.0", @"194.5", @"195.0", @"195.5", @"196.0", @"196.5", @"197.0", @"197.5", @"198.0", @"198.5", @"199.0", @"199.5", @"200.0", @"200.5", @"201.0", @"201.5", @"202.0", @"202.5", @"203.0", @"203.5", @"204.0", @"204.5", @"205.0", @"205.5", @"206.0", @"206.5", @"207.0", @"207.5", @"208.0", @"208.5", @"209.0", @"209.5", @"210.0", @"210.5", @"211.0", @"211.5", @"212.0", @"212.5", @"213.0", @"213.5", @"214.0", @"214.5", @"215.0", @"215.5", @"216.0", @"216.5", @"217.0", @"217.5", @"218.0", @"218.5", @"219.0", @"219.5", @"220.0", @"220.5", @"221.0", @"221.5", @"222.0", @"222.5", @"223.0", @"223.5", @"224.0", @"224.5", @"225.0", @"225.5", @"226.0", @"226.5", @"227.0", @"227.5", @"228.0", @"228.5", @"229.0", @"229.5", @"230.0", @"230.5", @"231.0", @"231.5", @"232.0", @"232.5", @"233.0", @"233.5", @"234.0", @"234.5", @"235.0", @"235.5", @"236.0", @"236.5", @"237.0", @"237.5", @"238.0", @"238.5", @"239.0", @"239.5", @"240.0", @"240.5", @"241.0", @"241.5", @"242.0", @"242.5", @"243.0", @"243.5", @"244.0", @"244.5", @"245.0", @"245.5", @"246.0", @"246.5", @"247.0", @"247.5", @"248.0", @"248.5", @"249.0", @"249.5", nil];
    self->pickerData = array;
    
    // Set up the rest of the UI (reusable code)
    NSLog(@"setUI");
    [self setUI];
    NSLog(@"Done with setting up the new workout");
}

//========================================================================
//
// Determine the suggested reps and weight
//
//========================================================================
#warning Need to check the algorithm and make sure it is solid

-(void) setUpSuggestedInfo:(ExerciseObject*)tmpExercise2 {
    // Get Suggested reps/weight
    // Set Up Suggested Reps and Weight
    
    if ([tmpExercise2 returnLastReps]) {
        // There were last reps so we have a previous workout.
        float lastWeightUsed = [tmpExercise2 returnLastWeight];
        
        if ([tmpExercise2 returnLastReps] < 10) {
            // Increase the number of reps
            SuggestedReps.text = [NSString stringWithFormat:@"%d", ([tmpExercise2 returnLastReps] + 2)];
            SuggestedWeight.text = [NSString stringWithFormat:@"%1.1f", lastWeightUsed];
        } else {
            // Increase the weight and adjust the reps
            //NSInteger totalVolume = [tmpExercise returnCurrentVolume];
            if (lastWeightUsed < 20) {
                // Increase by 2.5 for under 20
                lastWeightUsed = lastWeightUsed + 2.5;
            } else {
                // Increase by 5.0 for over 20
                lastWeightUsed = lastWeightUsed + 5.0;
            }
            
            // Adjust reps
            //if ((lastWeightUsed * 10) < totalVolume) {
            //    lastWeightUsed = lastWeightUsed + 5.0;
            //}
            
            // Set the UILabels
            SuggestedReps.text = @"10";
            SuggestedWeight.text = [NSString stringWithFormat:@"%1.1f", lastWeightUsed];
        }
    } else {
        // No previous reps, use default weight and reps.
        SuggestedReps.text = [NSString stringWithFormat:@"%d", [tmpExercise2 returnDefReps]];
        SuggestedWeight.text = [NSString stringWithFormat:@"%1.1f", [tmpExercise2 returnDefWeight]];
    }
}

//====================================================================
//
// Save the exercise, move to next exercise, end or reset UI
//
//====================================================================

-(IBAction)nextExercise:(id)sender {
    // Save the exercise
    NSLog(@"Save Exercise");
    [[TraineeManager sharedTraineeManager] saveExercise];
    
    NSLog(@"Done Saving");
    // Move to next exercise
    BOOL nxtEx = [[TraineeManager sharedTraineeManager] moveToNextExercise];
    
    // If the moveToNextExercise returns false, move to the next view
    if (!nxtEx) 
        [self performSegueWithIdentifier:@"finishWorkout" sender:@""]; // Here I can send information to the new view
        
    // Reset the UI with the new exercise
    [self setUI]; 
    
}

-(void) setUI {
    
    bool lastReps = [[TraineeManager sharedTraineeManager] checkLastRepsWeight];

    if (lastReps) {
        NSLog(@"No previous exercise");
    }

    // Grab the current object for more readable code    
    ExerciseObject *currentExercise = [[TraineeManager sharedTraineeManager] returnCurrentExercise];
    
    // Set the Name of the Exercise
    ExerciseName.text = [NSString stringWithString:[currentExercise returnName]];
    
    // Reset current reps and weight
    ActualReps.text = @"0";
    ActualWeight.text = @"0";
    
    // Set Last reps and weight
    if ([currentExercise returnLastReps])
        LastReps.text = [NSString stringWithFormat:@"%d", [currentExercise returnLastReps]];
    else
        LastReps.text = @"**";
    
    if ([currentExercise returnLastWeight])
        LastWeight.text = [NSString stringWithFormat:@"%1.1f", [currentExercise returnLastWeight]];
    else
        LastWeight.text = @"**";
    LastReps.text = [NSString stringWithFormat:@"%d",[currentExercise returnLastReps]];
    LastWeight.text = [NSString stringWithFormat:@"%.01f", [currentExercise returnLastWeight]];
    
    // Set goal reps and weight
    [self setUpSuggestedInfo:currentExercise];
        
    // Reset the picker back to 0
    [weightPicker selectRow:0 inComponent:0 animated:YES];
    
    // Set the set number
    NSInteger currentSet = [currentExercise returnCurrentSet];
    [setNumber setImage:[UIImage imageNamed:[NSString stringWithFormat:@"set%d.png", currentSet]]];
    
}

//====================================================================
//
// Set up weight picker characteristics
//
//====================================================================

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    label.font = [UIFont fontWithName:@"Thonburi" size:26];
    label.text = [NSString stringWithString:[pickerData objectAtIndex:row]];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}


@end
