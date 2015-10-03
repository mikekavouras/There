//
//  CreateControllers.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

struct CreateControllerType {
    static let Text = "CreateTextEntryViewController"
    static let Image = "CreateImageEntryViewController"
    static let Video = "CreateVideoEntryViewController"
    static let Audio = "CreateAudioEntryViewController"
}

enum CreateControllers: Int {
    case Text
    case Image
    case Video
    case Audio
    
    func instance() -> CreateEntryViewController? {
        return UIViewController.viewControllerWithIdentifier(identifier(), inStoryboard: "Main") as? CreateEntryViewController
    }
    
    private func identifier() -> String {
        switch self {
        case .Text: return CreateControllerType.Text
        case .Image: return CreateControllerType.Image
        case .Video: return CreateControllerType.Video
        case .Audio: return CreateControllerType.Audio
        }
    }
}