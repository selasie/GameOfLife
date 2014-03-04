//
//  ViewController.m
//  GameOfLife
//
//  Created by Dmitry Volkov on 2/16/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import "ViewController.h"
#import "Universe.h"
#import "GameView.h"


@interface ViewController ()<GameViewDelegate>
{
    Universe* _universe;
    IBOutlet GameView* _gameView;
    NSTimer* _simulationTimer;
}

@end

@implementation ViewController

- (GameView*) gameView
{
    return _gameView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _universe = [[Universe alloc] initWithSize:CGSizeMake(100, 100)];
    [[self gameView] updateWithUniverse:_universe];
    [self gameView].delegate = self;

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) randomizeUniverse
{
    [_universe randomizeUniverse];
    [[self gameView] updateWithUniverse:_universe];
}

- (IBAction) nextStep
{
    [_universe simulationStep];
    [[self gameView] updateWithUniverse:_universe];
}

- (IBAction) startSimulation
{
    [self stopSimulation];
    _simulationTimer = [NSTimer scheduledTimerWithTimeInterval:1./10. target:self selector:@selector(nextStep) userInfo:nil repeats:YES];
}

- (IBAction) stopSimulation
{
    [_simulationTimer invalidate];
    _simulationTimer = nil;
}

- (IBAction)reset
{
    
    [_universe reset];
    [[self gameView] updateWithUniverse:_universe];
}

#pragma mark - GameView delegate

- (void) gameView:(GameView *)gameView didTouchGridCellAtPoint:(CGPoint)point
{
    CellState state = [_universe cellStateAtPoint:point];
    state.isAlive = !state.isAlive;
    [_universe updateCellStateAtPoint:point withState:state];
    [[self gameView] updateWithUniverse:_universe];
}

@end
