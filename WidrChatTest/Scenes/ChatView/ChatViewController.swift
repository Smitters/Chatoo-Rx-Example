//
//  ViewController.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import Chatto
import ChattoAdditions
import RxSwift
import UIKit

class ChatViewController: BaseChatViewController {

    private var headerView: HeaderView?
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
        setupUI()
        chatDataSource = dataSource

        setupBindings()
        viewModel?.loadMessages()
        viewModel?.loadUser()
    }

    private func setupUI() {
        navigationController?.navigationBar.isHidden = true

        // Remove old collectionView constraint (they doesn't respect safe area)
        // Details: https://github.com/badoo/Chatto/issues/550
        let constraints = view.constraints.filter { $0.firstItem === collectionView || $0.secondItem === collectionView }
        constraints.forEach { $0.isActive = false }

        // Add new constraints to respect safe area and Header View

        collectionView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // Add header view
        let nib = UINib(nibName: "HeaderView", bundle: .main)
        if let headerView = nib.instantiate(withOwner: nil, options: nil).first as? HeaderView {
            headerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(headerView)

            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            headerView.heightAnchor.constraint(equalToConstant: 130).isActive = true
            collectionView?.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            self.headerView = headerView
        }
    }

    private func setupBindings() {
        guard let viewModel = viewModel else { return }

        viewModel.messagesRelay.observeOn(MainScheduler.instance).bind { [weak self] (messages) in
            self?.dataSource?.update(with: messages)
        }.disposed(by: disposeBag)

        viewModel.userRelay.observeOn(MainScheduler.instance).bind { [weak self] user in
            self?.headerView?.avatarImageView.image = user?.avatar
            self?.headerView?.userNameLabel.text = user?.fullName
        }.disposed(by: disposeBag)
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
                                                             chatInputItems: createChatInputItems(),
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
        item.textInputHandler = { [unowned self] text in
            self.viewModel?.send(text: text)
        }
        return item
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [unowned self] image, _ in
            self.viewModel?.send(image: image)
        }
        return item
    }

    // MARK: - Map messages to presenters

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        let photoMessagePresenterBuilder = PhotoMessagePresenterBuilder { [unowned self] photo in
            self.viewModel?.select(photo: photo)
        }

        return [Message.textMessageType: [TextMessagePresenterBuilder()],
                Message.photoMessageType: [photoMessagePresenterBuilder],
                DateSeparatorModel.chatItemType: [DateSeparatorPresenterBuilder()],
                TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
                MessageStatusSeparatorModel.chatItemType: [MessageStatusPresenterBuilder()]]
    }
}
