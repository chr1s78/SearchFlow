//
//  ViewModel.swift
//  SearchFlow
//
//  Created by Chr1s on 2021/10/4.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var listData: StockInfo?
    
    @Published var isSearch: Bool = false
    
    @Published var text: String = ""
    
    var searchPublisher = PassthroughSubject<String, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        DispatchQueue.global().async {
            IOSHttpServer.shared.beginListen()
        }
        
        searchPublisher
            .flatMap { searchContent in
                return self.search2(searchContent)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] searchResult in
                self?.listData = searchResult
            }
            .store(in: &cancellable)

    }
    
    // MARK: - replaceError type
    public func search(_ text: String) -> AnyPublisher<StockInfo, Error> {
        
        let url = URL(string:  "http://[::1]:8083/api/v2/users?search=" + text)
        guard let url = url else {
            return Fail(error: APIError.badURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(2)
            .map { $0.data }
            .decode(type: StockInfo.self, decoder: JSONDecoder())
            .replaceError(with: [])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - tryMap type
    public func search2(_ text: String) -> AnyPublisher<StockInfo, Error> {
        
        let url = URL(string:  "http://[::1]:8083/api/v2/users?search=" + text)
        guard let url = url else {
            return Fail(error: APIError.badURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(2)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    return .badNetwork(error: error)
                case is DecodingError:
                    return .badDecode
                default:
                    return error as? APIError ?? .unknown
                }
            }
            .decode(type: StockInfo.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    enum APIError: Error, CustomStringConvertible {
       
        var description: String {
            switch self {
            case .badURL:
                return "_URL Invalided_"
            case .badNetwork(error: let error):
                return "_network error: \(error)_"
            case .badDecode:
                return "_decode error_"
            case .unknown:
                return "_unknown error_"
            }
        }
        
        case badURL
        case badNetwork(error: Error)
        case badDecode
        case unknown
        
    }
}
