//
//  MessageService.swift
//  WidrChatTest
//
//  Created by Smetankin Dmitry on 7/6/19.
//  Copyright © 2019 Smetankin. All rights reserved.
//

import RxCocoa

protocol ChatModelType {
    var messagesRelay: BehaviorRelay<[Message]> { get }

    func loadMessages()
    func send(text: String)
    func send(image: UIImage)
}

class MockChatModel: ChatModelType {

    private var messages: [Message] = []

    var messagesRelay = BehaviorRelay<[Message]>(value: [])

    func loadMessages() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            for _ in 0...100 {
                self.messages.append(self.generateRandomMessage())
            }

            self.messages.sort(by: { (lhs: Message, rhs: Message) -> Bool in
                lhs.time < rhs.time
            })

            self.messagesRelay.accept(self.messages)
        }
    }

    func send(text: String) {
        let message = Message(content: .text(text), status: .sending, senderId: currentUserId, isIncoming: false)
        send(message: message)
    }

    func send(image: UIImage) {
        let message = Message(content: .photo(image), status: .sending, senderId: currentUserId, isIncoming: false)
        send(message: message)
    }

    private func send(message: Message) {
        messages.append(message)
        messagesRelay.accept(messages)

        // Simulate async message sending with different message statuses
        let isErrorOccured = ((1...10).randomElement() ?? 0) > 9  // 10% to the error
        if isErrorOccured {
            updateMessage(message, with: .error, afterDelay: 0.75)
        } else {
            updateMessage(message, with: .sent, afterDelay: 0.75)
            updateMessage(message, with: .delivered, afterDelay: 1.5)
            updateMessage(message, with: .read, afterDelay: 2.5)
        }
    }

    private func updateMessage(_ message: Message, with status: Message.Status, afterDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }

            message.status = status
            self.messagesRelay.accept(self.messages)
        }
    }

    private let currentUserId = UUID()
    private let otherUserId = UUID()

    private func generateRandomMessage() -> Message {
        let isMyMessage = Bool.random()
        let senderId = isMyMessage ? currentUserId : otherUserId
        let time = generateRandomTime()

        let isTextMessage = ((1...10).randomElement() ?? 0) < 9  // 90% will be text messages
        let content: Message.Content
        if isTextMessage {
            content = Message.Content.text(quotes.randomElement() ?? "")
        } else {
            content = Message.Content.photo(getRandomPhoto())
        }
        return Message(content: content,
                       status: .read,
                       senderId: senderId,
                       isIncoming: !isMyMessage,
                       time: time)
    }

    private func getRandomPhoto() -> UIImage {
        return Bool.random() ? UIImage(imageLiteralResourceName: "horizontal_example") :
                               UIImage(imageLiteralResourceName: "vertical_example")
    }

    private func generateRandomTime() -> Date {
        let daysOffset = (0...5).randomElement() ?? 0
        let daysTimeIntervalOffset: TimeInterval = -60 * 60 * 24 * TimeInterval(daysOffset)

        let hoursOffset = (0...23).randomElement() ?? 0
        let hoursTimeIntervalOffset: TimeInterval = -60 * 60 * TimeInterval(hoursOffset)

        let date = Date()
        return date.addingTimeInterval(daysTimeIntervalOffset + hoursTimeIntervalOffset)
    }

    private lazy var quotes = [
        "People say nothing is impossible, but I do nothing every day.",
        "The best thing about the future is that it comes one day at a time.",
        "The only mystery in life is why the kamikaze pilots wore helmets.",
        "Light travels faster than sound. This is why some people appear bright until you hear them speak.",
        "Nobody realizes that some people expend tremendous energy merely to be normal.",
        "Men marry women with the hope they will never change. Women marry men with the hope they will change. Invariably they are both disappointed.",
        "The difference between stupidity and genius is that genius has its limits.",
        "All the things I really like to do are either immoral, illegal or fattening.",
        "War is God’s way of teaching Americans geography.",
        "It would be nice to spend billions on schools and roads, but right now that money is desperately needed for political ads.",
        "The average dog is a nicer person than the average person.",
        "At every party there are two kinds of people – those who want to go home and those who don’t. The trouble is, they are usually married to each other.",
        "If you want your children to listen, try talking softly to someone else.",
        "Doctors are just the same as lawyers; the only difference is that lawyers merely rob you, whereas doctors rob you and kill you too.",
        "I don’t believe in astrology; I’m a Sagittarius and we’re skeptical.",
        "My opinions may have changed, but not the fact that I’m right.",
        "To be sure of hitting the target, shoot first, and call whatever you hit the target.",
        "Wine is constant proof that God loves us and loves to see us happy.",
        "Have you noticed that all the people in favor of birth control are already born?",
        "Facebook just sounds like a drag, in my day seeing pictures of peoples vacations was considered a punishment.",
        "A bank is a place that will lend you money if you can prove that you don’t need it.",
        "We never really grow up, we only learn how to act in public.",
        "He who laughs last didn’t get the joke.",
        "Don’t worry about the world coming to an end today. It is already tomorrow in Australia.",
        "When I was a boy I was told that anybody could become President. I’m beginning to believe it.",
        "Starbucks says they are going to start putting religious quotes on cups. The very first one will say, ‘Jesus! This cup is expensive!'",
        "If you think you are too small to make a difference, try sleeping with a mosquito.",
        "I was born to make mistakes, not to fake perfection.",
        "A computer once beat me at chess, but it was no match for me at kick boxing.",
        "How many people here have telekenetic powers? Raise my hand.",
        "I asked God for a bike, but I know God doesn’t work that way. So I stole a bike and asked for forgiveness.",
        "I drink to make other people more interesting."
    ]
}

