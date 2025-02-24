//
//  SolContactUsStrings.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 20/02/25.
//

import Foundation
import UIKit

enum SolContactUsStrings {
    static let writheHereYourMessage = "Escreva sua mensagem aqui"
    static let anyErrorOcorred = "Ocorreu algum erro"
    static let ops = "Ops.."
    static let send = "Enviar"
    static let back = "Voltar"
}


extension UIButton {
    func applyStyleSolContactUsButton(title: String, backgroudColor: UIColor, setTitleColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroudColor
        self.setTitleColor(setTitleColor, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
    }
}
