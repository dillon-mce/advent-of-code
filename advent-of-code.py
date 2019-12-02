#!/usr/bin/python

import subprocess
import optparse

# Wrapper around subprocess.call() to make the verbose option easier
def call(array):
    if options.verbose: print("Calling: '" + " ".join(array) + "'")
    subprocess.call(array)

# Installs this script so it can be called from anywhere
def install():
    install_location = "/usr/local/bin"
    print("Installing aoc script at: " + install_location + "...")
    call(["cp", "advent-of-code.py", install_location + "/aoc"])

# Adds a new script with the given day
def new_script(day):
    file_name = "Day-" + day + ".swift"
    input_name = "Day-" + day + "-Input.txt"
    call(["touch", "_template.swift"])
    call(["cp", "-n", "_template.swift", file_name])
    call(["chmod", "+x", file_name])
    call(["touch", input_name])

# Runs the script for the given day, if it exists
def run_script(day):
    file_name = "./Day-" + day + ".swift"
    input_name = "Day-" + day + "-Input.txt"
    process = subprocess.Popen(["cat", input_name], stdout=subprocess.PIPE)
    input = process.stdout.read()
    call([file_name, input])

# Runs the the script for the given day with no input, if it extists
def test_run(day):
    file_name = "./Day-" + day + ".swift"
    call([file_name])

# TODO: add a build and run option to compile the script and run that.

# Set up option parser
parser = optparse.OptionParser()
parser.add_option("-i", "--install", action="store_true", dest="install", default=False, help="install the latest version of the script")
parser.add_option("-t", "--test", action="store_true", dest="test", default=False, help="run the script with no input")
parser.add_option("-n", "--new", dest="new", help="create a new day's script")
parser.add_option("-v", "--verbose", action="store_true", dest="verbose", default=False, help="run the script with all diagnostic prints")

(options, args) = parser.parse_args()

# Diagnostic print statments to verify things are working correctly
if options.verbose:
    print("Options: {}".format(options))
    print("Args: {}".format(args))

# If the install flag is passed, install the script and exit
if options.install:
    install()
    print("Done!")
    exit(0)

# If the new flag is pass, run new_script and exit
if options.new:
    new_script(options.new)
    print("Done!")
    exit(0)

# Attempt to run the script on all the days passed
if len(args) > 0:
    for day in args:
        if options.test:
            test_run(day)
        else:
            run_script(day)
    exit(0)
else:
    print("You need to pass an argument for the day number")
    exit(1)
