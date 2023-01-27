//
//  QuoteCell.swift
//  Technical-test
//
//  Created by Kostya Yudin on 26.01.2023.
//

import UIKit

class QuoteCell: UITableViewCell {
     
     @IBOutlet weak var nameLabel: UILabel?
     @IBOutlet weak var lastLabel: UILabel?
     @IBOutlet weak var percentLabel: UILabel?
     @IBOutlet weak var starImage: UIImageView?
     @IBOutlet weak var borderView: UIView!
     @IBOutlet weak var borderLine: UIView!
     var indexPath = IndexPath()
     
     var model: Quote? {
          didSet {
               self.updateUI()
          }
     }
     
     weak var delegate: CellDelegate?
     
     var isLastCell = false
     
     override func awakeFromNib() {
          super.awakeFromNib()
          self.borderView.layer.borderWidth = 1
          self.borderView.layer.borderColor = UIColor(named: "appBlack")?.cgColor
     }
          
     func updateUI() {
          guard let model = self.model else { return }
          self.nameLabel?.text = model.name
          self.lastLabel?.text = (model.last ?? "") + " " + (model.currency ?? "")
          self.percentLabel?.text = model.readableLastChangePercent
          self.percentLabel?.textColor = model.percentsColor
          self.starImage?.image = model.image
          self.borderLine.isHidden = self.isLastCell ? false: true
     }
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          super.touchesBegan(touches, with: event)
          
          delegate?.unhideBorder(indexPath: indexPath)
          self.animate(layer: layer, from: CATransform3DScale(CATransform3DIdentity, 1, 1, 1), to: CATransform3DScale(CATransform3DIdentity, 0.95, 0.95, 1))
     }
     
     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
          super.touchesCancelled(touches, with: event)
         
          self.delegate?.hideBorder(indexPath: indexPath)
          self.animate(layer: layer, from: self.layer.presentation()?.transform ?? layer.transform, to: CATransform3DScale(CATransform3DIdentity, 1, 1, 1))
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          super.touchesEnded(touches, with: event)
          
          self.delegate?.hideBorder(indexPath: indexPath)
          self.animate(layer: layer, from: self.layer.presentation()?.transform ?? layer.transform, to: CATransform3DScale(CATransform3DIdentity, 1, 1, 1))
     }
     
     func animate(layer: CALayer,from: CATransform3D, to: CATransform3D) {
          let animation = CABasicAnimation(keyPath: "transform")
          animation.duration = 0.15
          animation.fromValue = from
          animation.toValue = to
          animation.fillMode = .forwards
          animation.isRemovedOnCompletion = false
          self.borderView.layer.add(animation, forKey: nil)
     }
     
     @IBAction func starButtonPressed(_ sender: Any) {
          guard let model = self.model else { return }
          model.isLiked = !model.isLiked
          self.updateUI()
          self.delegate?.starTapped()
     }
}

protocol CellDelegate: AnyObject {
     func starTapped()
     func unhideBorder(indexPath: IndexPath)
     func hideBorder(indexPath: IndexPath)
}
