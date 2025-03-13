//
//  SpreadsheetCellRepresentable.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/11.
//

import Foundation
import SwiftUI
import UIKit

struct SpreadsheetCellRepresentable: UIViewRepresentable {
    let viewModel: SpreadsheetItemViewModel

    func makeUIView(context: Context) -> SpreadsheetCell {
        let cell = SpreadsheetCell(style: .default, reuseIdentifier: "SpreadsheetCell")
        return cell
    }

    func updateUIView(_ uiView: SpreadsheetCell, context: Context) {
        uiView.update(viewModel: viewModel)
    }
}
