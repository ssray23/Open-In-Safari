import Cocoa

func readMessage() -> [String: Any]? {
    var lengthBuffer = [UInt8](repeating: 0, count: 4)
    let lengthRead = fread(&lengthBuffer, 1, 4, stdin)
    
    guard lengthRead == 4 else { return nil }
    
    let length = Int(lengthBuffer[0]) | (Int(lengthBuffer[1]) << 8) | (Int(lengthBuffer[2]) << 16) | (Int(lengthBuffer[3]) << 24)
    
    var messageBuffer = [UInt8](repeating: 0, count: length)
    let messageRead = fread(&messageBuffer, 1, length, stdin)
    
    guard messageRead == length else { return nil }
    
    let data = Data(messageBuffer)
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return json
        }
    } catch {
        return nil
    }
    
    return nil
}

func sendMessage(message: [String: Any]) {
    do {
        let data = try JSONSerialization.data(withJSONObject: message, options: [])
        let length = UInt32(data.count)
        
        var lengthBuffer = [UInt8](repeating: 0, count: 4)
        lengthBuffer[0] = UInt8(length & 0xFF)
        lengthBuffer[1] = UInt8((length >> 8) & 0xFF)
        lengthBuffer[2] = UInt8((length >> 16) & 0xFF)
        lengthBuffer[3] = UInt8((length >> 24) & 0xFF)
        
        fwrite(lengthBuffer, 1, 4, stdout)
        fwrite((data as NSData).bytes, 1, Int(length), stdout)
        fflush(stdout)
    } catch {
        // Do nothing
    }
}

if let message = readMessage(), let urlString = message["url"] as? String {
    if let url = URL(string: urlString) {
        let safariURL = URL(fileURLWithPath: "/Applications/Safari.app")
        NSWorkspace.shared.open([url], withApplicationAt: safariURL, configuration: NSWorkspace.OpenConfiguration()) { app, error in
            if let error = error {
                sendMessage(message: ["status": "error", "error": error.localizedDescription])
            } else {
                sendMessage(message: ["status": "success"])
            }
        }
        // Need to run the runloop momentarily to allow the open operation to start
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    } else {
        sendMessage(message: ["status": "error", "error": "Invalid URL"])
    }
} else {
    sendMessage(message: ["status": "error", "error": "Failed to parse message"])
}
