# Project Eulixir

[![Build Status](https://travis-ci.org/csuzw/project-eulixir.svg?branch=master)](https://travis-ci.org/csuzw/project-eulixir)

An Elixir project framework for solving [Project Euler](https://projecteuler.net/) problems.

### Prerequisites

You need to have Elixir installed. Please refer to the [official guide](http://elixir-lang.org/install.html) for instructions.

### Running

Problems are located in the `/lib/problems/` directory.  
To solve a problem, implement the `solution/0` method in the appropriate problem module.  
If a module does not exist for a problem, run `mix compile` to build and generate problem modules.

To execute and check solution for a problem, run:

```sh
$ mix project_eulixir.solve 123
```

The task argument is the problem number (in the above example [123](https://projecteuler.net/problem=123)).

### Known Issues

* Problem discovery has not been fully implemented yet - only problem 1 is currently available.
* Sometimes if problem modules have been manually deleted when trying to solve a problem the following error is thrown: `(KeyError) key :message not found in: %UndefinedFunctionError{arity: 0, function: :solution, module: Problems.XXX, reason: nil}`.  To fix run `mix clean` and retry.



