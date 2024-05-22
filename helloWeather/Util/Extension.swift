import UIKit

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}

extension UISearchBar{
    func setLeftImage( _ image : UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 21).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        imageView.tintColor = tintColor
        searchTextField.leftView = imageView
    }
}

extension Calendar {
    static func getYesterday() -> String?{
        let today = Date()
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let yesterdayString = dateFormatter.string(from: yesterday)
            return yesterdayString
        } else {
            return nil
        }
    }
}

extension UITabBar {
    func configureMaterialBackground(
        selectedItemColor: UIColor = .systemBlue,
        unselectedItemColor: UIColor = .secondaryLabel,
        blurStyle: UIBlurEffect.Style = .regular
    ) {
        // Make tabBar fully tranparent
        isTranslucent = true
        backgroundImage = UIImage()
        shadowImage = UIImage() // no separator
        barTintColor = .clear
        layer.backgroundColor = UIColor.clear.cgColor
    
        // Apply icon colors
        tintColor = selectedItemColor
        unselectedItemTintColor = unselectedItemColor
    
        // Add material blur
//        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = TSBlurEffectView()
        blurView.intensity = 10
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.opacity = 1
    
        // Add black view to cancel out gray look
//        let blackView = UIView(frame: bounds)
//        blackView.backgroundColor = .systemBackground.withAlphaComponent(0.9)
//        blackView.frame = bounds
//        blackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        insertSubview(blurView, at: 0)
//        insertSubview(blackView, aboveSubview: blurView)
    }
}

