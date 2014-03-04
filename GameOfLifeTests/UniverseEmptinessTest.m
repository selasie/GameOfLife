//
//  UniverseEmptinessTest.m
//  GameOfLife
//
//  Created by Dmitry Volkov on 2/16/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Universe.h"

@interface UniverseEmptinessTest : XCTestCase
{
    Universe* _universe;
}

@end

@implementation UniverseEmptinessTest

- (void)setUp
{
    [super setUp];
    _universe = [[Universe alloc] initWithSize:CGSizeMake(10, 10)];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (BOOL) universeIsEmpty
{
    BOOL initalStateIsEmpty = NO;
    CGSize size = _universe.size;
    for(int i = 0;i<size.width; i++)
    {
        for (int j = 0; j<size.height; j++)
        {
            initalStateIsEmpty |= [_universe cellStateAtPoint:CGPointMake(i, j)].isAlive;
        }
    }
    return initalStateIsEmpty;
}

- (void)testEmptiness
{
    BOOL initalStateIsEmpty = [self universeIsEmpty];
    XCTAssertFalse(initalStateIsEmpty, @"non-empty initial state");
}

- (void) testEmptinessOnFirstSimulation
{
    [_universe simulationStep];
    [self testEmptiness];
}

- (void) testNonEmptiness
{
    [_universe randomizeUniverse];
    XCTAssertFalse(![self universeIsEmpty], @"empty state after randomization");
}

@end
