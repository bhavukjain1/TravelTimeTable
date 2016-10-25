//
//  ViewController.swift
//  GoEuroTest
//
//  Created by Bhavuk Jain on 25/10/16.
//  Copyright © 2016 Bhavuk Jain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var pageViewController: UIPageViewController?
    fileprivate var viewControllers:[String:PageCategoryItemViewController] = Dictionary()
    fileprivate var transitioningViewControllerIndex:Int?
    fileprivate var transitionInProgress:Bool = false
    fileprivate var previousSelectedIndexItem:Int = 0
    
    fileprivate var selectedFilter:Int = 0
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leadingHorizontalBar: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(named:"backgroundNavBar"), for: .default)
//        navigationController!.navigationBar.backgroundColor = UIColor(red: 15.0/255.0, green: 97/255.0, blue: 163/255.0, alpha: 1)
        navigationController!.navigationBar.shadowImage = UIImage()
        topView.backgroundColor = UIColor(patternImage: UIImage(named:"backgroundNavBar")!)
        createPageViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func trainBusFlightAction(_ sender: UIButton) {
        
        
        let width = self.view.bounds.width/3
        
        
        UIView.animate(withDuration: 0.3) {
            self.leadingHorizontalBar.constant = CGFloat((sender.tag - 1))*width
            self.view.layoutIfNeeded()
        }
        
        let tag = sender.tag
        
        if !transitionInProgress && previousSelectedIndexItem != tag-1{
            transitionInProgress = true
            
            let pageCategoryItemViewController = getItemController(tag-1)
            
            
            //        let indexPathPrevious = collectionView.indexPathForCell(previousCell!)
            
            if previousSelectedIndexItem > tag-1 {
                pageViewController?.setViewControllers([pageCategoryItemViewController!], direction: .reverse, animated: true, completion: { (finished) in
                    self.transitionInProgress = !finished
                })
            }else {
                pageViewController?.setViewControllers([pageCategoryItemViewController!], direction: .forward, animated: true, completion: { (finished) in
                    self.transitionInProgress = !finished
                })
            }

            previousSelectedIndexItem = tag - 1
        }
    }
}


//MARK: UIPageViewController Datasource and Delegate
extension ViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    func createPageViewController() {
        
        let pageController = self.storyboard?.instantiateViewController(withIdentifier: "pageCategoryController") as! UIPageViewController
        
        pageController.dataSource = self
        pageController.delegate = self
        
        let firstController = getItemController(0)!
        let startingViewControllers:[UIViewController] = [firstController]
        pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: mainView.bounds.width, height: mainView.bounds.height)
        mainView.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageCategoryItemViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageCategoryItemViewController
        
        
        if itemController.itemIndex+1 < 3 {
            
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    
    // MARK: Page Controller Delegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let controller = pendingViewControllers.first as? PageCategoryItemViewController
        
        transitioningViewControllerIndex = controller?.itemIndex
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            previousSelectedIndexItem = transitioningViewControllerIndex!
            
            let width = self.view.bounds.width/3
            
            
            UIView.animate(withDuration: 0.3) {
                self.leadingHorizontalBar.constant = CGFloat(self.transitioningViewControllerIndex!)*width
                self.view.layoutIfNeeded()
            }

            
        }
        
    }
    
    
    
    fileprivate func getItemController(_ itemIndex: Int) -> PageCategoryItemViewController? {
        
        if itemIndex < 3 {
            
            let indexString =   String(format: "%d",itemIndex)
            var pageCategoryItemViewController = viewControllers[indexString]
            if pageCategoryItemViewController == nil {
                pageCategoryItemViewController = self.storyboard!.instantiateViewController(withIdentifier: "pageCategoryItemViewController") as? PageCategoryItemViewController
                
                pageCategoryItemViewController!.itemIndex = itemIndex
                viewControllers[indexString] = pageCategoryItemViewController
            }
            //            pageItemController.imageName = contentImages[itemIndex]
            pageCategoryItemViewController?.filter = selectedFilter
            return pageCategoryItemViewController
        }
        
        return nil
    }
    
}

