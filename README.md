# tectonics.glsl
## A glsl library of useful functions for physically based rendering in astronomy

**tectonics.glsl** is a collection of glsl functions that serve as a backend to [tectonics.js](http://davidson16807.github.io/tectonics.js/). Since many of these functions need to be reimplemented several times in several different languages, glsl serves as a lingua franca for storing canonical versions that can then be transpiled to other languages using [glsl_tools](https://github.com/davidson16807/glsl_tools). We choose glsl to do this for two main reasons:

* glsl is a simple language. It has a simple grammar that can be easily described within transpilers, and it has a limited set of language features that are frequently supported in most other languages, making translation straight forward. 
* glsl is a strictly procedural language. This makes it very easy to guarantee functional purity within library code.

This library is not just designed for use by tectonics.js. Numerous space simulators can make use of the functionality here. The components here are lightweight and loosely coupled. Parts of the library can be easily taken out, mixed and matched, and modified. It's a shame really if this library only gets used once. 

Permission to use the code is provided under the Creative Commons Attribution 4.0 license. You may modify and redistribute the code as you see fit. You need only attribute the work to me as the project developer, which I appreciate since it helps me develop professionally. Drop me a line if you do so since it's encouraging to hear my work is getting used! 
