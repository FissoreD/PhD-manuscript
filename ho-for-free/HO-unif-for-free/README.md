# HO unification for free!

This folder contains the material for the paper: [HO unification for free!](https://inria.hal.science/hal-04547069)

The updated PDF of the paper is: [here](https://github.com/FissoreD/paper-ho/blob/pdf/main.pdf)

## Commands in Makefile

| Command                    | Description                                           |
| -------------------------- | ----------------------------------------------------- |
| `make`                     | same as `make test`                                   |
| `make test`                | run all the test taken from `./src/test.elpi`   |
| `make test ONLY=N`         | run the test with number `N`                          |
| `make test ONLY=N TEX=tex` | run the test with number `N` and prints in *tex* mode |
| `make trace ONLY=N`        | run the test with number `N` with the elpi trace      |

