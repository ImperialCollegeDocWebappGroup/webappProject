//
//  BeginningVC.swift
//  webapp
//
//  Created by ZhangZhuofan on 15/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class BeginningVC: UIViewController,UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "", "", "")
        self.pageImages = NSArray(objects: "clothes1", "clothes2", "clothes3")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        var startVC = self.viewControllerAtIndex(0) as ContentViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, (self.view.frame.size.height - 90))
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        /*
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    @IBAction func startAction(sender: AnyObject) {
    
    var startVC = self.viewControllerAtIndex(0) as ContentViewController
    var viewControllers = NSArray(object: startVC)
    self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Reverse, animated: true, completion: nil)
    
    }
    */
    func viewControllerAtIndex(index: Int) -> ContentViewController
    {
        if (self.pageTitles.count == 0) || (index >= self.pageTitles.count) {
            return ContentViewController()
        }
        
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        vc.ImageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count)
        {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
