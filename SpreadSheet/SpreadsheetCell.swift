//
//  SpreadsheetCell.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/11.
//

import UIKit

class SpreadsheetCell: UITableViewCell {
    
    // 可調的寬度比例，預設為 2/8 (約 0.25)
    var widthMultiplier: CGFloat = 2.0/8.0
    
    var labels: [UILabel] = [] // cell 內部的所有 label
    private var borderViewArray: [BorderViews?] = []
    private var labelContentViewArray: [UIView?] = []

    private lazy var mainStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private var viewModel: SpreadsheetItemViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func update(viewModel: SpreadsheetItemViewModel) {
        self.viewModel = viewModel
        
        // 如果 viewModel 提供了 multiplier，就使用它
        if let multiplier = viewModel.widthMultiplier {
            self.widthMultiplier = multiplier
        }
        
        if !mainStackView.isDescendant(of: self) {
            setupView()
        }
        
        applyViewModel()
        
        layoutIfNeeded()
    }
    
    func applyViewModel() {
        let lastIndex = viewModel.items.capacity - 1
        for (index, item) in viewModel.items.enumerated() {
            labels[safe: index]?.text = item
            labels[safe: index]?.sizeToFit()
            hideUIViewBorder(withIsLastLine: viewModel.isLastLine,
                             isLastIndex: index == lastIndex,
                             bottomBorder: borderViewArray[index]?.bottomBorder ?? UIView(),
                             rightBorder: borderViewArray[index]?.rightBorder ?? UIView())
        }
    }
    
    func setupView() {
        // 1. 改為 .fill 或 .fillProportionally
        mainStackView.distribution = .fill
        
        addSubview(mainStackView)
        
        for item in viewModel.items {
            let label = buildLabel(with: item)
            let view = buildLabelView(with: label)
            let topBorder = view.addBorder(.top, color: .darkGray, thickness: 1)
            let bottomBorder = view.addBorder(.bottom, color: .darkGray, thickness: 1)
            let leftBorder = view.addBorder(.left, color: .darkGray, thickness: 1)
            let rightBorder = view.addBorder(.right, color: .darkGray, thickness: 1)
            mainStackView.addArrangedSubview(view)
            
            borderViewArray.append(BorderViews(topBorder: topBorder, bottomBorder: bottomBorder, leftBorder: leftBorder, rightBorder: rightBorder))
            labels.append(label)
            labelContentViewArray.append(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: mainStackView.topAnchor),
                view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
            ])
        }
        
        // 2. 假設這一列只有 2 個欄位，給第一、第二個子視圖加上 1:9 寬度比
        if viewModel.items.count == 2 {
            let firstView = mainStackView.arrangedSubviews[0]
            let secondView = mainStackView.arrangedSubviews[1]
            
            // 讓 firstView 的寬度 = secondView 寬度 * (1/9)
            // 也就是 firstView : secondView = 1 : 9
            firstView.widthAnchor.constraint(
                equalTo: secondView.widthAnchor,
                multiplier: widthMultiplier
            ).isActive = true
        }
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func hideUIViewBorder(
        withIsLastLine isLastLine: Bool,
        isLastIndex: Bool,
        bottomBorder: UIView,
        rightBorder: UIView) {
        bottomBorder.isHidden = !isLastLine
        rightBorder.isHidden = !isLastIndex
    }
    
    private func buildLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func buildLabelView(with label: UILabel) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        return view
    }
    
    func setLabelsFont(isBold: Bool) {
        for label in labels {
            let currentFontSize = label.font.pointSize
            label.font = isBold ? UIFont.boldSystemFont(ofSize: currentFontSize) : UIFont.systemFont(ofSize: currentFontSize)
        }
    }
    
    func setLabelsAlignment(_ alignment: NSTextAlignment) {
        for label in labels {
            label.textAlignment = alignment
        }
    }
}
