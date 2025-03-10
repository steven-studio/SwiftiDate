//
//  SpreadSheetView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/11.
//

import UIKit

class SpreadSheetView: UIView {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false  // 禁用內部滾動

        return tableView
    }()
    
    private let viewModel: [[String]]

    public init(viewModel: [[String]]) {
        if viewModel.count < 1 {
            fatalError("less than one row")
        }
        
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(self.tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        
        tableView.register(SpreadsheetCell.self, forCellReuseIdentifier: "\(SpreadsheetCell.self)")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 讓 tableView 更新 layout
        tableView.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        // 確保視圖佈局完成以獲得正確的 contentSize
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: tableView.contentSize.height)
    }
}

extension SpreadSheetView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SpreadsheetCell.self)", for: indexPath) as? SpreadsheetCell else {
            return UITableViewCell()
        }
        let model = SpreadsheetItemViewModel(
            items: viewModel[indexPath.row],
            isFirstLine: indexPath.row == 0,
            isLastLine: indexPath.row == viewModel.count - 1)
        cell.update(viewModel: model)
        
        return cell
    }
}

extension SpreadSheetView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
