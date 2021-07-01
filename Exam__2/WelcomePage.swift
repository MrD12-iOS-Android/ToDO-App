import UIKit

class WelcomePage: UIViewController {
    @IBOutlet weak var page_Controller: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var next_btn: UIButton!
    @IBOutlet var views: [UIView]!
    var currentPage = 0{
        didSet{
            page_Controller.currentPage = currentPage
            if currentPage == views.count - 1{
                next_btn.setTitle("GO", for: .normal)
            }else{
                next_btn.setTitle("Next", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    @IBAction func next(_ sender: UIButton) {
        if currentPage == views.count - 1{
            let vc = UserLogin(nibName: "UserLogin", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }else{
            currentPage += 1
            scrollView.scrollRectToVisible(CGRect(
                                            x: Int(CGFloat(currentPage) * scrollView.contentSize.width) / 3,
                                            y: 0,
                                            width: Int(CGFloat(currentPage) * scrollView.contentSize.width) / 3,
                                            height: Int(CGFloat(currentPage) * scrollView.contentSize.height)),
                                            animated: true)
        }
    }
}
extension WelcomePage : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let with = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / with)
        //page_Controller.currentPage = Int(round(Double(scrollView.contentOffset.x / scrollView.frame.size.width)))
    }
}
