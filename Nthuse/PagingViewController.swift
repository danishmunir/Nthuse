//
//  PagingViewController.swift
//  Nthuse
//
//  Created by Danish Munir on 24/10/2020.
//

import UIKit

class PagingViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [Slide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        slides = createSlide()
        setUpSlideInscrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        
    
    }
    
    func createSlide() -> [Slide] {
        let slide1 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imgView.image = UIImage(named: "teddyBear1")
        slide1.labelTitle.text = "A real life Bear"
        slide1.labelDesc.text = "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imgView.image = UIImage(named: "teddyBear2")
        slide2.labelTitle.text = "A real-life bear"
        slide2.labelDesc.text = "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imgView.image = UIImage(named: "teddyBear3")
        slide3.labelTitle.text = "A real-life bear"
        slide3.labelDesc.text = "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"
        
        return [slide1, slide2, slide3]
    }
    
    func setUpSlideInscrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
}




extension PagingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
          pageControl.currentPage = Int(pageIndex)
          
//          let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//          let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//
////          // vertical
////          let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
////          let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
////
////          let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
////          let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
////
////
////          /*
////           * below code changes the background color of view on paging the scrollview
////           */
////  //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
////
////
////          /*
////           * below code scales the imageview on paging the scrollview
////           */
//////          let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//////
//////          if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
//////
//////              slides[0].imgView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
//////              slides[1].imgView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
//////
//////          } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
//////              slides[1].imgView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
//////              slides[2].imgView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
//////
//////          } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
//////              slides[2].imgView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
//////              slides[3].imgView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
//////
//////          } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
//////              slides[3].imgView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//////              slides[4].imgView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
//////          }
      }
}
