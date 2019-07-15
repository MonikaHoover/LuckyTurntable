import UIKit
class ShowGameController: BaseController {
   private lazy var rouletteView: LuckRoulette = {
        let view = LuckRoulette.init(frame: CGRect(x: 15, y: 0, width: screenWidth - 30, height: screenWidth - 30))
        view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 10)
        return view
    }()
    private lazy var scratchView: ScratchView = {
        let view = ScratchView.init(frame: CGRect(x: 15, y: 0, width: screenWidth - 30, height: screenWidth - 40))
        view.scratchDelegate = self
        view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 10)
        return view
    }()
    private lazy var randomView: RandomView = {
        let view = RandomView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        view.center = self.view.center
        return view
    }()
    private let gameTitle = UILabel.createLabel(title: "Lucky Turntable", color: .white, font: 18, textAlignment: .center, backColor: .clear, numberOfLines: 1)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        headline = "Lucky Turntable"
        isShowBackBtn = false
        rightNavBtn.isHidden = false
        rightNavBtn.setBackgroundImage(UIImage.init(named: "setting"), for: .normal)
        gameTitle.addShadow()
        gameTitle.font = UIFont.init(name: "ZXFDarkGothic-", size: 22)
        saveData()
        self.changeThemeModeXtLucky("Lucky_turntable")
        initallGameAry()
        view.addSubview(rouletteView)
        view.addSubview(gameTitle)
        gameTitle.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(120)
            make.height.equalTo(30)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrentGameMode), name: NSNotification.Name(rawValue: GameModeNotificationName) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrentGameTheme), name: NSNotification.Name(rawValue: ThemeModeNotificationName) , object: nil)
        let btn = UIButton.createButton(target: self, selector: #selector(changeGameMode))
        btn.setBackgroundImage(UIImage.init(named: "mode_btn"), for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            } else {
                make.bottom.equalTo(-60)
            }
            make.left.equalTo(25)
            make.height.equalTo(44)
        }
        let btn1 = UIButton.createButton(target: self, selector: #selector(changeThemeMode))
        btn1.setBackgroundImage(UIImage.init(named: "theme_btn"), for: .normal)
        btn1.tag = 101
        view.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.bottom.equalTo(btn.snp.bottom).offset(0)
            make.left.equalTo(btn.snp.right).offset(25)
            make.right.equalTo(-25)
            make.height.equalTo(44)
            make.width.equalTo(btn.snp.width)
        }
    }
    @objc private func changeGameMode(){
        let nav = UINavigationController.init(rootViewController: GameModeController.init())
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    @objc private func changeThemeMode(){
        let nav = UINavigationController.init(rootViewController: ViewController.init())
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    override func clickRightBtn() {
        let nav = UINavigationController.init(rootViewController: SettingController.init())
       self.present(nav, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        if t?.tapCount ?? 0 > 3 {
            AppConfig.makeAppConfig().isVIP = true
            AppConfig.saveValue(value: true, key: buyVIP)
        }
    }
    @objc private func changeCurrentGameMode(notification: NSNotification)  {
        rouletteView.removeFromSuperview()
        scratchView.removeFromSuperview()
        randomView.removeFromSuperview()
        switch CurrentGameModel {
        case .Lottery:
            headline = "Lucky Turntable"
            view.addSubview(rouletteView)
            scratchView.updataScrathView()
            break
        case .Random:
            headline = "Random Pattern"
            view.addSubview(randomView)
            randomView.updataRandomView()
            break
        case .Scrath:
            headline = "Scratch Ticket"
            view.addSubview(scratchView)
            scratchView.updataScrathView()
            break
        }
    }
    @objc private func changeCurrentGameTheme(notification: NSNotification)  {
        switch CurrentGameModel {
        case .Lottery:
            rouletteView.updataViewData()
            break
        case .Random:
            randomView.updataRandomView()
            break
        case .Scrath:
            scratchView.updataScrathView()
            break
        }
         gameTitle.text = ThemeName
    }
   private func saveData() {
        guard AppConfig.readJsonData().allKeys.count == 0 else {
            return
        }
        let dict: NSMutableDictionary = [
            "Truth or Dare💖" : ["How many boyfriends do you have?","When was the last time you wetted your bed?","What colour are your underwear?","Who is your first love?","What kind of cheating do you have?","How old is your first kiss?","Are there any people present who you like?","How many people do you have a crush on?","Once more"],
                    "😊Where to Travel" : ["Los Angeles","New York","Washington","San Francisco","Seattle","Indianapolis","San Antonio","Atlanta","Phoenix","Once more"],
                    "🍺Who does housework?" : ["Husband","Wife","Children","Dogs","Once more"],
                    "Do you want to get up?⏰": ["Get up","Not getting up","Once more"],
                    "Who does the cooking?😪" :  ["Husband","Wife","Children","Dogs","Once more"],
                    "😡How to coax a girlfriend" :  ["Lipstick💄","Perfume","Face cream","Eye cream","Mask","Eyebrow pencil","Eyeliner"],
                    "Gifts for boyfriend" :  ["Basketball","Football","AJ","X-box"],
                    "Truth or Dare💞" :  ["Make a face that everyone is satisfied with.","Representation to an opposite sex for 3 minutes","Do your sexiest, most charming expression or action","Hold on to the iron door and shout, 'Let me out!'","He shouted out of the window, 'I'm so lonely.~","Ten seconds of affectionate kissing wall","Eat any dishes your friends have brought you"]
                        ]
        AppConfig.writeToData(dict: dict)
    }
    private func initallGameAry() {
        guard CurrentGameAry.count == 0, AppConfig.readJsonData().allKeys.count > 0 else {
            return
        }
        let keys = AppConfig.readJsonData().allKeys as! [String]
        gameTitle.text = keys.first
        CurrentGameAry = AppConfig.readJsonData()[keys.first ?? ""] as! [String]
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension ShowGameController: ScratchViewDelegate{
    func scratchView(result: String, percent: Float) {
    }
}
