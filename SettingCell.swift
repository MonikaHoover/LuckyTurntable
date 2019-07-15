import UIKit
class SettingCell: BaseCell {
    private lazy var titleL: UILabel = {
       let label = UILabel.createLabel(title: "", color: UIColor.init(r: 147, g: 78, b: 40, a: 1), font: 16, textAlignment: .left, backColor: .clear, numberOfLines: 1)
        label.addShadow()
        return label
    }()
    private let switchBtn: UISwitch = UISwitch.init(frame: CGRect.zero)
    private let arrow: UIImageView = UIImageView.init(image: UIImage.init(named: "arrow"))
    var cellType: SettingType = .evaluation(""){
        didSet{
            switchBtn.isHidden = true
            arrow.isHidden = false
            switch cellType {
            case .music(let s,let b):
                switchBtn.isHidden = false
                 arrow.isHidden = true
                switchBtn.isOn = b
                titleL.text = s
                break;
            case .touch(let s,let b):
                switchBtn.isHidden = false
                arrow.isHidden = true
                switchBtn.isOn = b
                titleL.text = s
                break;
            case .random(let s,let b):
                switchBtn.isHidden = false
                arrow.isHidden = true
                switchBtn.isOn = b
                titleL.text = s
                break;
            case .vip(let s):
                titleL.text = s
                break;
            case .closeAd(let s):
                titleL.text = s
                break;
            case .evaluation(let s):
                titleL.text = s
                break;
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        let bgImgView = UIImageView.init(image: UIImage.init(named: "scratch_content"))
        bgImgView.isUserInteractionEnabled = true
        contentView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(7.5)
            make.bottom.equalTo(-7.5)
        }
        bgImgView.addSubview(titleL)
        bgImgView.addSubview(switchBtn)
        bgImgView.addSubview(arrow)
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.bottom.equalTo(bgImgView)
            make.width.equalTo(150)
        }
        switchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(bgImgView.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(45)
        }
        arrow.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.centerY.equalTo(bgImgView.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        switchBtn.addTarget(self, action: #selector(isTouchOn), for: UIControl.Event.touchUpInside)
        backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height:2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3
    }
    @objc private func isTouchOn(sw: UISwitch){
        switch cellType {
        case .music(_,_):
            AppConfig.saveValue(value: sw.isOn, key: openMusic)
            AppConfig.makeAppConfig().isOpenMusic = sw.isOn
            break;
        case .touch(_,_):
            AppConfig.saveValue(value: sw.isOn, key: openTouch)
            AppConfig.makeAppConfig().isOpenTouch = sw.isOn
            break;
        case .random(_,_):
            AppConfig.saveValue(value: sw.isOn, key: openRandom)
            AppConfig.makeAppConfig().isOpenRandom = sw.isOn
            break;
        case .vip(_):
            break;
        case .closeAd(_):
            break;
        case .evaluation(_):
            break;
        }
        sw.setOn(sw.isOn, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
