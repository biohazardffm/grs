//
//  AppDelegate.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "MyUniversalAccessHelper.h"
#import "MyGrid.h"

#import "SDOpenAtLogin.h"

#import "SDWelcomeWindowController.h"

@implementation AppDelegate

+ (void) initialize {
    if (self == [AppDelegate self]) {
        NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    }
}

- (void) loadStatusItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setImage:[NSImage imageNamed:@"statusitem"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"statusitem_pressed"]];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusBarMenu];
}

- (void) awakeFromNib {
    [self loadStatusItem];
}

- (IBAction) changeNumberOfGridColumns:(id)sender {
    NSInteger oldNum = [MyGrid width];
    NSInteger newNum = [[sender title] integerValue];
    
    if (oldNum != newNum)
        [MyGrid setWidth:newNum];
}

- (IBAction) toggleOpensAtLogin:(id)sender {
	NSInteger changingToState = ![sender state];
	[SDOpenAtLogin setOpensAtLogin: changingToState];
}

- (IBAction) toggleUseWindowMargins:(id)sender {
	NSInteger changingToState = ![sender state];
	[MyGrid setUsesWindowMargins: changingToState];
}

- (void) menuNeedsUpdate:(NSMenu *)menu {
    if (menu == self.statusBarMenu) {
		[[menu itemWithTitle:@"Use Window Margins"] setState:([MyGrid usesWindowMargins] ? NSOnState : NSOffState)];
		[[menu itemWithTitle:@"Open at Login"] setState:([SDOpenAtLogin opensAtLogin] ? NSOnState : NSOffState)];
    }
    else {
        for (NSMenuItem* item in [menu itemArray]) {
            [item setState:NSOffState];
        }
        
        NSInteger num = [MyGrid width];
        NSString* numString = [NSString stringWithFormat:@"%ld", num];
        
        [[menu itemWithTitle:numString] setState:NSOnState];
    }
}

- (IBAction) reallyShowAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) showHotKeysWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.myPrefsWindowController == nil)
        self.myPrefsWindowController = [[MyPrefsWindowController alloc] init];
    
    [self.myPrefsWindowController showWindow:self];
}

- (void) applicationWillFinishLaunching:(NSNotification *)notification {
    self.myActor = [[MyActor alloc] init];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.myActor bindMyKeys];
    
    [MyUniversalAccessHelper complainIfNeeded];
    
    [SDWelcomeWindowController showInstructionsWindowFirstTimeOnly];
}

@end
