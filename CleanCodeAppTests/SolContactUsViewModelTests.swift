import XCTest
@testable import CleanCode

class MockSolContactUsViewController: SolContactUsViewControllerProtocol {
    var loadingViewCalled = false
    var removeLoadingViewCalled = false
    var showMessageReturnModelCalled = false
    var alertMessageCalled = false
    var globalAlertMessageCalled = false
    
    func callLoadingView() {
        loadingViewCalled = true
    }
    
    func callRemoveLoadingView() {
        removeLoadingViewCalled = true
    }
    
    func showMessageReturnModel(result: ContactUsModel) {
        showMessageReturnModelCalled = true
    }
    
    func displayAlertMessage(title: String, message: String, dissmiss: Bool) {
        alertMessageCalled = true
    }
    
    func displayGlobalAlertMessage() {
        globalAlertMessageCalled = true
    }
}

class MockSolNetworkManager: Networking {
    var requestResult: Result<Data, Error>?
    
    func request(_ url: String, method: Methods, parameters: [String: String]?, headers: [String: String]?, completion: @escaping ((Result<Data, Error>) -> Void)) {
        if let result = requestResult {
            completion(result)
        }
    }
}

class SolContactUsViewModelTests: XCTestCase {
    
    var viewModel: SolContactUsViewModel!
    var mockViewController: MockSolContactUsViewController!
    var mockNetworkManager: MockSolNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockViewController = MockSolContactUsViewController()
        mockNetworkManager = MockSolNetworkManager()
        viewModel = SolContactUsViewModel(networkManager: mockNetworkManager)
        viewModel.viewController = mockViewController
    }
    
    override func tearDown() {
        viewModel = nil
        mockViewController = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testFetchContactDataSuccess() {
        let contactUsModel = ContactUsModel(whatsapp: "37998988822", phone: "08001234567", mail: "cleanCode@devPass.com")
        let data = try! JSONEncoder().encode(contactUsModel)
        mockNetworkManager.requestResult = .success(data)
        
        viewModel.fetchContactData()
        
        XCTAssertTrue(mockViewController.loadingViewCalled, "Loading view should be called")
        XCTAssertTrue(mockViewController.removeLoadingViewCalled, "Remove loading view should be called")
        XCTAssertTrue(mockViewController.showMessageReturnModelCalled, "Show message should be called")
    }
    
    func testFetchContactDataFailure() {
        mockNetworkManager.requestResult = .failure(ServiceErros.invalidData)
        
        viewModel.fetchContactData()
        
        XCTAssertTrue(mockViewController.loadingViewCalled, "Loading view should be called")
        XCTAssertTrue(mockViewController.removeLoadingViewCalled, "Remove loading view should be called")
        XCTAssertTrue(mockViewController.alertMessageCalled, "Alert message should be called")
    }
    
    func testRequestSendMessageSuccess() {
        let parameters: [String: String] = ["message": "Test Message"]
        mockNetworkManager.requestResult = .success("sucesso".data(using: .utf8)!)
        
        viewModel.requestSendMessage(parameters: parameters)
        
        XCTAssertTrue(mockViewController.removeLoadingViewCalled, "Remove loading view should be called")
        XCTAssertTrue(mockViewController.alertMessageCalled, "Alert message should be called")
    }
    
    func testRequestSendMessageFailure() {
        
        let parameters: [String: String] = ["message": "Test Message"]
        mockNetworkManager.requestResult = .failure(ServiceErros.invalidData)
        
        viewModel.requestSendMessage(parameters: parameters)
        
        XCTAssertTrue(mockViewController.removeLoadingViewCalled, "Remove loading view should be called")
        XCTAssertTrue(mockViewController.globalAlertMessageCalled, "Global alert message should be called")
    }
}
