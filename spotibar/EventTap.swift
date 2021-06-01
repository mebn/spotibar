//
//  EventTap.swift
//  spotibar
//
//  Created by Marcus Nilszén on 2021-06-01.
//

import Foundation

class EventTap {
    private let delegate: EventTapDelegate

    init(delegate: EventTapDelegate, eventsOfInterest: CGEventMask) {
        self.delegate = delegate
        beginObservingEvents(withMask: eventsOfInterest)
    }

    private func beginObservingEvents(withMask mask: CGEventMask) {
        let tapPointer = UnsafeMutableRawPointer(
            Unmanaged.passUnretained(self).toOpaque())
        
        let eventPort = CGEvent.tapCreate(tap: .cgSessionEventTap,
              place: .headInsertEventTap,
              options: .defaultTap,
              eventsOfInterest: mask,
              callback: callback,
              userInfo: tapPointer)
            
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorSystemDefault, eventPort, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
    }

    private let callback: CGEventTapCallBack = { (proxy, type, event, refcon) in
        let tap = Unmanaged<EventTap>.fromOpaque(refcon!).takeUnretainedValue()
        
        if tap.delegate.eventTap(tap, shouldIntercept: event) {
            return nil
        } else {
            return Unmanaged.passUnretained(event)
        }
    }
}

protocol EventTapDelegate {
    func eventTap(_ tap: EventTap!, shouldIntercept event: CGEvent!) -> Bool
}
