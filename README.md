# FDBarGuage
The successor to F3BarGuage

![Screenshot](https://raw.github.com/ChiefPilot/F3BarGauge/master/F3BarGauge.png "Screenshot of Component Demo App")


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

License
-------
Copyright (c) 2016 William Entriken
Copyright (c) 2011-2014 by Brad Benson
This is released under the MIT licence. Please see the file COPYING for details.
