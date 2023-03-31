//
//  ImageWithLabelView.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 27.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

class ImageWithLabelView: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var view: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func customInit() {
        view = loadViewFromNib()
        view?.frame = bounds
        view?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view!)
        setupGUI()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: ImageWithLabelView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupGUI() {
        self.backgroundColor = UIColor.clear
    }
    
    func setupView(icon: UIImage?, title: NSMutableAttributedString) {
        iconImageView.image = icon
        titleLabel.attributedText = title
    }
}


