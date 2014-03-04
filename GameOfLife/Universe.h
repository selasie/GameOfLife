//
//  Universe.h
//  GameOfLife
//
//  Created by Dmitry Volkov on 2/16/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{

    BOOL isAlive:sizeof(BOOL);
    
} CellState;

@interface Universe : NSObject

@property(nonatomic, readonly) CGSize size;

- (instancetype) initWithSize:(CGSize) size;

- (CellState) cellStateAtPoint:(CGPoint) point;
- (void) updateCellStateAtPoint:(CGPoint) point withState:(CellState) state;

- (void) simulationStep;
- (void) randomizeUniverse;
- (void) reset;


@end
