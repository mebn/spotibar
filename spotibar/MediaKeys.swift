//
//  MediaKeys.swift
//  spotibar
//
//  Created by Marcus Nilszén on 2021-06-01.
//

import Cocoa

public class MediaKeys: NSObject, EventTapDelegate {
    private var eventTap: EventTap?
    public var delegate: MediaKeysDelegate?

    public init(delegate: MediaKeysDelegate? = nil) {
        self.delegate = delegate
        super.init()
        createEventTap()
    }

    private func createEventTap() {
        let systemEvents: CGEventMask = 16384
        eventTap = EventTap(delegate: self, eventsOfInterest: systemEvents)
    }

    func eventTap(_ tap: EventTap!, shouldIntercept event: CGEvent!) -> Bool {
        guard let delegate = self.delegate else { return false }
        guard let cocoaEvent = NSEvent(cgEvent: event) else { return false }
        
        let keyCode = Int32(cocoaEvent.data1 & 0xffff0000) >> 16
        let keyFlags = (cocoaEvent.data1 & 0x0000ffff)
        let keyState = ((keyFlags & 0xff00) >> 8) == 0xA
        
        guard keyState else { return false }
        return delegate.mediaKeys(self, shouldInterceptKeyWithKeyCode: keyCode)
    }
}

public protocol MediaKeysDelegate {
    func mediaKeys(_ mediaKeys: MediaKeys, shouldInterceptKeyWithKeyCode keyCode: Int32) -> Bool
}
