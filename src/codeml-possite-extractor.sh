#!/bin/bash

perl -0777 -ne 'm/Bayes Empirical Bayes.*?Prob\(w>1\):.(.*)The/s;print $1' | strip.pl
