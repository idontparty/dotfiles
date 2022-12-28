#!/bin/bash
pacman -Qqen | sed -e 's/^/  - /'

