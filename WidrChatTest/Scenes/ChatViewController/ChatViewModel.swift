//
//  ChatViewModel.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ChatViewModelType {
    var messagesRelay: BehaviorRelay<[Message]> { get }

    func loadMessages()
    func send(text: String)
    func send(image: UIImage)
}

class ChatViewModel: ChatViewModelType {

    private let coordinator: ChatCoordinatorType
    private let model: ChatModelType
    private let disposeBag = DisposeBag()

    var messagesRelay: BehaviorRelay<[Message]> = BehaviorRelay(value: [])

    init(coordinator: ChatCoordinatorType, model: ChatModelType) {
        self.coordinator = coordinator
        self.model = model

        model.messagesRelay.bind(to: messagesRelay).disposed(by: disposeBag)
    }

    func loadMessages() {
        model.loadMessages()
    }

    func send(text: String) {
        model.send(text: text)
    }

    func send(image: UIImage) {
        model.send(image: image)
    }
}


