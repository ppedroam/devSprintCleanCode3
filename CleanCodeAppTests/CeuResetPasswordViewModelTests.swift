//
//  CeuResetPasswordViewModelTests.swift
//  CleanCodeAppTests
//
//  Created by Jorge de Carvalho on 21/02/25.
//

import XCTest
@testable import CleanCode

class CeuResetPasswordServiceMock: CeuResetPasswordServiceProtocol {
    var shouldReturnError = false
    var wasCalled = false

    func resetPassword(email: String?) async throws -> CleanCode.CeuResetPasswordResponse {
        wasCalled = true
        if shouldReturnError {
            throw CeuCommonsErrors.networkError
        }

        return CeuResetPasswordResponse(
            success: true,
            message: "Success Message!"
        )
    }
}

class CeuResetPasswordViewModelDelegateMock: CeuResetPasswordViewModelDelegate {
    var validateFormShouldReturnError = false
    var validateFormWasCalled = false
    var handleResetPasswordRequestSuccessWasCalled = false
    var handleResetPasswordRequestErrorWasCalled = false
    var showAlertWithWasCalled = false
    var showNoInternetConnectionAlertWasCalled = false
    var showAlertWithMessage = ""
    var onHandleResetPasswordRequestSuccess: (() -> Void)?
    var onHandleResetPasswordRequestError: (() -> Void)?


    func handleResetPasswordRequestSuccess() {
        handleResetPasswordRequestSuccessWasCalled = true
        onHandleResetPasswordRequestSuccess?()
    }
    
    func handleResetPasswordRequestError() {
        handleResetPasswordRequestErrorWasCalled = true
        onHandleResetPasswordRequestError?()
    }
    
    func validateForm() throws {
        validateFormWasCalled = true

        if validateFormShouldReturnError {
            throw CeuCommonsErrors.invalidEmail
        }
    }
    
    func showAlertWith(message: String) {
        showAlertWithWasCalled = true
        showAlertWithMessage = message
    }
    
    func showNoInternetConnectionAlert() {
        showNoInternetConnectionAlertWasCalled = true
    }
}

class ConnectivityManagerMock: ConnectivityManagerProxy {
    var shouldReturnIsConnected = true
    var wasCalled = false

    var isConnected: Bool {
        wasCalled = true
        return shouldReturnIsConnected
    }


}

class CeuResetPasswordViewModelTests: XCTestCase {
    var ceuResetPasswordViewModelDelegateMock: CeuResetPasswordViewModelDelegateMock?
    var ceuResetPasswordServiceMock: CeuResetPasswordServiceMock?
    var connectivityManagerMock: ConnectivityManagerMock?
    var sut: CeuResetPasswordViewModelProtocol?

    override func setUp() {
        ceuResetPasswordViewModelDelegateMock = CeuResetPasswordViewModelDelegateMock()
        ceuResetPasswordServiceMock = CeuResetPasswordServiceMock()
        connectivityManagerMock = ConnectivityManagerMock()
        guard let ceuResetPasswordServiceMock = ceuResetPasswordServiceMock, let connectivityManagerMock = connectivityManagerMock else {
            return XCTFail("resetPasswordServiceMock should be valid.")
        }
        sut = CeuResetPasswordViewModel(resetPasswordService: ceuResetPasswordServiceMock, connectivityManager: connectivityManagerMock)
        sut?.delegate = ceuResetPasswordViewModelDelegateMock
    }

    override func tearDown() {
        ceuResetPasswordViewModelDelegateMock = nil
        ceuResetPasswordServiceMock = nil
        connectivityManagerMock = nil
        sut = nil
    }

    func test_startRecoverPasswordWith_should_call_showAlertWith_function_when_validateForm_return_error() {
        // Given
        ceuResetPasswordViewModelDelegateMock?.validateFormShouldReturnError = true

        // When
        sut?.startRecoverPasswordWith(email: nil)

        // Then
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock?.showAlertWithMessage, CeuResetPasswordStrings.verifyEmailErrorMessage.localized())
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock?.showAlertWithWasCalled, true)
    }

    // TODO: Create mock to ConnectivityManager
    func test_startRecoverPasswordWith_should_call_showAlertWith_function_when_verifyInternetConnection_return_error() {
        // Given
        connectivityManagerMock?.shouldReturnIsConnected = false

        // When
        sut?.startRecoverPasswordWith(email: "jorge@devsprint.com")

        // Then
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock?.showNoInternetConnectionAlertWasCalled, true)
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock?.showAlertWithWasCalled, true)
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock?.showAlertWithMessage, CeuResetPasswordStrings.somethingWentWrongErrorMessage.localized())
    }

    func test_when_makeResetPasswordRequest_return_error_handleResetPasswordRequestError_should_be_called() {
        // Given
        ceuResetPasswordServiceMock?.shouldReturnError = true
        let expectation = expectation(description: "request resetPassword done")

        ceuResetPasswordViewModelDelegateMock?.onHandleResetPasswordRequestError = {
            expectation.fulfill()
        }

        // When
        sut?.startRecoverPasswordWith(email: nil)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertEqual(self.ceuResetPasswordServiceMock?.wasCalled, true)
        XCTAssertEqual(self.ceuResetPasswordViewModelDelegateMock?.handleResetPasswordRequestErrorWasCalled, true)
    }

    func test_when_makeResetPasswordRequest_return_success_handleResetPasswordRequestSuccess_should_be_called() {
        // Given
        ceuResetPasswordServiceMock?.shouldReturnError = false
        let exp = expectation(description: "request done")

        ceuResetPasswordViewModelDelegateMock?.onHandleResetPasswordRequestSuccess = {
            exp.fulfill()
        }

        // When
        sut?.startRecoverPasswordWith(email: "jorge@devsprint.com")

        wait(for: [exp], timeout: 1)

        // Then
        XCTAssertEqual(ceuResetPasswordServiceMock?.wasCalled, true)
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock?.handleResetPasswordRequestSuccessWasCalled, true)
    }
}
