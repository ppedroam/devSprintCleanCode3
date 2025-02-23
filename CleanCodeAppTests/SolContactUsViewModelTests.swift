import XCTest
@testable import CleanCode

class MockSolContactUsProtocol: SolContactUsProtocol {
    var didCallLoadingView = false
    var didCallRemoveLoadingView = false
    var didShowMessageReturnModel = false
    var alertTitle: String?
    var alertMessage: String?
    
    func callLoadingView() {
        didCallLoadingView = true
    }
    
    func callRemoveLoadingView() {
        didCallRemoveLoadingView = true
    }
    
    func showMessageReturnModel(result: ContactUsModel) {
        didShowMessageReturnModel = true
    }
    
    func displayAlertMessage(title: String, message: String, dissmiss: Bool) {
        alertTitle = title
        alertMessage = message
    }
    
    func displayGlobalAlertMessage() {
        alertTitle = "Global Alert"
        alertMessage = "Something went wrong."
    }
}


class MockNetworking: Networking {
    var requestResult: Result<Data, Error>?
    
    func request(_ url: String, method: HTTPMethod, parameters: [String : Any]?, headers: [String : String]?, completion: @escaping (Result<Data, Error>) -> Void) {
        if let result = requestResult {
            completion(result)
        }
    }
}

class SolContactUsViewModelTests: XCTestCase {

    var viewModel: SolContactUsViewModel!
    var mockViewController: MockSolContactUsProtocol!
    var mockNetworkManager: SolNetworkManager!

    override func setUp() {
        super.setUp()

        mockViewController = MockSolContactUsProtocol()
       
        mockNetworkManager = SolNetworkManager()

        viewModel = SolContactUsViewModel(networkManager: mockNetworkManager)
        viewModel.viewController = mockViewController
    }

    override func tearDown() {
        mockViewController = nil
        mockNetworkManager = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchData_WhenCalled_CallsCallLoadingView() {

        viewModel.fetchContactData()

    
        XCTAssertTrue(mockViewController.didCallLoadingView, "Expected callLoadingView to be called")
    }

  
}
