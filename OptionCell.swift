import UIKit
protocol OptionCellDelegate{
    func textFieldEndEditing(text: String , cell: OptionCell)
}
class OptionCell: BaseCell {
    private lazy var filedView: UITextField = {
       let field = UITextField.init()
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = UIColor.init(r: 147, g: 78, b: 40, a: 1)
        field.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        field.textAlignment = .center
        field.addTarget(self, action: #selector(textChange), for: UIControl.Event.allEditingEvents)
        return field
    }()
    var optionDelegate: OptionCellDelegate?
    var filedText: String = ""{
        didSet{
            if filedText == TabText || filedText == ThemeText {
                filedView.text = ""
                filedView.placeholder = filedText
                filedView.setValue(UIColor.red, forKeyPath: "_placeholderLabel.textColor")
                return
            }
            filedView.text = filedText
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       selectionStyle = .none
        let bgImgView = UIImageView.init(image: UIImage.init(named: "scratch_content"))
        bgImgView.isUserInteractionEnabled = true
        contentView.addSubview(bgImgView)
        contentView.addSubview(filedView)
        bgImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(filedView)
        }
        filedView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(7.5)
            make.bottom.equalTo(-7.5)
        }
        backgroundColor = UIColor.clear
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
        super.setSelected(selected, animated: animated)
    }
    @objc private func textChange(textField: UITextField){
        guard let text = textField.text ,text.count < 25 else {
            return 
        }
        optionDelegate?.textFieldEndEditing(text: text, cell: self)
    }
}
