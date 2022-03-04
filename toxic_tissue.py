"""toxic_tissue woop."""

import argparse
import io
import os
import yaml

class Installer:
    """Installer contains data regarding the install."""

    def __init__(self, basepath, distro, version):
        self.basepath = basepath
        self.distro = distro
        self.version = version
        self.tt_path = os.getcwd() + "/"

        self.success_dotfiles = 0
        self.unsuccessful_dotfiles = 0
        

    def add_unsuccessful_dotfile(self):
        """Increment unsuccessful dotfiles by 1."""
        self.unsuccessful_dotfiles += 1
    
    def add_successful_dotfile(self):
        """Increment succesful dotfiles by 1."""
        self.success_dotfiles += 1


def main(args):
    """Run the standalone script."""
    file = io.open(args.file, "r", encoding="utf-8")
    entries = yaml.load(file, Loader=yaml.FullLoader)
    installer = print_metadata(entries)

    # Move dotfiles
    install_dotfiles(installer, entries)

    # Print status update - keep track in installer object?

    return

# TODO: Rename function name.
def install_dotfiles(installer, entries):
    """Installs dotfiles."""
    files = entries.get("dotfiles")
    print("[*] Installing d to the otfiles...")
    for file in files:
        name = file.get("name")
        src = installer.tt_path + file.get("src")
        dst = installer.basepath + file.get("dst")
        
        if os.path.isfile(dst):
            # Check if symlinked already. If so, ignore.
            if os.path.islink(dst):
                print(f"\t\t[:D] Symlink for dotfile {dst} already exists. Skipping.")
                installer.add_unsuccessful_dotfile()
                continue
            # Move dotfile to dst.bak
            print(
                  f"\t\t[!] Dotfile {name} exists, attempting to move original" \
                  f" to {dst + '.bak'}.")
            try:
                os.replace(dst, dst + ".bak")
                print("\t\t[*] Success - managed to save backup.")
            except OSError():
                print("\t\t[!] Unable to move current dotfile to .bak. Skippig this config!")
                installer.add_unsuccessful_dotfile()
                continue
        print(f"\t* Installing dotfile {name}.")
        os.symlink(src, dst)
        installer.add_successful_dotfile()
    print_summary(installer)
    return

def print_metadata(entries):
    """Prints metadata from yaml config."""
    print(
        """
########  #######  ##     ## ####  ######     ######## ####  ######   ######  ##     ## ########
   ##    ##     ##  ##   ##   ##  ##    ##       ##     ##  ##    ## ##    ## ##     ## ##
   ##    ##     ##   ## ##    ##  ##             ##     ##  ##       ##       ##     ## ##
   ##    ##     ##    ###     ##  ##             ##     ##   ######   ######  ##     ## ######
   ##    ##     ##   ## ##    ##  ##             ##     ##        ##       ## ##     ## ##
   ##    ##     ##  ##   ##   ##  ##    ##       ##     ##  ##    ## ##    ## ##     ## ##
   ##     #######  ##     ## ####  ######        ##    ####  ######   ######   #######  ########
        """)

    print("[*] Dumping metadata...")
    metadata = entries.get("metadata")

    # Default fields.
    basepath = os.path.expandvars("$HOME/")
    version = 1.0
    distro = "unknown"
    for key in metadata:
        # Expand possible environment variables.
        if key == "basepath":
            basepath = os.path.expandvars(metadata[key])
            print("\t* " + key + ": " + str(basepath))
        else:
            print("\t* " + key + ": " + str(metadata[key]))

        if key == "distro":
            distro = metadata[key]
        elif key == "version":
            version = metadata[key]

    print("[*] We shot the cyberbirds... Mourning is over.\n")
    return Installer(basepath, distro, version)


def print_summary(installer):
    print("""
##################################
######### Toxic (T)issue #########
##################################
# Summary of the run:            #
##################################
# Installed {} dotfiles.          #
# Unable to install {} dotfiles.  #
##################################
# Cheeeeeeeeeeeeeeeeeerioooooooo #
##################################
    """.format(installer.success_dotfiles, installer.unsuccessful_dotfiles))
'''
def install_os_packages(installer):
    """Installing packages based on distro."""
    # Check if debian or arch
    if "arch" in installer.distro:
        # Go with pacman
        # Dump package names
        # Install 
'''

def arg_parser():
    """arg_parser parse the args provided by the user."""
    parser = argparse.ArgumentParser(
        description = "Installs and configures a userland system" \
                      "including software and dotfiles.")
    parser.add_argument("-f", "--file", required=True, type=str,
                        help="Path to yaml configuration file. Required.")

    args = parser.parse_args()
    return args

if __name__== "__main__" :
    argv = arg_parser()
    main(argv)
