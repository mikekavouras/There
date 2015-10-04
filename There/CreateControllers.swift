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

enum StoryboardController {
    case CreateText(String)
    case CreateImage(String)
    case CreateVideo(String)
    case CreateAudio(String)
    
    func instance() -> CreateEntryViewController? {
        return UIViewController.viewControllerWithIdentifier(identifier(), inStoryboard: storyboard()) as? CreateEntryViewController
    }
    
    private func storyboard() -> String {
        switch self {
            case .CreateText(let sb): return sb
            case .CreateImage(let sb): return sb
            case .CreateVideo(let sb): return sb
            case .CreateAudio(let sb): return sb
        }
    }
    
    private func identifier() -> String {
        switch self {
            case .CreateText: return CreateControllerType.Text
            case .CreateImage: return CreateControllerType.Image
            case .CreateVideo: return CreateControllerType.Video
            case .CreateAudio: return CreateControllerType.Audio
        }
    }
}