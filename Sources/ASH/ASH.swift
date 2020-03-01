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
            default:
                return
            }
        }
    }
}
