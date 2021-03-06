//
//  Weapon.m
//  TiltShooting
//
//  Created by yan zhuang on 12-10-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"
#import "CCBReader.h"

@implementation Weapon

@synthesize panel;
@synthesize ammo;
@synthesize currentAmmo;
@synthesize clipAmmo;
@synthesize currentClipAmmo;
@synthesize aim;
@synthesize radius;

-(id)initWithType:(int)type{

    //init the properties based on type
    
    switch (type) {
        case 1://handgun
            NSLog(@"init weapon type 1 info");
            panel=[CCBReader nodeGraphFromFile:@"WeaponPanelDE.ccbi" owner:self];
            aim=[CCBReader nodeGraphFromFile:@"AimCross1.ccbi"];
            break;
            
        case 2://ak104
            NSLog(@"init weapon type 2 info");
            panel=[CCBReader nodeGraphFromFile:@"WeaponPanelM4A1b.ccbi" owner:self];
            aim=[CCBReader nodeGraphFromFile:@"AimCross2.ccbi"];
            break;
        case 3://peacekeeper
            NSLog(@"init weapon type 3 info");
            panel=[CCBReader nodeGraphFromFile:@"WeaponPanelPK.ccbi" owner:self];
            aim=[CCBReader nodeGraphFromFile:@"AimCross3.ccbi"];
            break;
        default:
            break;
    }
    //currentAmmo=ammo;
    //currentClipAmmo=currentAmmo;
    self.type=type;
    return self;
}
-(void)changeCurrentClipAmmo:(int)value{
    [currentClipAmmo setString:[NSString stringWithFormat:@"%d",value]];
    
}
-(void)changeClipAmmo:(int)value{
    [clipAmmo setString:[NSString stringWithFormat:@"%d",value]];
    
}
-(void)changeCurrentAmmo:(int)value{
    [currentAmmo setString:[NSString stringWithFormat:@"%d",value]];
    
}

@end
