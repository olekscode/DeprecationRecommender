# DeprecationRecommender

[![Build status](https://github.com/olekscode/DeprecationRecommender/workflows/CI/badge.svg)](https://github.com/olekscode/DeprecationRecommender/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/olekscode/DeprecationRecommender/badge.svg?branch=master)](https://coveralls.io/github/olekscode/DeprecationRecommender?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/olekscode/DeprecationRecommender/master/LICENSE)

## How to install it?

To install `DeprecationRecommender`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'DeprecationRecommender';
  repository: 'github://olekscode/DeprecationRecommender/src';
  load.
```

## How to depend on it?

If you want to add a dependency on `DeprecationRecommender` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'DeprecationRecommender'
  with: [ spec repository: 'github://olekscode/DeprecationRecommender/src' ].
```

If you are new to baselines and Metacello, check out the [Baselines](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md) tutorial on Pharo Wiki.

## How to use it?
