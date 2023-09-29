#!/bin/bash
djvu2pdf -s "$1" && sleep 1 && dpsprep "$1" "$2"
