#!/usr/bin/env bash
sed -n '/START_SNIPPET/,/END_SNIPPET/p' ~/.vim/UltiSnips/tex.snippets | \
    grep -e 'snippet .' \
    -e 'SNIPPET_GROUP' \
    -e '^#\* [biwrtsmeA]' | \
    grep -v '(.*)' | \
    # -v '# snippet.'| \
    grep -v '# snippet.'| \
    sed -e 's/snippet //' \
    -e 's/# SNIPPET_GROUP /\n/' | \
    # -e 's/\W[biwrtsmeA]\{1,3\}$//' \
    yad --text-info --back=#282c34 --fore=#46d9ff --geometry=1200x800
