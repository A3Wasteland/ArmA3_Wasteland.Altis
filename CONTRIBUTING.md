###Contributing to this A3Wasteland fork###
This fork of A3Wasteland is an open source project and we love to receive contributions from the community — you! There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests or writing code which can be incorporated into A3Wasteland itself.

####Why does this fork exist####
This fork exists to provide an alternate way of stats persistence that is more scalable than extDB, and iniDB, and that is easier to maintain and update due to its schemaless nature.
  
The fork maintains a main branch called *Development_main*, which closely follows the development of the the parent (official) A3Wasteland repository. The *Development_main* should not deviate feature-wise from the official A3Wasteland development.
 
The only changes that are allowed to go into the *Development_main* branch are those that are persistence related.
 
The fork also maintains a branch called *Development_main_addons*. This branch is where we put those features that are not accepted (or not being implemented) into the official A3Wasteland repository (for whatever reasons). Some examples of these features are:
 
 * Private Storage
 * Private Parking
 * Extra vehicle actions (with locking/unlocking)
 * ATMs
 * Improved admin camera
 * Water-edge glitch improvement
 * Mine-saving 
 * Improved spawn experience 
 

####Bug reports####


If you think you have found a bug in this fork of the A3Wasteland mission, first make sure that you test against [the official A3Wasteland vanilla mission](https://github.com/A3Wasteland/ArmA3_Wasteland.Altis) - If the issue exists over there, then please create the issue over there instead. Unless the issues are related to persistence, or to an addon, it's very likely that the issue exists as well in the vanilla mission.

Also, make sure to search our [issues list](https://github.com/micovery/ArmA3_Wasteland.Altis/issues) on GitHub in case a similar issue has already been opened.

It is very helpful if you can prepare a reproduction of the bug. In other words, provide a small test case (or series of steps) which we can do in order to consistently reproduce the bug. It makes it easier to find the problem and to fix it. Do not simply say "XYZ is not working", please explain how exactly is it not working (what is the expectation vs what is actually happening),  and under what circumstances. 

Provide as much information as you can. The easier it is for us to recreate your problem, the faster it is likely to be fixed.

####Addons and feature requests####

If you find yourself wishing for an addon or feature that doesn't exist in this fork of A3Wasteland, you are probably not alone. There are bound to be others out there with similar needs. Many of the addons and features in the "Development_main_addons" branch today have been added because admins and/or users saw the the need.
Open an issue on our [issues list](https://github.com/micovery/ArmA3_Wasteland.Altis/issues) on GitHub which describes the feature you would like to see, why you need it, and how it should work.

####Contributing code and documentation changes####

If you have a bugfix or new feature that you would like to contribute to this fork of A3Wasteland, please find or open an issue about it first. Talk about what you would like to do. It may be that somebody is already working on it, or that there are particular issues that you should know about before implementing the change.

We enjoy working with contributors to get their code accepted. There are many approaches to fixing a problem and it is important to find the best approach before writing too much code.

See more details below for the process of contributing code to this fork of A3Wasteland.

#### Fork and clone the repository ####

You will need to fork this repository and clone it to your local machine. See 
[github help page](https://help.github.com/articles/fork-a-repo) for help.

**Repository:** [https://github.com/micovery/ArmA3_Wasteland.Altis](https://github.com/micovery/ArmA3_Wasteland.Altisb)

#### Submitting your changes ####

Once your changes and tests are ready to submit for review:

1. Test your changes

    Load up the mission with your changes, and make sure that your feature actually works as expected, and that it does not negatively impact other areas.

2. Sign the Contributor License Agreement

    Please make sure you have signed our [Contributor License Agreement](https://www.clahub.com/agreements/micovery/ArmA3_Wasteland.Altis). We are not asking you to assign copyright to us, but to give us the right to distribute your code without restriction. We ask this of all contributors in order to assure our users of the origin and continuing existence of the code. You only need to sign the CLA once.

3. Rebase your changes

    Update your local repository with the most recent code from the main A3Wasteland (sock-rpc-stats) repository, and rebase your branch on top of the latest "Development_main" branch. We prefer your changes to be squashed into a single commit.

4. Submit a pull request

    Push your local changes to your forked copy of the repository and [submit a pull request](https://help.github.com/articles/using-pull-requests). In the pull request, describe what your changes do and mention the number of the issue where discussion has taken place, eg "Closes #123".

Then sit back and wait. There will probably be discussion about the pull request and, if any changes are needed, we would love to work with you to get your pull request merged into A3Wasteland (sock-rpc-stats).


#### Follow these coding guidelines ####

* SQF indent is 2 spaces (no tabs)
* No unnecessary aligning of code to make it "Look nice". For example

```SQF
 _foo            = ".............";
 _fooBar         = ".............";
 _fooBarWidgets  = ".............";
  
```

* Use if statements, instead of switch statements. Do not do stuff like this:
```
  switch (_foo) : {
    case (<some expression>): {
    
    }
    case (<some other expression>): {
    
    }
    default: {
    
    }
  }
```

Instead, use the following format for if/else-if/else

```SQF

  if (<some condition>) then {
  
  }
  else { if (<some other condition>) then {
  
  }
  else {
  
  }};
```


* Avoid unnecessary nesting where possible. This is a subtle one. Sometimes you end with code that looks like this:

```SQF
  {
    if (<condition a) then {
      if (<condition b>) then {
        if (<condition c>) then {
          //actual logic here
        }
      }
    }
  } forEach _someArray;
```

This is unnecessary, and makes the code hard to maintain and understand. Instead do this:

```SQF
  {if (true) then {
  
    if (!<condition a>) exitWith {};
    if (!<condition b>) exitWith {};
    if (!<condition c>) exitWith {};
    
    //actual logic here
  
  }} forEach _someArray;
```

The whole point of this is to try to keep the code as flat as possible, and thus improve readability and maintenance, and reduce chance of subtle bugs.

* Use functions and modularize as much as possible. 
* Do not try to cram giant expressions into IF statements (create new functions if needed)
* Use underscore "_" instead of camel-casing for variable names, and function names.
* Always be coding on the defensive, do not assume that all the parameters passed into a function will always be initialized
* Use the utility macros from the macro.h file to help you out with type-checks, and processing of function arguments
* Line width is 140 characters
* Follow the Google [JavaScript style guidelines](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml)
* Do not re-format existing code. If there is legacy code form the A3Wasteland vanilla mission, do not reformat it. Follow the existing style instead.
* Wherever possible avoid making changes to the A3Wasteland vanilla files.
* Always define local variables before using them (use the "def", or "init" macros).
* Do not bulk-up local variable definitions all in one place. 
* Try to define the local variable as close to the place where it's first used.
* Familiarize yourself with the "ARGV", and "ARGVX" macros for processing function parameters, and use them.
* Use the "init", and "def" macros instead of the "private" keyword
