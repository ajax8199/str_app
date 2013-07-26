//
//  MOOTAMasterViewController.m
//  moota5
//
//  Created by Ajax on 5/22/13.
//  Copyright (c) 2013 eleganceapplications. All rights reserved.
//

#import "MOOTAMasterViewController.h"
#import "TraineeManager.h"
#import "ExerciseObject.h"

@interface MOOTAMasterViewController ()

@end

@implementation MOOTAMasterViewController
@synthesize managedObjectContext;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*
    UISegmentedControl *customeSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake( 206.0f, 7.0f , 110.0f, 30.0f)];
    [self.view addSubview:customeSegment];
    NSArray *itemArray = [NSArray arrayWithObjects: @"U", @"L", @"C", @"F", nil];
    //UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake( 206.0f, 7.0f , 110.0f, 30.0f)];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(0, 375, 320, 85);
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    segmentedControl.selectedSegmentIndex = 1;
    [segmentedControl setImage:[UIImage imageNamed:@"grey.png"] forSegmentAtIndex:0];
    [segmentedControl setImage:[UIImage imageNamed:@"grey.png"] forSegmentAtIndex:2];
    [segmentedControl setImage:[UIImage imageNamed:@"blue.png"] forSegmentAtIndex:1];
    [segmentedControl setImage:[UIImage imageNamed:@"blue.png"] forSegmentAtIndex:3];
    [self.view addSubview:segmentedControl]; 
     */
    
    
}

-(IBAction)getaworkoutUpper:(id)sender {
    [[TraineeManager sharedTraineeManager] generateWorkout:1];
}
-(IBAction)getaworkoutLower:(id)sender { [[TraineeManager sharedTraineeManager] generateWorkout:2];}
-(IBAction)getaworkoutCore:(id)sender { [[TraineeManager sharedTraineeManager] generateWorkout:3];}
-(IBAction)getaworkoutFull:(id)sender { [[TraineeManager sharedTraineeManager] generateWorkout:3];}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
