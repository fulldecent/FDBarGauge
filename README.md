FDBarGuage
==========

[![CI Status](http://img.shields.io/travis/fulldecent/FDBarGuage.svg?style=flat)](https://travis-ci.org/fulldecent/FDBarGuage)
[![Version](https://img.shields.io/cocoapods/v/FDBarGuage.svg?style=flat)](http://cocoadocs.org/docsets/FDBarGuage)
[![License](https://img.shields.io/cocoapods/l/FDBarGuage.svg?style=flat)](http://cocoadocs.org/docsets/FDBarGuage)
[![Platform](https://img.shields.io/cocoapods/p/FDBarGuage.svg?style=flat)](http://cocoadocs.org/docsets/FDBarGuage)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![Screenshot](https://raw.github.com/ChiefPilot/F3BarGauge/master/F3BarGauge.png "Screenshot of Component Demo App")

The successor to F3BarGuage


Background
----------
This control is intended to replicate/simulate the level indicator
on an audio mixing board.   These indicators are usually
segmented/stacked LEDs, with several colors to indicate thresholds.
This control replicates that look, using Quartz drawing primitives,
and auto-adjusts to horizontal or vertical orientation. Additionally,
the colors, number of bars, peak hold, and other items are easily
customized.


Usage
-----
Adding this control to your XCode project is straightforward :
1.  Add the F3BarGauge.h and F3BarGauge.m files to your project
2.  Add a new blank subview to the nib, sized and positioned to
    match what the bar gauge should look like.
3.  In the properties inspector for this subview, change the
    class to "F3BarGauge"
4.  Add an outlet to represent the bar gauge
5.  Update your code to set the value property as appropriate.

For more information have a look at the demo code, which
has multiple examples including a version that customizes the
with an LCD-style appearance.


Installation
------------

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build FDBarGuage 0.1.0+.

To integrate FDBarGuage into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'FDBarGuage', '~> 0.1'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate FDBarGuage into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "fulldecent/FDBarGuage" ~> 0.1
```

Run `carthage update` to build the framework and drag the built `FDBarGuage.framework` into your Xcode project.



License
-------
Copyright (c) 2016 William Entriken
Copyright (c) 2011-2014 by Brad Benson
This is released under the MIT licence. Please see the file COPYING for details.
