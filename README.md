# Project Eulixir

[![Build Status](https://travis-ci.org/csuzw/project-eulixir.svg?branch=master)](https://travis-ci.org/csuzw/project-eulixir)

An Elixir project framework for solving [Project Euler](https://projecteuler.net/) problems.

### Prerequisites

You need to have Elixir installed. Please refer to the [official guide](http://elixir-lang.org/install.html) for instructions.

### Running

To generate problem modules from the latest problem definitions, run:

```sh
$ mix project_eulixir.generate
```

This will create problem modules in `/lib/problems/`.  The definition file currently only contains problem 1.


To execute and check solution for a problem, run:

```sh
$ mix project_eulixir.solve 123
```

The task argument is the problem number (in the above example [123](https://projecteuler.net/problem=123)).



