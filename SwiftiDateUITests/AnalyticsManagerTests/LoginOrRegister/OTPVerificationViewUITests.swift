//
//  OTPVerificationViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class OTPVerificationViewUITests: XCTestCase {
    
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy) // 🟢 監聽事件
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent() // 🛑 解除監聽
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testOTPVerification_Appeared() throws {
        let view = OTPVerificationView(
            isRegistering: .constant(true),
            selectedCountryCode: .constant("+886"),
            phoneNumber: .constant("0972516868")
        )
        
        ViewHosting.host(view: view)
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "OTPVerification_Appeared"
            },
            "畫面顯示時應觸發 OTPVerification_Appeared 事件"
        )
    }
    
    func testBackButtonTapped() throws {
        var isRegistering = true
        let view = OTPVerificationView(
            isRegistering: .init(get: { isRegistering }, set: { isRegistering = $0 }),
            selectedCountryCode: .constant("+886"),
            phoneNumber: .constant("0972516868")
        )
        
        ViewHosting.host(view: view)
        
        let backButton = try view.inspect().find(ViewType.Button.self, where: {
            try $0.labelView().image().actualImage().name() == "chevron.left"
        })
        
        try backButton.tap()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "OTPVerification_BackTapped"
            },
            "點擊返回按鈕應觸發 OTPVerification_BackTapped 事件"
        )
        
        XCTAssertFalse(isRegistering, "返回時 isRegistering 應變為 false")
    }
    
    func testOTPCodeEntry() throws {
        var otpCode = ["", "", "", "", "", ""]
        let view = OTPVerificationView(
            isRegistering: .constant(true),
            selectedCountryCode: .constant("+886"),
            phoneNumber: .constant("0972516868")
        )
        
        ViewHosting.host(view: view)
        
        for i in 0..<6 {
            let textField = try view.inspect().find(ViewType.TextField.self, where: {
                try $0.accessibilityIdentifier() == "OTPTextField\(i)"
            })
            
            try textField.setInput("1")
            otpCode[i] = "1"
        }
        
        XCTAssertEqual(otpCode, ["1", "1", "1", "1", "1", "1"], "OTP 輸入框應正確更新")
    }
    
    func testResendOTP() throws {
        let view = OTPVerificationView(
            isRegistering: .constant(true),
            selectedCountryCode: .constant("+886"),
            phoneNumber: .constant("0972516868")
        )
        
        ViewHosting.host(view: view)
        
        let resendButton = try view.inspect().find(ViewType.Button.self, where: {
            try $0.labelView().text().string() == "重新獲取"
        })
        
        try resendButton.tap()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "OTPVerification_ResendOTP"
            },
            "點擊重新獲取應觸發 OTPVerification_ResendOTP 事件"
        )
    }
    
    func testVerifyOTPCode() throws {
        var showRealVerification = false
        let view = OTPVerificationView(
            isRegistering: .constant(true),
            selectedCountryCode: .constant("+886"),
            phoneNumber: .constant("0972516868")
        )
        
        ViewHosting.host(view: view)
        
        let verifyButton = try view.inspect().find(ViewType.Button.self, where: {
            try $0.labelView().text().string() == "提交驗證碼"
        })
        
        try verifyButton.tap()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "OTPVerification_VerifyTapped"
            },
            "點擊提交驗證碼應觸發 OTPVerification_VerifyTapped 事件"
        )
    }
}
