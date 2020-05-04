# ASH
###### API Shell

## Description
ASH (stands for API Shell) is a Swift based shell that fully utilizes APIs built into the language. This allows actions performed by a Swift binary to go unnoticed by EDR solutions. The code itself is benign and uses built in benign APIs; however, the APIs themselves can return and perform valuable information and actions.

The goal of open sourcing this shell is to help build detection around API actions and to build awareness around potential attack methods threat actors may utilize.

I do plan to add more functions to ASH over time and rework some of the code.

## Installation
I have tested this solely on macOS (I don't know how Linux support is but I would love to hear about it). I have also primarily used this using Xcode's built in package manager: I have not tested this package with third party package managers. Instructions on how to use Xcode's package manager can be found at the link below.

[https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

Once the package is added as a dependancy, import the package to your project's .swift file:
`import ASH`

After ASH is imported into the project, you can call the package using the following format replacing command with a string or a variable that contains a string. The string must be a valid ASH command that can be seen in the man section or a valid Terminal command:
`ASH.command(command: command!)`

## Library Results
All results from this library will be returned in a dictionary that will contain the command passed, the type of the results, and the results themselves. With commands that involve raw data being returned, the filename will be passed as well with the data. The dictionary looks like:
`["inCommand":inCommand, "returnType":returnType, "returnData":returnData]`
or
`["inCommand":inCommand, "returnType":returnType, "fileName":fileName, "returnData":returnData]`

## Manpage
mkdir; --- Make a directory in your current directory.

whoami; --- Print the current user.

cdr; --- Go to a single folder from your current directory.

cd; --- Change directories.

ls; --- List the directory.

ps; --- Will list all processes not limited to user processes.

strings; --- This will print the contents of a file.

mv; --- Perform a mv command to move files/folders.

cp; --- Copy a file/folder.

screenshot; Destination --- Take a snapshot of all screens. This will notify the user.
  
osascript; Code --- This will run an Apple script.
  
execute; App to Run --- This will execute a payload as an API call (no shell needed). Sometimes this works better if you're already in the directory of the payload.
  
#### Bugs
The following bugs are known:
* Snapshot needs a code rewrite for efficiency
* cd doesn't work as a ksh command; however, the ASH version works the same.
