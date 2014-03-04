//
//  Universe.m
//  GameOfLife
//
//  Created by Dmitry Volkov on 2/16/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import "Universe.h"
#define NEIGHBOURS_TO_VITALIZE 3
#define NEIGHBOURS_TO_LIVE_MIN 2
#define NEIGHBOURS_TO_LIVE_MAX 3

@interface Universe ()
{
    CellState* _cellsArray;
    CellState* _currentCellsGeneration;
    CellState* _nextCellsGeneration;
    CGSize _gridSize;
}

@end

@implementation Universe

@synthesize size = _gridSize;

- (void) dealloc
{
    free(_cellsArray);
}

- (instancetype) initWithSize:(CGSize)size
{
    self = [super init];
    _gridSize = size;
    _currentCellsGeneration = calloc(size.width * size.height, sizeof(CellState));
    _nextCellsGeneration = calloc(size.width * size.height, sizeof(CellState));
    _cellsArray = _currentCellsGeneration;
    return self;
}

- (size_t) offsetForPoint:(CGPoint) point
{
    CGPoint wrappedPoint = point;
    if(point.x < 0)
    {
        wrappedPoint.x = _gridSize.width + point.x;
    }
    else if(point.x >= _gridSize.width)
    {
        wrappedPoint.x = (NSInteger)point.x % (NSInteger)_gridSize.width;
    }
        
    if(point.y < 0)
    {
        wrappedPoint.y = _gridSize.height + point.y;
    }
    else if(point.y >= _gridSize.height)
    {
        wrappedPoint.y = (NSInteger)point.y % (NSInteger)_gridSize.height;
    }
    size_t offset = wrappedPoint.y * _gridSize.width + wrappedPoint.x;
    return offset;
}


- (CellState) cellStateAtPoint:(CGPoint)point
{
    CellState state = _cellsArray[[self offsetForPoint:point]];
    return state;
}

- (void) updateCellStateAtPoint:(CGPoint) point withState:(CellState) state;
{
    _cellsArray[[self offsetForPoint:point]] = state;
}

- (CellState*) universeState NS_RETURNS_INNER_POINTER
{
    return _cellsArray;
}

- (BOOL) shouldVitalizeCellAtPoint:(CGPoint) point
{
    CellState currentCellState = [self cellStateAtPoint:point];
    NSInteger aliveCellsCount = 0;
    for(int x = -1 ; x <= 1; x++)
    {
        for(int y = -1; y <= 1; y++)
        {
            if(x==0 && y==0)
            {
                continue;
            }
            CGPoint currentPoint = CGPointMake(point.x + x, point.y + y);
            CellState state = [self cellStateAtPoint:currentPoint];
            if(state.isAlive)
            {
                aliveCellsCount++;
            }
        }
    }
    //current cell is empty and has enough neighbours to become alive
    if(!currentCellState.isAlive && aliveCellsCount==NEIGHBOURS_TO_VITALIZE)
    {
        return YES;
    }
    //current cell is alive and has enough neighbours to survive
    else if(currentCellState.isAlive && (aliveCellsCount>=NEIGHBOURS_TO_LIVE_MIN && aliveCellsCount<=NEIGHBOURS_TO_LIVE_MAX))
    {
        return YES;
    }
    //either cell was empty and had no neighbours, or it had too many or to few neighbour cells to survive
    else
    {
        return NO;
    }
    return NO;
    
}


- (void) simulationStep
{
    for(int x = 0; x<_gridSize.width; x++)
    {
        for (int y = 0; y<_gridSize.height; y++)
        {
            CGPoint point = CGPointMake(x, y);
            size_t offset = [self offsetForPoint:point];
            BOOL shouldVitalize = [self shouldVitalizeCellAtPoint:point];
            CellState state = [self cellStateAtPoint:point];
            state.isAlive = shouldVitalize;
            if(_cellsArray==_currentCellsGeneration)
            {
                _nextCellsGeneration[offset] = state;
            }
            else
            {
                _currentCellsGeneration[offset] = state;
            }
        }
    }
    if(_cellsArray==_currentCellsGeneration)
    {
        _cellsArray = _nextCellsGeneration;
    }
    else
    {
        _cellsArray = _currentCellsGeneration;
    }
}

- (void) randomizeUniverse
{
    for(int i = 0; i< _gridSize.width * _gridSize.height; i++)
    {
        BOOL isAlive =  ABS(arc4random()) % 2;
        CellState state = _cellsArray[i];
        state.isAlive = isAlive;
        _cellsArray[i] = state;
    }
}

- (void) reset
{
    memset(_currentCellsGeneration, 0, _gridSize.width * _gridSize.height * sizeof(CellState));
    memset(_nextCellsGeneration, 0, _gridSize.width * _gridSize.height * sizeof(CellState));
}

- (NSString*) debugDescription
{
    NSMutableString* str = [NSMutableString string];
    for(int i = 0; i< _gridSize.width * _gridSize.height; i++)
    {
        [str appendFormat:@"%d", _cellsArray[i].isAlive];
        if(i!=0 && (i % (NSInteger)_gridSize.width)==0)
        {
            [str appendString:@"\n"];
        }
    }
    return str;
}

@end
