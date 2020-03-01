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
            default:
                return
            }
        }
    }
}
