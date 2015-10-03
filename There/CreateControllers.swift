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

enum CreateController {
    case Text(String)
    case Image(String)
    case Video(String)
    case Audio(String)
    
    func instance() -> CreateEntryViewController? {
        return UIViewController.viewControllerWithIdentifier(identifier(), inStoryboard: storyboard()) as? CreateEntryViewController
    }
    
    private func storyboard() -> String {
        switch self {
            case .Text(let sb): return sb
            case .Image(let sb): return sb
            case .Video(let sb): return sb
            case .Audio(let sb): return sb
        }
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