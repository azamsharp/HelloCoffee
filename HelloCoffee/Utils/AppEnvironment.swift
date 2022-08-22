

import Foundation


enum Endpoints {
    case allOrders
    case placeOrder
    case updateOrder(Int)
    case deleteOrder(Int)
    
    var path: String {
        switch self {
            case .allOrders:
                return "/test/orders"
            case .placeOrder:
                return "/test/new-order"
            case .deleteOrder(let orderId):
                return "/test/orders/\(orderId)"
            case .updateOrder(let orderId):
                return "/test/orders/\(orderId)"
        }
    }
}

enum AppEnvironment: String {
    case dev
    case test
    
    // test and dev URLS will be completly different
    var baseURL: URL {
        switch self {
            case .dev:
                return URL(string: "https://island-bramble.glitch.me")!
            case .test:
                return URL(string: "https://island-bramble.glitch.me")!
        }
    }
}

struct Configuration {
    
    lazy var environment: AppEnvironment = {
        
        // read value from the environment variable
        guard let env = ProcessInfo.processInfo.environment["ENV"] else {
            print("DEV")
            return AppEnvironment.dev
        }
        
        if env == "TEST" {
            print("TEST")
            return AppEnvironment.test
        }
        
        return AppEnvironment.dev
    }()
    
}
