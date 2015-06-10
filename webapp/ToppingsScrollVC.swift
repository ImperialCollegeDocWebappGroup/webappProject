//
//  ScroolVC.swift
//  webapp
//
//  Created by Timeless on 07/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class ToppingsScrollVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // need to load images from DB
        pageImages = [UIImage(named: "c1")!,
            UIImage(named: "collect")!,
            UIImage(named: "share")!,
            UIImage(named: "black1")!,
            UIImage(named: "black2")!]
        
        let pageCount = pageImages.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)

        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        if let pageView = pageViews[page] {
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of display, do nothing
            return
        }
        
        // Remove a page from the scroll view 
        // reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    
    func loadVisiblePages() {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageControl.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePages()
    }
    /*
    let scrollView = UIScrollView(frame: CGRectMake(0, 0, 100, 100))
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height)
    scrollView.delegate = self
    let pageControl = UIPageControl(frame:CGRectMake(0, 90, scrollView.frame.size.width, 20))
    pageControl.numberOfPages = Int(scrollView.contentSize.width / scrollView.frame.size.width)
    pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
    
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) -> () {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width);
        pageControl.currentPage = Int(pageNumber)
    }
   
    
    func changePage(sender: AnyObject) -> () {
        if let page = sender.currentPage {
            var frame:CGRect = scrollView.frame;
            
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0
            scrollView.scrollRectToVisible(frame, animated: true)
        }
    }
    
 */
}
