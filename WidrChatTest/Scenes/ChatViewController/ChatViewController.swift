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
        dataSource?.delegate = self

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
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 500
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
        let textMessagePresenterBuilder = TextMessagePresenterBuilder()
        return [Message.textMessageType: [textMessagePresenterBuilder]]
    }
}
