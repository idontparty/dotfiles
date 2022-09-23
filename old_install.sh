#!/bin/bash

# Create virtualenv named 'venv'.
python3 -m venv venv 

# Activate python virtualenv.
source 'venv/bin/activate'

# Install pip on Arch linux
sudo pacman -S python-pip

# Install pip packages (needed for toxic tissue).
pip install -r requirements.txt

# TODO: Add support for downloading oh-my-zsh first.

# Run toxic tissue.
python toxic_tissue.py -f arch.yaml

# TODO: Add support for other OSs.


