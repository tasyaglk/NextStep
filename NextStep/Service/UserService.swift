import Foundation
import Alamofire
import Combine

enum UserDefaultsKeys: String {
    case userLoggedIn
    case userID
}

class UserService {
    static var isLoggedIn: Bool {
        get {
            getValue(for: .userLoggedIn) ?? false
        }
        set {
            setValue(value: newValue, for: .userLoggedIn)
        }
    }
    
    static var userID: Int {
        get {
            getValue(for: .userID) ?? 1
        }
        set {
            setValue(value: newValue, for: .userID)
        }
    }
    
    static func login(email: String, password: String, completion: @escaping (UserProfile?) -> Void) {
        let url = "http://localhost:8080/login"
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserProfile.self) { response in
                switch response.result {
                case .success(let user):
                    saveUserInfo(userInfo: user)
                    completion(user)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil)
                }
            }
    }
    
    static func login(email: String, password: String) -> AnyPublisher<UserProfile, Error> {
        let url = "http://localhost:8080/login"
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .publishDecodable(type: UserProfile.self)
            .value()
            .handleEvents(receiveOutput: { user in
                saveUserInfo(userInfo: user)
            })
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    static func register(name: String, surname: String, email: String, password: String, completion: @escaping (Int?) -> Void) {
        let url = "http://localhost:8080/register"
        let parameters: [String: String] = [
            "name": name,
            "surname": surname,
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Int], let userId = json["id"] {
                        completion(userId)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil)
                }
            }
    }
    
    static func register(name: String, surname: String, email: String, password: String) -> AnyPublisher<Int, Error> {
        let url = "http://localhost:8080/register"
        let parameters: [String: String] = [
            "name": name,
            "surname": surname,
            "email": email,
            "password": password
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let json = try JSONSerialization.jsonObject(with: response.data ?? Data()) as? [String: Int],
                      let userId = json["id"] else {
                    throw AFError.responseValidationFailed(reason: .dataFileNil)
                }
                return userId
            }
            .eraseToAnyPublisher()
    }
    
    static func deleteUser(userID: Int) async throws -> (data: Data, response: URLResponse) {
        let url = "http://localhost:8080/users/\(userID)"
        
        let response = await AF.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .serializingData()
            .response
        
        switch response.result {
        case .success(let data):
            return (data, response.response ?? URLResponse())
        case .failure(let error):
            throw error
        }
    }
    
    static func saveUserInfo(userInfo: UserProfile) {
        if let data = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
        self.isLoggedIn = true
        self.userID = userInfo.id
    }
    
    static func saveUserInfo(name: String, surname: String, email: String, id: Int) {
        let user = UserProfile(id: id, name: name, surname: surname, email: email)
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
        self.isLoggedIn = true
        self.userID = id
    }
}

extension UserService {
    
    fileprivate static func setValue<T>(value: T, for key: UserDefaultsKeys) {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        }
    
    fileprivate static func getValue<T>(for key: UserDefaultsKeys) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}
