import UIKit
import SnapKit
class ThemeCell: BaseCell {
    private lazy var titleL: UILabel = {
        var label =  UIView.createLabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.medium)
        label.addShadow()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var title: String = ""{
        didSet{
            titleL.text = title
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        let bgImgView = UIImageView.init(image: UIImage.init(named: "scratch_content"))
        bgImgView.isUserInteractionEnabled = true
        contentView.addSubview(bgImgView)
        contentView.addSubview(titleL)
        bgImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(titleL)
        }
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(7.5)
            make.bottom.equalTo(-7.5)
        }
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height:2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}
