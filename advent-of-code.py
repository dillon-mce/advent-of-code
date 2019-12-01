#!/usr/bin/python

import subprocess
import optparse

def install():
    install_location = "/usr/local/bin"
    print("Installing aoc script at: " + install_location)
    subprocess.call(["cp", "youtube-download.py", install_location + "/aoc"])
