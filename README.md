# tectonics.glsl
## A glsl library of useful functions for physically based rendering in astronomy

**tectonics.glsl** is a collection of glsl functions that serve as a backend to [tectonics.js](http://davidson16807.github.io/tectonics.js/) and [tectonics.cpp](http://davidson16807.github.io/tectonics.cpp/). Since many of these functions need to be reimplemented several times in several different languages, glsl serves as a lingua franca that stores canonical versions of functions for transpilation to other languages. A Python library, [glsl_tools](https://github.com/davidson16807/glsl_tools), is used to perform this transpilation.

We choose glsl as our main development language for a few reasons:

* glsl is a simple language. It has a [simple grammar](https://www.khronos.org/registry/OpenGL/specs/gl/glspec33.core.pdf) that can be easily described within transpilers, and it has a limited set of language features that are frequently supported in most other languages, making transpilation straight forward. 
* glsl is a strictly procedural language. This makes it very easy to guarantee functional purity within library code.
* glsl has built in linear algebra functionality. Many other languages have libraries that attempt to reimplement this functionality to create a common frame of mind (e.g. [glm](https://glm.g-truc.net/0.9.9/index.html), [cglm](https://github.com/recp/cglm), [glm-js](http://humbletim.github.io/glm-js/), [PyGLM](https://pypi.org/project/PyGLM/))

This library is not just designed for use by tectonics.js. Numerous space simulators can make use of the functionality here. The components here are lightweight and loosely coupled. Parts of the library can be easily taken out, mixed and matched, and modified. It's a shame really if this library only gets used once. 

Permission to use the code is provided under the Creative Commons Attribution 4.0 license. You may modify and redistribute the code as you see fit. You need only attribute the work to me as the project developer, which I appreciate since it helps me develop professionally. Drop me a line if you do so since it's encouraging to hear my work is getting used! 

# Subcomponents
tectonics.glsl stores pure, "side-effect-free" utility functions that usually express simple mathematic or scientific relationships (e.g. geometric relations, thermodynamics, orbital mechanics, etc.). Since shaders usually handle how glsl is applied to large sets of data, tectonics.glsl does not implement support for rasters or other data structures that can be seen in tectonics.js or tectonics.cpp. It mostly focuses on the "academics layer" of these applications. 

# Standards
* **Semantic Versioning 2.0.0**
* **"MKS/SI" International System of Units**
