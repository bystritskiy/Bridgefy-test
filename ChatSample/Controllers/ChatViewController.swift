import UIKit
//import IQKeyboardManagerSwift

let broadcastConversation: String = "broadcast"

protocol ChatViewControllerDelegate: NSObjectProtocol {
    func sendMessage(_ message: Message, toConversation uuid: String)
}

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var chatDelegate: ChatViewControllerDelegate?
    var userUUID: String = ""
    var deviceName: String = ""
    var deviceType: DeviceType = .undefined
    var online: Bool = false
    var broadcastType: Bool = false
    var messages: NSMutableArray = []
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    func addMessage(_ message: Message) {
        self.messages.insert(message, at: 0)
        self.addRowToTable()
    }
    
    func updateOnlineTo(_ onlineStatus: Bool) {
        self.online = onlineStatus
    }
    
    @IBAction func sendText(_ sender: AnyObject) {
        if self.textField.text!.isEmpty {
            return
        }
        let message: Message = Message()
        message.text = self.textField!.text!
        message.date = Date()
        message.received = false
        message.broadcast = self.broadcastType
        if self.broadcastType {
            self.chatDelegate?.sendMessage(message, toConversation: broadcastConversation)
            print("ОТПРАВКА СООБЩЕНИЯ BROADCAST")
            print("sender = ", message.sender)
            print("text = ", message.text)
            print("date = ", message.date)
            print("mesh = ", message.mesh)
            print("broadcast = ", message.broadcast)
            print("deviceType = ", message.deviceType)
        } else {
            //If conversation is not broadcast send a direct message to the UUID
            self.chatDelegate?.sendMessage(message, toConversation: self.userUUID)
            print("ОТПРАВКА СООБЩЕНИЯ DIRECT")
            print("sender = ", message.sender)
            print("text = ", message.text)
            print("date = ", message.date)
            print("mesh = ", message.mesh)
            print("broadcast = ", message.broadcast)
            print("deviceType = ", message.deviceType)
        }
        self.textField.text = ""
        self.messages.insert(message, at: 0)
        self.addRowToTable()
    }
    
    @IBOutlet weak var bottomConstarint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.broadcastType {
            self.navigationItem.title = "Общий чат"
        } else {
            self.navigationItem.title = self.deviceName
        }
    }
    

    func addRowToTable() {
        self.tableView.beginUpdates()
        let index = IndexPath(row:0, section: 0)
        self.tableView.insertRows(at: [index], with: UITableViewRowAnimation.bottom)
        self.tableView.endUpdates()
    }
    
}

extension ChatViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        let userLabel = cell.contentView.viewWithTag(1000) as! UILabel
        let messageLabel = cell.contentView.viewWithTag(1001) as! UILabel
        let dateLabel = cell.contentView.viewWithTag(1002) as! UILabel
        let transmissionLabel = cell.contentView.viewWithTag(1003) as! UILabel
        let deviceTypeImageView = cell.contentView.viewWithTag(1004) as! UIImageView
        let message: Message = self.messages.object(at: indexPath.item) as! Message
        if message.received {
            userLabel.textColor = UIColor.red
            userLabel.text = message.sender
            transmissionLabel.textColor = message.mesh ? UIColor.blue : UIColor.red
            transmissionLabel.text = message.mesh ? "MESH" : "DIRECT"
            
            switch message.deviceType {
            case .undefined:
                deviceTypeImageView.image = nil;
            case .android:
                deviceTypeImageView.image = UIImage.init(named: "android")
            case .ios:
                deviceTypeImageView.image = UIImage.init(named: "ios")
            }
        } else {
            userLabel.textColor = UIColor.blue
            userLabel.text = "Вы:"
            transmissionLabel.text = ""
            deviceTypeImageView.image = nil;
        }
        messageLabel.text = message.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateLabel.text = dateFormatter.string(from: message.date as Date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.textField.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
