//
//  SocketService.swift
//  airbarknbark
//
//  Created by Pujan Shrestha on 05/12/2022.
//

import Foundation

import SocketIO
import RxRealm
import RxSwift
import RealmSwift

class SocketService {
    
    static let shared = SocketService()
    private let manager:SocketManager = SocketManager(socketURL: URL(string: Config.SOCKET_URL)!)
    
    private lazy var socket = manager.defaultSocket
        
    var conversationRepository = ConversationRepositoryImp()
    
    private init() {
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("new-message") { [self] data, ack in
            print(data)
            conversationRepository.handleSocketNewMessageEvent(data: data)
        }
    
        socket.on(clientEvent: .error){ data, ack in
            print("socket error", data)
        }
        
        SessionManager.shared.addSessionUpdateListner(key: String(describing: self),listner: onSessionUpdated)
        socket.disconnect()
    }
    
    func onSessionUpdated(event:SessionUpdateEvent){
        switch(event){
        case .LoggedOut:
            disconnect();
            break
        case .LoggedIn(_, _, accessToken: let accessToken):
            connect(accessToken: accessToken)
        }
    }
    
    func connect(accessToken:String? = SessionManager.shared.accessToken) {
        if let accessToken = accessToken {
            manager.config = getSocketConfig(accessToken: accessToken)
            socket.connect()
        }
    }
    
    func disconnect() {
        manager.disconnect()
        socket.disconnect()
    }
        
    private func getSocketConfig(accessToken:String) -> SocketIOClientConfiguration {
        return [
            .log(true),
            .reconnects(true),
            .reconnectWait(3),
            .extraHeaders(["authorization":accessToken]),
            .forceNew(true)
        ]
    }
}
