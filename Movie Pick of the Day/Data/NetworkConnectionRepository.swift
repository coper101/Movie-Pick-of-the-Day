//
//  NetworkConnectionRepository.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 22/2/23.
//

import Combine
import Network
import OSLog

// MARK: Protocol
protocol NetworkConnectivity {
    var hasInternetConnection: Bool { get set }
    var hasInternetConnectionPublisher: Published<Bool>.Publisher { get }
}

// MARK: App Implementation
final class NetworkConnectionRepository: ObservableObject, NetworkConnectivity {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    @Published var wifiStatus: NWPath.Status? = nil
    @Published var celullarStatus: NWPath.Status? = nil
    @Published var wiredEthernetStatus: NWPath.Status? = nil
    
    @Published var hasInternetConnection: Bool = false
    var hasInternetConnectionPublisher: Published<Bool>.Publisher { $hasInternetConnection }
    
    private let monitorWifi = NWPathMonitor(requiredInterfaceType: .wifi)
    private let monitorCellular = NWPathMonitor(requiredInterfaceType: .cellular)
    private let monitorWiredEthernet = NWPathMonitor(requiredInterfaceType: .wiredEthernet)
    
    init() {
        startMonitoring()
        observeInternetConnection()
    }
    
    func startMonitoring() {
        monitorWifi.pathUpdateHandler = {
            self.wifiStatus = $0.status
        }
        monitorCellular.pathUpdateHandler = {
            self.celullarStatus = $0.status
        }
        monitorWiredEthernet.pathUpdateHandler = {
            self.wiredEthernetStatus = $0.status
        }
        monitorWifi.start(queue: .main)
        monitorCellular.start(queue: .main)
        monitorWiredEthernet.start(queue: .main)
    }
    
    func observeInternetConnection() {
        $wifiStatus
            .combineLatest($celullarStatus, $wiredEthernetStatus)
            .sink { [weak self] (wifiStatus, celullarStatus, wiredEthernetStatus) in
                Logger.network.debug("wifi status: \(wifiStatus.debugDescription), cellular status: \(celullarStatus.debugDescription), wired ethernet status: \(wiredEthernetStatus.debugDescription)" )
                
                let hasInternet =
                    (wifiStatus == .satisfied) ||
                    (celullarStatus == .satisfied) ||
                    (wiredEthernetStatus == .satisfied)
                
                self?.hasInternetConnection = hasInternet
            }
            .store(in: &cancellables)
    }
    
    
}

