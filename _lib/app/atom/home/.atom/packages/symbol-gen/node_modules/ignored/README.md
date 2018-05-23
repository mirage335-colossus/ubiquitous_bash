# ignored
Get a **list** of **entries** from ***.gitignore*** **file**.

[![Build Status](https://travis-ci.org/dwyl/ignored.svg)](https://travis-ci.org/dwyl/ignored)
[![Code Climate](https://codeclimate.com/github/dwyl/ignored/badges/gpa.svg)](https://codeclimate.com/github/dwyl/ignored)
[![Test Coverage](https://codeclimate.com/github/dwyl/ignored/badges/coverage.svg)](https://codeclimate.com/github/dwyl/ignored)
[![npm version](https://badge.fury.io/js/listdirs.svg)](http://badge.fury.io/js/listdirs)
[![Node.js Version][node-version-image]][node-version-url]
[![Dependency Status](https://david-dm.org/dwyl/ignored.svg)](https://david-dm.org/dwyl/ignored)

![.gitignore me!](http://i.imgur.com/CszskqZ.png)

## Why?

In the [***faster***](https://github.com/ideaq/faster)
 project we are watching directories for changes,  
 but we want to ***ignore*** the files/directories
 listed in the ***.gitignore*** file.

 There were a couple of options parsing .gitignore files on NPM
 see *Research* section below,  
 but none were as simple or well-tested as
 we needed, so we wrote our own.

 And because it's *fast*, has *zero dependencies* and (might
 be) *useful* to others, we have released it as an npm package!

## What?

This ultra-simple module ***parses*** your **.gitignore** file
and gives you an **list** (array) of the items it finds.

## Usage

### Install from [NPM](https://www.npmjs.com/package/ignored)

```sh
npm install ignored --save
```

### In Your Code

```js
var ignored = require('ignored')(__dirname+'/../.gitignore'); // use .gitignore in parent dir
console.log(ignored); // use the array of .gitignore entries as desired
```
*We recommend* using this module * **Sync**hronously* *once* at the top of your file
(it only gets run once at the start-up of your project and only  
takes a couple of milliseconds, similar to a `require` call).

<br />
- - -

There are actually ***3 ways*** to use this module in your code:

#### 1. Sync (*Without* passing a .gitignore file as parameter)

The **simplest way** to use this module is to let it figure out where your
project's .gitignore  
file is and return the list ***synchronously*** at the
top of your script.

```js
// synchronous immediate invocation assigns the list to the ignored var directly
var ignored = require('ignored')(); // without param (we search for .gitignore)
// use the array of .gitignore entries as desired
```
***Note***: we only go *one* directory level up from the
*Current Working Directory* as *most*  
node projects have a *shallow*
directory structure e.g. put code in a **lib/** or **src/**.

#### 2. Sync (Specifying a .gitignore file as the only parameter)

This is the *recommended* way of using the module as you know *exactly*  
which .gitignore file you are using
(some projects have *multiple* .gitignore files!)

```js
// synchronous immediate invocation with a specific file supplied the only param
var ignored = require('ignored')('../.gitignore'); // use .gitignore in parent dir
// use the array of .gitignore entries as desired
```

#### 3. *Async* (Specifying the .gitignore file as first parameter)

```js
// async passing in a specific .gitignore file:
var ignored = require('ignored')
// use .gitignore in parent directory
ignored('../.gitignore', function callback(err, list) {
  if(err){
    console.log(err); // handle errors in your preferred way.
  }
  else {
    console.log(list); // use the array of directories as required.
  }
});
// use the array of .gitignore entries as desired
```


## Contributing [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/dwyl/ignored/fork)

***All*** *contributions* are *welcome*.  
We have done our best to make this module functional, simple and easy to understand.  
If you spot an inefficiency or omission in the parser, please help us fix it!  
(*please create an [**issue**](https://github.com/dwyl/ignored/issues) to inform us!*)

If anything is unclear please create an [**issue**](https://github.com/dwyl/ignored/issues)
so we can help clarify.

### devDependencies [![devDependency Status](https://david-dm.org/dwyl/ignored/dev-status.svg)](https://david-dm.org/dwyl/ignored#info=devDependencies)

> Feel free to submit a Pull Request if these are out of date. (_thanks!_)

## Research

As always with NPM, there are *many* available modules that *could* do what we want:

![npm-search-for-gitignore](https://cloud.githubusercontent.com/assets/194400/6828867/dce60fa8-d307-11e4-8517-b4fd89062863.png)

So we tried a few:

+ **fstream-ignore**: https://www.npmjs.com/package/fstream-ignore
(streaming is great, but complicates things here...)
+ **ignore**: https://www.npmjs.com/package/ignore
(*way* too many options! no simple "no-brainer" usage)
+ **gitignore-parser**: https://www.npmjs.com/package/gitignore-parser
(strange interface and lacks documentation)
+ **parse-gitignore**: https://www.npmjs.com/package/parse-gitignore
(no async method/interface and expects you to supply the .gitignore file contents)

(*Once again*) none of these were *simple*, (sufficiently) well-tested or clearly documented for our liking.

[node-version-image]: https://img.shields.io/node/v/ignored.svg?style=flat
[node-version-url]: http://nodejs.org/download/
