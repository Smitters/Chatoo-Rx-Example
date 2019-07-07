//
//  ChatViewModel.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import RxCocoa
import RxSwift
import Chatto

protocol ChatViewModelType {
    var chatItemsRelay: BehaviorRelay<[TimedChatItem]> { get }
    var userRelay: BehaviorRelay<User?> { get }

    func loadData()

    func send(text: String)
    func send(image: UIImage)

    func select(photo: UIImage)
}

class ChatViewModel: ChatViewModelType {

    private let coordinator: ChatCoordinatorType
    private let model: ChatModelType
    private let disposeBag = DisposeBag()

    var chatItemsRelay: BehaviorRelay<[TimedChatItem]> = BehaviorRelay(value: [])

    init(coordinator: ChatCoordinatorType, model: ChatModelType) {
        self.coordinator = coordinator
        self.model = model

        Observable.combineLatest(model.messagesRelay, model.callsRelay) { (messages, calls) -> [TimedChatItem] in
            var resultArray: [TimedChatItem] = messages + calls
            resultArray.sort(by: { $0.time < $1.time })
            return resultArray
        }.bind(to: chatItemsRelay).disposed(by: disposeBag)

        //model.messagesRelay.map{ $0 }.bind(to: chatItemsRelay).disposed(by: disposeBag)
    }

    var userRelay: BehaviorRelay<User?> {
        return model.userRelay
    }

    func loadData() {
        model.loadMessages()
        model.loadCalls()
        model.loadUser()
    }

    func send(text: String) {
        model.send(text: text)
    }

    func send(image: UIImage) {
        model.send(image: image)
    }

    func select(photo: UIImage) {
        coordinator.showPhoto(photo)
    }
}
