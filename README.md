# SwiftCustomControl

A quick tutorial on creating and using an AppKit custom control

This may apply to UIKit, at least in part, but I make no claim that it does.

## Introduction

This all started with a Mac App I was playing with.
It had a real purpose but I was also using it to learn more about Views and controls and stuff like that.
I wanted to dig a little deeper into multiple windows and views, horizontal and vertical stacks, scroll views and tables,
stuff like that.

At some point in the development I had five TabView panes that were similar but showed different parts of the document
I was working with.
Each had a selected set of settings at the top, arranged in a loose grid.
For each setting I wanted a small image, an icon really, representing the "state" of that setting, with three or four
possible states.
The value of the setting, a string, would also be shown.
So what I wanted is very similar to an Image and Text Table Cell View.
But I found that I couldn't use that outside of a table ...  bummer ...

So I thought that would be a great opportunity to build my own custom control to have and reuse.
I figured I would need thirty or so of these so reusability would be a "Good Thing"™

It turns out it's easy to do but finding out *HOW* is the hard part!

#### Disclaimer

While putting this project together I have made many assumptions based on observation of what works and what didn't.
Some or all of these assumptions may very well be wrong.
If you know that something I say below is wrong I would appreciate hearing about it.
There is no warranty expressed or implied that anything I say is truth,
some may be simply an Alternate Reality ...

### UIKit vs AppKit

When I searched for "custom control" (several different forms of search and many different places) I found
lots of references to UIKit.
Most were much more advanced than what I was looking for and those that I did look at didn't seem to apply to AppKit.
As I was building a Mac app I had to use AppKit.

I put some help queries up in a couple of places but really didn't get much response.
Did it mean that no one was doing it or that it couldn't be done or, as I suspect, I just didn't catch
the interest of someone who would spend the time to lay it out for me.

As it turns out it's pretty easy but getting there was hard.
It was like a key in a lock, unless all the bumps are in the right place and of the right size the lock doesn't open.

I ended up submitting a Technical Support Incident to Apple for help.
I did get some great help.
The person assigned to my ticket took my sample code and tweaked it to make it work
then took one of the Objective C examples and rewrote it in Swift and sent it to me.
Between the two samples I had I was able to build a new test in Swift and this
project is the result.

I hope this gets to someone that finds it useful.

## Framework or No Framework, That Is The Question

A couple of the threads that I found during my search seemed to indicate that your custom control had
to be built within a Framework.
And my first attempt, [well, my second considering how messed up my really first attempt ended up,]
was written in a Framework.
Both examples that I got back from Apple were built within Frameworks too.
But I didn't see anything obvious that appeared to require a Framework so I tried one, this one,
without the Framework.
Seems to work OK for me.

So, at least at the XCode 8 level, a Framework is not required for this to work.

There may be reasons to put your custom controls into a Framework but that should be a structure decision
made because of other reasons than that it is required to make it work.
This may very well be a change from earlier versions of XCode, I don't know, but as you can see
here, a Framework is not required.

## Discussion

A quick note on my coding style here.
I have included the qualifier `self` in several places where it is not necessary.
That is on purpose.
What I am trying to emphasize is that our custom class is the main view now of our custom control;
that NSView that you saw in Interface Builder is no longer in play, we are in charge now.

What follows is a stream of conciousness dump of what goes into creating a custom control.
There's not a lot here because that turns out to be not much to it
but I can tell you that if you miss a bit or get it just a little wrong you won't have
anything and you won't know why.

1. Create an XIB

1. Create a subclass of NSView.
They probably should have the same base name but it's not strictly required.
In this example they do and we take advantage of that fact.
Assuming you want to see the view in Interface Builder be sure to add `@IBDesignable` to the class definition.

1. In the XIB set `File's Owner` to the class you just created.

1. The top-level view in the XIB must remain an `NSView`

1. In your XIB create how you want the control to look.
This is "Normal" XIB stuff, nothing unusual.
The size of the top-level view should be what size and shape it will be in your application.
This is not strictly necessary but it will help make it visible within Interface Builder.
More on this later.

1. Add any Actions and Outlets that you may need for you control to function.
Be sure to include an Outlet connecting the top-level NSView to the File's Owner.
It's labelled `topView` here.

1. Create the initializer `required override init?(coder: coder)` in your class.
This is where the magic happens.

1. Within this initializer you can see the sample code.
Here is what it is doing ...

    * Create a `NSNib` from the name of the class. Look in the Bundle that belongs to that class.
Our class will "own" that `NSNib` instance.
    * `instantiate` that NIB. The important thing that happens here is that all the IBOutlet and IBAction references are
established.
I think `awakeFromNIB` is also called at that time.
It's interesting to note that this will be the *second* time `awakeFromNIB` is called, the first time no bindings were established.
I originally thought that was a bug but I believe it is because that at that time there was no NIB or, perhaps, an empty NIB in control.
    * Recreate all of the existing contraints by copying them from the old view replacing the old view where it appears with our new view.
We'll use them in a bit.
    * Add each of the subviews that appear under the top-level `NSView` in the XIB to ourself as subviews.
**This is a bit of magic.**
When you do this these views (in our sample there is only one but there may be multiple if that's what you need) are detached
from the NSView in the XIB and reattached to the new custom view.
They are now within our view hierarchy.
They have also lost any constraints that related to the old top view.
We fix that next.
    * Re-establish the constraints in the views.
This took me a while to figure out why my view wasn't laid out correctly, they had lost all of their constraints so we have to put them back.
    * You're Done

Your custom class should now appear in Interface Builder and in your app.
