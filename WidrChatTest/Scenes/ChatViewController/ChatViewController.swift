//
//  ViewController.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import ChattoAdditions
import RxCocoa
import RxSwift
import UIKit

class ChatViewController: BaseChatViewController {

    private let disposeBag = DisposeBag()

    var dataSource: ChatDataSource?

    var viewModel: ChatViewModelType? {
        didSet {
            if isViewLoaded {
                setupBindings()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chatDataSource = dataSource

        setupBindings()
        viewModel?.loadMessages()
    }

    private func setupBindings() {
        guard let viewModel = viewModel else { return }

        viewModel.messagesRelay.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (messages) in
            self?.dataSource?.update(with: messages)

        }).disposed(by: disposeBag)
    }

    // MARK: - Provide a input view

    var chatInputPresenter: BasicChatInputBarPresenter!

    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        chatInputView.maxCharactersCount = 500

        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Message", comment: "")
        appearance.textInputAppearance.font = UIFont.systemFont(ofSize: 18)

        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView,
                                                             chatInputItems: self.createChatInputItems(),
                                                             chatInputBarAppearance: appearance)
        return chatInputView
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.viewModel?.send(text: text)
        }
        return item
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)

        item.photoInputHandler = { [weak self] image, _ in
            self?.viewModel?.send(image: image)
        }
        return item
    }

    // MARK: - Map messages to presenters

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        return [Message.textMessageType: [TextMessagePresenterBuilder()],
                Message.photoMessageType: [PhotoMessagePresenterBuilder()],
                DateSeparatorModel.chatItemType: [DateSeparatorPresenterBuilder()],
                TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
                MessageStatusSeparatorModel.chatItemType: [MessageStatusPresenterBuilder()]]
    }
}
