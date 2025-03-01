//
//  PhotoSectionViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

extension Image: Inspectable {}

extension Image: CustomViewType {
    public static var typePrefix: String { "Image" }
    public typealias T = Image
}

final class PhotoSectionViewUITests: XCTestCase {
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testPhotoRemoval() throws {
        // Prepare initial photos and deletedPhotos bindings.
        var photos: [String] = ["testPhoto"]
        var deletedPhotos: [String] = []
        
        let bindingPhotos = Binding<[String]>(
            get: { photos },
            set: { photos = $0 }
        )
        let bindingDeleted = Binding<[String]>(
            get: { deletedPhotos },
            set: { deletedPhotos = $0 }
        )
        
        // Create the PhotoSectionView and host it.
        let userSettings = UserSettings()  // 確保 UserSettings 已經正確定義
        let view = PhotoSectionView(photos: bindingPhotos, deletedPhotos: bindingDeleted)
            .environmentObject(userSettings)
        ViewHosting.host(view: view)
        
        // Wait briefly to ensure view is loaded.
        let exp = expectation(description: "等待 view 加載")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { exp.fulfill() }
        wait(for: [exp], timeout: 1)
        
        // Attempt to find the remove button for the photo.
        // We search for a Button whose label contains an Image with systemName "xmark.circle.fill"
        let removeButton = try view.inspect().find(viewWithAccessibilityIdentifier: "removePhotoButton").button()
        try removeButton.tap()
        
        // Verify that the photo was removed from the photos array.
        XCTAssertFalse(photos.contains("testPhoto"), "The photo should be removed from photos")
        
        // Verify that the photo was added to the deletedPhotos array.
        XCTAssertTrue(deletedPhotos.contains("testPhoto"), "The photo should be added to deletedPhotos")
        
        // Verify that the analytics event "photo_removed" was fired with the correct parameter.
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "photo_removed" &&
            ($0.parameters?["photo_name"] as? String) == "testPhoto"
        }), "Tapping the remove button should trigger photo_removed event with the photo name")
    }
}
