//
//  PageViewController.swift
//  SankarSuperMarket
//
//  Created by Admin on 8/3/16.
//  Copyright © 2016 vertaceapp. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var index = 0
    var identifiers: NSArray = ["GalleryViewController", "ThreadViewController"]
    override func viewDidLoad() {
    
    self.dataSource = self
    self.delegate = self
    
    let startingViewController = self.viewControllerAtIndex(self.index)
    let viewControllers: NSArray = [startingViewController]
    self.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    
    
    
    }
    
    func viewControllerAtIndex(index: Int) -> UINavigationController! {
    
    //first view controller = firstViewControllers navigation controller
    if index == 0 {
    
    return self.storyboard!.instantiateViewControllerWithIdentifier("GalleryViewController") as! UINavigationController
    
    }
    
    //second view controller = secondViewController's navigation controller
    if index == 1 {
    
    return self.storyboard!.instantiateViewControllerWithIdentifier("ThreadViewController") as! UINavigationController
    }
    
    return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
    let identifier = viewController.restorationIdentifier
    let index = self.identifiers.indexOfObject(identifier!)
    
    //if the index is the end of the array, return nil since we dont want a view controller after the last one
    if index == identifiers.count - 1 {
    
    return nil
    }
    
    //increment the index to get the viewController after the current index
    self.index = self.index + 1
    return self.viewControllerAtIndex(self.index)
    
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
    let identifier = viewController.restorationIdentifier
    let index = self.identifiers.indexOfObject(identifier!)
    
    //if the index is 0, return nil since we dont want a view controller before the first one
    if index == 0 {
    
    return nil
    }
    
    //decrement the index to get the viewController before the current one
    self.index = self.index - 1
    return self.viewControllerAtIndex(self.index)
    
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return self.identifiers.count
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
