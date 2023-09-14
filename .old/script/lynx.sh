#!/usr/bin/env bash
(cat ~/.cache/wal/sequences &)
lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss
