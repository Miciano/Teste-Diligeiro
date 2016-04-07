//
//  CelulaTableViewCell.swift
//  TesteDiligeiro
//
//  Created by Fabio Miciano on 06/04/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import UIKit

class CelulaTableViewCell: UITableViewCell
{
    // MARK: Outlets
    @IBOutlet weak var lb_tipoDiligencia: UILabel!
    @IBOutlet weak var lb_dias: UILabel!
    @IBOutlet weak var lb_local: UILabel!
    @IBOutlet weak var lb_valor: UILabel!
    @IBOutlet weak var lb_descricao: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}