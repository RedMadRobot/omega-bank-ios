//
//  AuthServiceTest.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 3/31/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import OmegaBankAPI
import XCTest

final class AuthServiceTest: XCTestCase {
    
    private var authService: AuthService!
    private var apiClient: MockClient!
    private var accessTokenStorage: MockAccessTokenStorage!
    private var baseURL = URL(string: "/")!

    override func setUp() {
        super.setUp()
        accessTokenStorage = MockAccessTokenStorage()
        apiClient = MockClient()
        authService = AuthService(
            apiClient: apiClient,
            accessTokenStorage: accessTokenStorage,
            baseURL: { [unowned self] in self.baseURL })
    }

    func testSendPhoneNumber() throws {
        var error: Error? = makeError()
        _ = authService.sendPhoneNumber(phone: "\(8_888_888_88_88)") { error = $0 }
        let endpoint = try XCTUnwrap(apiClient.fulfil(SendPhoneEndpoint.self, with: ()))
        
        XCTAssertEqual(endpoint.phoneNumber, "\(8_888_888_88_88)")
        XCTAssertNil(error)
        
    }
    
    func testSendPhoneNumberWithNetworkError() throws {
        var error: Error?
        _ = authService.sendPhoneNumber(phone: "\(8_888_888_88_88)") { error = $0 }
        let endpoint = try XCTUnwrap(apiClient.fail(SendPhoneEndpoint.self, with: URLError(.badServerResponse)))
        
        XCTAssertEqual(endpoint.phoneNumber, "\(8_888_888_88_88)")
        XCTAssertNotNil(error)
        
    }
    
    func testCheckSmsCodeEndpoint() {
        var error: Error? = makeError()
        _ = authService.checkSmsCode(smsCode: "\(9999)") { error = $0 }
        let authData = makeAuthData(accessToken: "x", refreshToken: "x")
        let endpoint = apiClient.fulfil(CheckSmsCodeEndpoint.self, with: authData)
        
        XCTAssertEqual(endpoint?.smsCode, "\(9999)")
        XCTAssertEqual(accessTokenStorage.accessToken, authData.accessToken)
        XCTAssertEqual(apiClient.accessToken, authData.refreshToken)
        XCTAssertTrue(authService.isAuthorized)
        XCTAssertNil(error)
    }
    
    func testCheckSmsCodeEndpointWithNetworkError() {
        var error: Error? = makeError()
        _ = authService.checkSmsCode(smsCode: "\(9999)") { error = $0 }
        let endpoint = apiClient.fail(
            CheckSmsCodeEndpoint.self,
            with: URLError(.badServerResponse))
        
        XCTAssertEqual(endpoint?.smsCode, "\(9999)")
        XCTAssertNil(accessTokenStorage.accessToken)
        XCTAssertNil(apiClient.accessToken)
        XCTAssertFalse(authService.isAuthorized)
        XCTAssertNotNil(error)
    }
    
    func testCheckSmsCodeEndpointWithStorageError() {
        var error: Error?
        accessTokenStorage.saveError = makeError()
        _ = authService.checkSmsCode(smsCode: "\(9999)") { error = $0 }
        let authData = makeAuthData(accessToken: "x", refreshToken: "x")
        let endpoint = apiClient.fulfil(CheckSmsCodeEndpoint.self, with: authData)
        
        XCTAssertEqual(endpoint?.smsCode, "\(9999)")
        XCTAssertNil(accessTokenStorage.accessToken)
        XCTAssertNil(apiClient.accessToken)
        XCTAssertFalse(authService.isAuthorized)
        XCTAssertNotNil(error)
    }
    
    func testReset() {
        accessTokenStorage.accessToken = "nt"
        baseURL = URL(string: "https://nt.com")!
        
        authService.restore()
        
        XCTAssertEqual(apiClient.accessToken, "nt")
        XCTAssertEqual(apiClient.baseURL, URL(string: "https://nt.com")!)
    }

    // MARK: - Private

    private func makeError() -> Error {
        NSError(domain: "ErrorStubDomain", code: 0)
    }
    
    private func makeAuthData(accessToken: String, refreshToken: String) -> AuthData {
        AuthData(accessToken: accessToken, refreshToken: refreshToken)
    }
}

// MARK: - Mock

private final class MockAccessTokenStorage: AccessTokenStorage {

    var saveError: Error?

    // MARK: - AccessTokenStorage

    var accessToken: String?

    func setAccessToken(_ token: String?) throws {
        if let error = saveError {
            throw error
        }
        accessToken = token
    }
}
