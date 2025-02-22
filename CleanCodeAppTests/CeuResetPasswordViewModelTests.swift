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

    func handleResetPasswordRequestSuccess() {
        handleResetPasswordRequestSuccessWasCalled = true
    }
    
    func handleResetPasswordRequestError() {
        handleResetPasswordRequestErrorWasCalled = true
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

class CeuResetPasswordViewModelTests: XCTestCase {
    var ceuResetPasswordViewModelDelegateMock: CeuResetPasswordViewModelDelegateMock?
    var ceuResetPasswordServiceMock: CeuResetPasswordServiceMock?
    var sut: CeuResetPasswordViewModelProtocol?

    override func setUp() {
        ceuResetPasswordViewModelDelegateMock = CeuResetPasswordViewModelDelegateMock()
        ceuResetPasswordServiceMock = CeuResetPasswordServiceMock()
        guard let ceuResetPasswordServiceMock = ceuResetPasswordServiceMock else {
            return XCTFail("resetPasswordServiceMock should be valid.")
        }
        sut = CeuResetPasswordViewModel(resetPasswordService: ceuResetPasswordServiceMock)
        sut?.delegate = ceuResetPasswordViewModelDelegateMock
    }

    override func tearDown() {
        ceuResetPasswordViewModelDelegateMock = nil
        ceuResetPasswordServiceMock = nil
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

    }

    func test_when_makeResetPasswordRequest_return_error_handleResetPasswordRequestError_should_be_called() {
        // Given
        ceuResetPasswordServiceMock?.shouldReturnError = true
        let exp = expectation(description: "request done")

        // When
        sut?.startRecoverPasswordWith(email: nil)

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        // Then
        XCTAssertEqual(self.ceuResetPasswordServiceMock?.wasCalled, true)
        XCTAssertEqual(self.ceuResetPasswordViewModelDelegateMock?.handleResetPasswordRequestErrorWasCalled, true)
    }

    func test_when_makeResetPasswordRequest_return_success_handleResetPasswordRequestSuccess_should_be_called() async {
        // Given
        ceuResetPasswordServiceMock?.shouldReturnError = false
        let exp = expectation(description: "request done")

        // When
        sut?.startRecoverPasswordWith(email: "jorge@devsprint.com")

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)

        // Then
        XCTAssertEqual(ceuResetPasswordServiceMock?.wasCalled, true)
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock?.handleResetPasswordRequestSuccessWasCalled, true)
    }
}
