//
//  GameView.m
//  GameOfLife
//
//  Created by Dmitry Volkov on 2/16/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import "GameView.h"

@interface GameView ()
{
    Universe* _universe;
    CGSize _gridSize;

}

@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) updateWithUniverse:(Universe*) universe
{
    _universe = universe;
    _gridSize = universe.size;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGridInContext:context];
    CGContextStrokeRect(context, rect);
    [self drawUniverseCellsInContext:context];
    
}

- (void) drawUniverseCellsInContext:(CGContextRef) context
{
    CGRect rect = CGContextGetClipBoundingBox(context);
    float widthStride = rect.size.width / _gridSize.width;
    float heightStride = rect.size.height / _gridSize.height;
    
    for(int x = 0; x < _gridSize.width; x++)
    {
        for(int y = 0; y< _gridSize.height; y++)
        {
            CellState state = [_universe cellStateAtPoint:CGPointMake(x, y)];
            if(state.isAlive)
            {
                CGPoint topLeft = CGPointMake(x * widthStride, y * heightStride);
                CGSize size = CGSizeMake(widthStride, heightStride);
                CGContextFillRect(context, (CGRect){topLeft, size});
            }
        }
    }
}

- (void) drawGridInContext:(CGContextRef) context
{
    CGRect rect = CGContextGetClipBoundingBox(context);
    float widthStride = rect.size.width / _gridSize.width;
    float heightStride = rect.size.height / _gridSize.height;
    
    for(int i = 0;i<_gridSize.width; i++)
    {
        CGFloat y0 = 0;
        CGFloat y1 = rect.size.height;
        CGFloat x = i * widthStride;
        CGContextMoveToPoint(context, x, y0);
        CGContextAddLineToPoint(context, x, y1);
    }
    for(int i = 0; i<_gridSize.height; i++)
    {
        CGFloat x0 = 0;
        CGFloat x1 = rect.size.width;
        CGFloat y = i * heightStride;
        CGContextMoveToPoint(context, x0, y);
        CGContextAddLineToPoint(context, x1, y);
    }
    CGContextStrokePath(context);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint currentGridPoint = [self gridPointFromViewPoint:point];
    
    if([self.delegate respondsToSelector:@selector(gameView:didTouchGridCellAtPoint:)])
    {
        [self.delegate gameView:self didTouchGridCellAtPoint:currentGridPoint];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint currentGridPoint = [self gridPointFromViewPoint:point];
    
    if(CGPointEqualToPoint(currentGridPoint, [self gridPointFromViewPoint:previousPoint]))
    {
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(gameView:didTouchGridCellAtPoint:)])
    {
        [self.delegate gameView:self didTouchGridCellAtPoint:currentGridPoint];
    }
}

- (CGPoint) gridPointFromViewPoint:(CGPoint) point
{
    CGPoint gridPoint = CGPointZero;
    float widthStride = self.frame.size.width / _gridSize.width;
    float heightStride = self.frame.size.height / _gridSize.height;
    gridPoint.x = floorf(point.x / widthStride);
    gridPoint.y = floorf(point.y / heightStride);
    return gridPoint;
}


@end
