//
//  ViewController.h
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/23/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKView.h"

@interface ViewController : UIViewController <KKViewDelegate>

@property IBOutlet KKView* kontoView;

@end
