//
//  UIControlPublisher.swift
//  CombineWithUIKit
//
//  Created by chunxi on 2020/2/28.
//  Copyright © 2020 chunxi. All rights reserved.
//

import UIKit
import Combine

struct UIControlPublish<Control: UIControl>: Publisher {
    
    typealias Output = Control
    
    typealias Failure = Never
    
    let control: Control
    
    let controlEvent: UIControl.Event
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControlPublish.Failure, S.Input == UIControlPublish.Output {
        let subscription = UIControlSubscription.init(subscriber: subscriber, control: control, event: controlEvent)
        subscriber.receive(subscription: subscription)
    }
}

final class UIControlSubscription<SubscribeType: Subscriber, Control: UIControl>: Subscription where SubscribeType.Input == Control {
    var subscriber: SubscribeType?
    let control: Control
    let event: UIControl.Event
    
    init(subscriber: SubscribeType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.event = event
        self.control.addTarget(self, action: #selector(eventAction), for: event)
    }
    
    func request(_ demand: Subscribers.Demand) {
         
    }
    
    func cancel() {
        subscriber = nil
    }
    
    @objc private func eventAction() {
        _ = subscriber?.receive(control)
    }
    
    deinit {
        print("UIControlSubscription deinit")
    }
}


protocol CombineCapicity {
}

extension UIControl: CombineCapicity {}

extension CombineCapicity where Self: UIControl {
    func publisherEvent(_ event: UIControl.Event) -> UIControlPublish<Self> {
        UIControlPublish.init(control: self, controlEvent: event)
    }
}

extension CombineCapicity where Self: UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        UIControlPublish.init(control: self, controlEvent: .editingChanged).map(\.text).eraseToAnyPublisher()
    }
}

