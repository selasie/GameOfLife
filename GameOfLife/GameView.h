//
//  GameView.h
//  GameOfLife
//
//  Created by Dmitry Volkov on 2/16/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Universe.h"

@class GameView;

@protocol GameViewDelegate <NSObject>

@optional
- (void) gameView:(GameView*) gameView didTouchGridCellAtPoint:(CGPoint) point;

@end

@interface GameView : UIView

@property(nonatomic, weak) id<GameViewDelegate> delegate;
- (void) updateWithUniverse:(Universe*) universe;

@end
