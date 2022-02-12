#!/bin/sh
(cat ~/.cache/wal/sequences &)
slock unimatrix -s 95 -l kns
