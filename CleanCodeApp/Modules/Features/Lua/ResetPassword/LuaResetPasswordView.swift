import UIKit

class LuaResetPasswordView: UIView {
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var smokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "smoke.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var passwordRecoverySuccessView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = "Se o e-mail informado estiver cadastrado, você receberá em instantes um link de recuperação de senha. E-mail enviado para:"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var emailSentLabel: UILabel = {
        let label = UILabel()
        label.text = "email@email.com"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Informe o e-mail associado à sua conta"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 12)
        textField.textColor = .black
        textField.setDefaultColor()
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    public lazy var passwordRecoveryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("RECUPERAR SENHA", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = UIColor.defaultViolet
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.defaultViolet, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var helpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PRECISO DE AJUDA", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.defaultViolet, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CRIAR UMA CONTA", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .clear
        button.setTitleColor( UIColor.defaultViolet, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.app.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public var emailInputted: String {
        get {
            guard let emailInput = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return ""
            }
            return emailInput
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupView() {
        backgroundColor = .systemGray6
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        addSubviewsToContentView()
        addConstraintsToUIComponents()
    }
    
    private func addSubviewsToContentView() {
        [smokeImageView, passwordRecoverySuccessView, emailLabel, emailTextField, passwordRecoveryButton, closeButton].forEach { contentView.addSubview($0) }
    }
    
    private func createSuccessContentStack() -> UIStackView {
        let successContentStack = UIStackView(arrangedSubviews: [successLabel, emailSentLabel])
        successContentStack.axis = .vertical
        successContentStack.spacing = 0
        successContentStack.isLayoutMarginsRelativeArrangement = true
        successContentStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return successContentStack
    }
    
    private func createButtonsStack() -> UIStackView {
        let buttonsStack =  UIStackView(arrangedSubviews: [loginButton, helpButton, createAccountButton])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 20
        
        return buttonsStack
    }
    
    func addConstraintsToUIComponents() {
      
        let successContentStack = createSuccessContentStack()
       
        let buttonsStack = createButtonsStack()
       
        [successContentStack, buttonsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        passwordRecoverySuccessView.addSubview(successContentStack)
        contentView.addSubview(buttonsStack)

        NSLayoutConstraint.activate([
           
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            smokeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 65),
            smokeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            smokeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            smokeImageView.heightAnchor.constraint(equalToConstant: 75),
            
            passwordRecoverySuccessView.topAnchor.constraint(equalTo: smokeImageView.bottomAnchor, constant: 8),
            passwordRecoverySuccessView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordRecoverySuccessView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordRecoverySuccessView.heightAnchor.constraint(equalToConstant: 138),
            
            // Success Content Stack (replaces individual label constraints)
            successContentStack.topAnchor.constraint(equalTo: passwordRecoverySuccessView.topAnchor),
            successContentStack.leadingAnchor.constraint(equalTo: passwordRecoverySuccessView.leadingAnchor),
            successContentStack.trailingAnchor.constraint(equalTo: passwordRecoverySuccessView.trailingAnchor),
            successContentStack.bottomAnchor.constraint(equalTo: passwordRecoverySuccessView.bottomAnchor),
            
            // Fixed heights
            successLabel.heightAnchor.constraint(equalToConstant: 98),
            
            // Rest of the layout (unchanged)
            emailLabel.topAnchor.constraint(equalTo: smokeImageView.bottomAnchor, constant: 70),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordRecoveryButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordRecoveryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordRecoveryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordRecoveryButton.heightAnchor.constraint(equalToConstant: 48),
            
            buttonsStack.topAnchor.constraint(equalTo: passwordRecoveryButton.bottomAnchor, constant: 84),
            buttonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            helpButton.heightAnchor.constraint(equalToConstant: 48),
            createAccountButton.heightAnchor.constraint(equalToConstant: 48),
            
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            closeButton.widthAnchor.constraint(equalToConstant: 45),
            closeButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
