//
//  GuideViewController.swift
//  Bookie - Session Tracker
//
//  Created by Reza Takhti on 12/7/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.backgroundColor = .white
        return cv
        
    }()
    
    let cellID = "cellID"
    let welcomeCellID = "welcomeCellID"
    
    var pageIndicatorBottomConstraint : NSLayoutConstraint?
    var nextButtonTopConstraint : NSLayoutConstraint?
    var skipButtonTopConstraint : NSLayoutConstraint?
    
    let pages: [Page] = {
        let firstPage = Page(title: "Track each time you read", message: "Easily start a reading session and keep track of the amount of time you spent reading", imageName: "01MainScreen_framed")
        let secondPage = Page(title: "Sessions simplied ", message: "All you have to do is put in your book name and start number, and the time is automatically tracked for you", imageName: "02NewSession_framed") 
        let thirdPage = Page(title: "Look back on your progress", message: "Quickly manage your past summaries and see how far you've come", imageName: "03PastSessions_framed" )
        return [firstPage,secondPage,thirdPage]
    }()
    
    
    lazy var pageIndicator : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = UIColor.flatLime()
        pc.numberOfPages = self.pages.count + 1
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    let skipButton : UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor.flatLime(), for: .normal)
        button.addTarget(self, action: #selector(SkipButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let nextButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(UIColor.flatLime(), for: .normal)
        button.addTarget(self, action: #selector(NextButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        setUpConstraints()
        registerCells()


    }
    @objc func NextButtonPressed(){
        guard pageIndicator.currentPage != pages.count else { return }
        
        let indexPath = IndexPath(item: pageIndicator.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageIndicator.currentPage += 1
        
        if pageIndicator.currentPage == pages.count{
            moveControlConstraintsOffScreen()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func SkipButtonPressed(){
        pageIndicator.currentPage = pages.count - 1 
        NextButtonPressed()
    }
    
    fileprivate func moveControlConstraintsOffScreen(){
        self.pageIndicatorBottomConstraint?.constant = 100
        self.nextButtonTopConstraint?.constant = -100
        self.skipButtonTopConstraint?.constant = -100
    }
    
    fileprivate func moveControlConstraintsOnScreen(){
        self.pageIndicatorBottomConstraint?.constant = 0
        self.nextButtonTopConstraint?.constant = 16
        self.skipButtonTopConstraint?.constant = 16
            
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageIndicator.currentPage = pageNumber
        
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        }else {
            moveControlConstraintsOnScreen()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    fileprivate func registerCells(){
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(WelcomeCell .self, forCellWithReuseIdentifier: welcomeCellID)
    }
    
    func setUpConstraints(){
        view.addSubview(collectionView)
        view.addSubview(pageIndicator)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageIndicatorBottomConstraint = pageIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        pageIndicatorBottomConstraint?.isActive = true
        pageIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        skipButtonTopConstraint = skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        skipButtonTopConstraint?.isActive = true
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        nextButtonTopConstraint =  nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        nextButtonTopConstraint?.isActive = true
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension GuideViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count{
            let welcomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: welcomeCellID, for: indexPath) as! WelcomeCell
            welcomeCell.button.addTarget(self, action: #selector(BeginButtonPressed), for: .touchUpInside)
            return welcomeCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PageCell
        
        let page = pages[indexPath.row]
        cell.page = page
        return cell
    }
    
    @objc func BeginButtonPressed(){
        defaults.set(true, forKey: "onboardingDone")
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let navController = UINavigationController(rootViewController: mainViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}

extension GuideViewController : UICollectionViewDelegate{
    
}

extension GuideViewController : UICollectionViewDelegateFlowLayout {
    
}
