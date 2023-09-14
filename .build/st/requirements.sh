#!/usr/bin/bash
PATCHES_URLS=('https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff'
              'https://github.com/juliusHuelsmann/st/releases/download/alpha_09/st-focus-20230610-68d1ad9.diff'
              'https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff'
              'https://st.suckless.org/patches/scrollback/st-scrollback-20210507-4536f46.diff'
              'https://st.suckless.org/patches/workingdir/st-workingdir-20200317-51e19ea.diff'
             )

# TODO Add conditionnals or do it interactively

for i in "${PATCHES_URLS[@]}"; do
    curl --remote-name "$i"
done

PATCHES_FILES=(*.diff)
# printf '%s\n' "${PATCHES_FILES[@]}"

for i in "${PATCHES_FILES[@]}"; do
    patch -p1 < "$i"
done
