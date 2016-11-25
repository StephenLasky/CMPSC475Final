//
//  ViewController.swift
//  Workout
//
//  Created by Stephen Lasky on 11/19/16.
//  Copyright © 2016 Stephen Lasky. All rights reserved.
//

import UIKit

struct setData {
    var exerciseName: String
    var weight: String
    var numberOfReps: String
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    @IBOutlet weak var bodyPartScrollView: UIScrollView!
    @IBOutlet weak var setsTableView: UITableView!
    @IBOutlet weak var setPickerContainerView: UIScrollView!
    @IBOutlet weak var addSetPlaceholderView: UIView!
    
    var addSetView = UIView()
    var setPickers = [UIPickerView]()
    let exerciseModel = ExerciseModel()
    var currentSetData = setData(exerciseName: "", weight: "", numberOfReps: "")
    
    var tableData = [setData]()  // TODO: delete
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeSetPickerViews()
        initializeBodyPartScrollView()
        self.initializeTimeElapsed()
        initializeAddSetView()
        initializeTableView()
        
        
        // table debug
        
        
    }
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.setsTableView.dequeueReusableCell(withIdentifier: "cell")! as! SetTableViewCell
        
        for subview in cell.subviews {
            subview.removeFromSuperview()
            print("subview removed")
        }
        
        // TODO: XYZ
        var newLabels = [UILabel]()
        newLabels.append(UILabel())
        newLabels[0].text = tableData[indexPath.row].exerciseName
        newLabels.append(UILabel())
        newLabels[1].text = tableData[indexPath.row].numberOfReps
        newLabels.append(UILabel())
        newLabels[2].text = tableData[indexPath.row].weight
        
        for index in 0..<newLabels.count {
            newLabels[index].tag = index
        }
        
        var lastX = CGFloat(0)
        for newLabel in newLabels {
            newLabel.textAlignment = .center
            let newWidth =  CGFloat(pickerComponentViewWidthConstants[newLabel.tag]) * currentlySelectedSetPicker().frame.width
            let newFrame = CGRect(x: lastX, y: CGFloat(0), width: newWidth, height: cell.frame.height)
            newLabel.frame = newFrame
            cell.addSubview(newLabel)
            lastX += newWidth
        }
        print(cell.subviews.count)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return addSetView.frame.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        print("hello")
        
        return 1
    }
    
    func initializeTableView() {
        setsTableView.delegate = self
        setsTableView.dataSource = self
    }
    // End Table View
    
    
    
    func initializeSetPickerViews() {
        setPickerContainerView.isScrollEnabled = true
        setPickerContainerView.isUserInteractionEnabled = true
        setPickerContainerView.delegate = self
        
        for index in 0..<exerciseModel.numberOfBodyParts() {
            let newSetPicker = UIPickerView()
            newSetPicker.delegate = self
            newSetPicker.dataSource = self
            newSetPicker.tag = index
            
            let x = CGFloat(index) * setPickerContainerView.frame.width
            let y = CGFloat(0)
            let width = setPickerContainerView.frame.width
            let height = setPickerContainerView.frame.height
            
            newSetPicker.frame = CGRect(x: x, y: y, width: width, height: height)
            setPickerContainerView.addSubview(newSetPicker)
            
            setPickers.append(newSetPicker)
        }
        
        let newContentSize = CGSize(width: setPickerContainerView.frame.size.width * CGFloat(exerciseModel.numberOfBodyParts()), height: setPickerContainerView.frame.size.height)
        setPickerContainerView.contentSize = newContentSize
    }
    
    func getCoordinatesFromMainViewToSubview(viewInMainView: UIView,subview: UIView) -> CGPoint {
        let viewInMainViewCoordinates = viewInMainView.frame.origin
        let subviewCoordinates = subview.frame.origin
        
        var coordinatesInSubview = viewInMainViewCoordinates
        coordinatesInSubview.x -= subviewCoordinates.x
        coordinatesInSubview.y -= subviewCoordinates.y
        
        return coordinatesInSubview
    }
    func getCoordinatesFromMainViewToSubview(viewCoordinatesInMainView: CGPoint,subview: UIView) -> CGPoint {
        let subviewCoordinates = subview.frame.origin
        
        var coordinatesInSubview = viewCoordinatesInMainView
        coordinatesInSubview.x -= subviewCoordinates.x
        coordinatesInSubview.y -= subviewCoordinates.y
        
        return coordinatesInSubview
    }
    
    func getCoordinatesInSuperView(subview: UIView) -> CGPoint {
        let superviewCoordinates = subview.superview!.frame.origin
        let subviewCoordinates = subview.frame.origin
        
        var coordinatesInMainView = superviewCoordinates
        coordinatesInMainView.x += subviewCoordinates.x
        coordinatesInMainView.y += subviewCoordinates.y
        
        return coordinatesInMainView
    }
    
    func getCoordinatesInSuperScrollView(subview: UIView) -> CGPoint {
        let superview = subview.superview! as! UIScrollView
        let superviewCoordinates = superview.frame.origin
        let subviewCoordinates = subview.frame.origin
        
        var coordinatesInMainView = superviewCoordinates
        coordinatesInMainView.x += subviewCoordinates.x
        coordinatesInMainView.y += subviewCoordinates.y
        coordinatesInMainView.x -= superview.contentOffset.x
        coordinatesInMainView.y -= superview.contentOffset.y
        
        return coordinatesInMainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print(setsTableView.numberOfRows(inSection: 0))
        
    }
    

    func initializeAddSetView() {
        let addSetViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(addSetViewPanned))
//        let addSetViewPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addSetViewPressed))
        
        let newFrame = CGRect(x: addSetPlaceholderView.frame.origin.x, y: addSetPlaceholderView.frame.origin.y, width: addSetPlaceholderView.frame.width, height: addSetPlaceholderView.frame.height)
        addSetView.frame = newFrame
        addSetView.backgroundColor = UIColor.green
        addSetView.isUserInteractionEnabled = true
        addSetView.clipsToBounds = false
        self.view.addSubview(addSetView)
        self.view.bringSubview(toFront: addSetView)
        
//        addSetViewPressGestureRecognizer.minimumPressDuration = 0
        addSetView.addGestureRecognizer(addSetViewPanGestureRecognizer)
//        addSetView.addGestureRecognizer(addSetViewPressGestureRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == addSetView.gestureRecognizers![0] && gestureRecognizer == addSetView.gestureRecognizers![1] {
            return true
        }
        else if gestureRecognizer == addSetView.gestureRecognizers![1] && gestureRecognizer == addSetView.gestureRecognizers![0] {
            return true
        }
        else {
            return false
        }
    }
    
    func currentlySelectedSetPicker() -> UIPickerView {
        let contentOffset = setPickerContainerView.contentOffset
        let xTestPoint = contentOffset.x + (setPickerContainerView.frame.width / CGFloat(2))
        for setPicker in setPickers {
            let xLowTestValue = setPicker.frame.origin.x
            let xHighTestValue = setPicker.frame.origin.x + setPicker.frame.width
            if xTestPoint >= xLowTestValue && xTestPoint <= xHighTestValue {
                return setPicker
            }
        }
        
        if xTestPoint < 0 {
            return setPickers[0]
        }
        else {
            return setPickers[setPickers.count - 1]
        }
    }
    
    func addSetViewPanned(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let newCenter = CGPoint(x: addSetView.center.x + translation.x, y: addSetView.center.y + translation.y)
        addSetView.center = newCenter
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if sender.state == .began {
            
            // select the data
            
            
            let currentlySelectedSetPicker = self.currentlySelectedSetPicker()
            for component in 0..<currentlySelectedSetPicker.numberOfComponents {
                let selectedRow = currentlySelectedSetPicker.selectedRow(inComponent: component)
                let selectedData = pickerView(currentlySelectedSetPicker, titleForRow: selectedRow, forComponent: component)!
                
                // update our set data
                switch component {
                case 0:
                    currentSetData.exerciseName = selectedData
                case 1:
                    currentSetData.weight = selectedData
                case 2:
                    currentSetData.numberOfReps = selectedData
                default:
                    print("addSetViewPanned: UNKNOWN COMPONENT")
                }
                
                // create this particular label
                let newLabel = UILabel()
                newLabel.text = selectedData
                newLabel.textColor = UIColor.blue
                newLabel.textAlignment = .center
                
                let coordinatesInView = getCoordinatesInSuperScrollView(subview: currentlySelectedSetPicker)
                let coordinatesInAddSetView = getCoordinatesFromMainViewToSubview(viewCoordinatesInMainView: coordinatesInView,subview: addSetView)
                
                let pickerWidth = currentlySelectedSetPicker.frame.width
                let componentWidth = CGFloat(pickerComponentViewWidthConstants[component]) * pickerWidth
                let componentHeight = currentlySelectedSetPicker.frame.height
                var componentXTranslation = CGFloat(0)
                for index in 0..<component {
                    componentXTranslation += CGFloat(pickerComponentViewWidthConstants[index]) * pickerWidth
                }
                
                let newFrame = CGRect(x: coordinatesInAddSetView.x + componentXTranslation, y: coordinatesInAddSetView.y, width: componentWidth, height: componentHeight)
                newLabel.frame = newFrame
                addSetView.addSubview(newLabel)
                
                UILabel.animate(withDuration: 0.35 + Double(component) * 0.10, animations: {
                    var animateFrame = newLabel.frame
                    animateFrame.origin.y = 0
                    animateFrame.size.height = self.addSetView.frame.height
                    newLabel.frame = animateFrame
                })
            }
            
            
        }
        else if sender.state == .ended {
            // determine if the addCenterView is dropped over the table
            var isAddSetViewOverTableView = true
            let addSetViewPosition = addSetView.center
            let addSetViewMinPosition = setsTableView.frame.origin
            let addSetViewMaxPosition = CGPoint(x: addSetViewMinPosition.x + setsTableView.frame.width, y: addSetViewMinPosition.y + setsTableView.frame.height)
            if !(addSetViewPosition.x >= addSetViewMinPosition.x && addSetViewPosition.x <= addSetViewMaxPosition.x) {
                isAddSetViewOverTableView = false
            }
            if !(addSetViewPosition.y >= addSetViewMinPosition.y && addSetViewPosition.y <= addSetViewMaxPosition.y) {
                isAddSetViewOverTableView = false
            }
            
            if isAddSetViewOverTableView {
                
                
                // animate it out
                UILabel.animate(withDuration: 0.40, animations: {
                    self.addSetView.frame = CGRect(x: self.setsTableView.frame.origin.x, y: self.setsTableView.frame.origin.y, width: self.addSetView.frame.width, height: self.addSetView.frame.height)
                }, completion: { (true) in
                    self.addSetView.alpha = CGFloat(0.0)
                    
                    self.setsTableView.beginUpdates()
                    let indexPath = IndexPath(row: 0, section: 0)
                    var indexPaths = [IndexPath]()
                    indexPaths.append(indexPath)
                    self.tableData.insert(self.currentSetData, at: 0)
                    self.setsTableView.insertRows(at: indexPaths, with: .automatic)
                    self.setsTableView.endUpdates()
                    
                    print("svc begin: " + String(self.addSetView.subviews.count))
                    for subview in self.addSetView.subviews {
                        subview.removeFromSuperview()
                    }
                    print("svc end: " + String(self.addSetView.subviews.count))
                    self.addSetView.frame = CGRect(x: self.addSetPlaceholderView.frame.origin.x, y: self.addSetPlaceholderView.frame.origin.y, width: self.addSetView.frame.width, height: self.addSetView.frame.height)
                    UILabel.animate(withDuration: 0.50, animations: {
                        self.addSetView.alpha = CGFloat(1.0)
                    })
                    

                })
            }
            else {
                // if view is dropped not onto the table
                for subview in sender.view!.subviews {
                    UILabel.animate(withDuration: 0.25, animations: {
                        subview.alpha = CGFloat(0)
                    }, completion: { (true) in
                        subview.removeFromSuperview()
                    })
                }
                UIView.animate(withDuration: 0.25, animations: {
                    sender.view!.frame = self.addSetPlaceholderView.frame
                })
            }
            
            
            

        }
    }
    
    let pickerComponentViewWidthConstants = [0.5, 0.25, 0.25]
    
    var timeElapsedCount = 0
    var timeElapsedTimer = Timer()
    func initializeTimeElapsed() {
        // timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
        
        self.timeElapsedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeElapsedCounter), userInfo: nil, repeats: true)
        
    }
    func timeElapsedCounter() {
        timeElapsedCount += 1
        timeElapsedLabel.text = "\(timeElapsedCount)"
    }
    
    func initializeBodyPartScrollView() {
        let labelWidth = bodyPartScrollView.frame.width/CGFloat(3)

        
        bodyPartScrollView.contentSize = bodyPartScrollView.frame.size
        for index in 0..<exerciseModel.numberOfBodyParts() {
            let newLabel = UILabel()
            newLabel.text = exerciseModel.bodyPartAtIndex(index: index).name
            newLabel.textAlignment = NSTextAlignment.center
            let labelHeight = bodyPartScrollView.frame.height
            newLabel.frame = CGRect(x: CGFloat(index + 1)*labelWidth, y: 0, width: labelWidth, height: labelHeight)
            
            bodyPartScrollView.addSubview(newLabel)
        }
        
        
        bodyPartScrollView.isUserInteractionEnabled = true
        bodyPartScrollView.isScrollEnabled = true
        bodyPartScrollView.delegate = self
        bodyPartScrollView.contentSize = CGSize(width: labelWidth * CGFloat(exerciseModel.numberOfBodyParts() + 2), height: bodyPartScrollView.frame.height)
        
    }

    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let bodyPartIndex = pickerView.tag
        switch component {
        case 0:
            return exerciseModel.exerciseNameWithBodyPartIndexAndExerciseIndex(bodyPartIndex: bodyPartIndex, exerciseIndex: row)
        case 1:
            return String(Double(row)*2.5)
        case 2:
            return String(row)
        default:
            return "ERROR"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        
        var data: String
        switch component {
        case 0:
            data =  exerciseModel.exerciseNameWithBodyPartIndexAndExerciseIndex(bodyPartIndex: pickerView.tag, exerciseIndex: row)
        case 1:
            data = String(Double(row)*2.5)
        case 2:
            data = String(row)
        default:
            data =  "ERROR"
        }
        
        let newLabel = UILabel()
        newLabel.text = data
        newLabel.textAlignment = .center
        return newLabel
    }
    
    
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let bodyPartIndex = pickerView.tag
        switch component {
        case 0:
            return exerciseModel.numberOfExercisesWithBodyPartIndex(index: bodyPartIndex)
        case 1:
            return 300
        case 2:
            return 100
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let pickerViewWidth = pickerView.frame.width
        let widthConstant = pickerComponentViewWidthConstants[component]
        return CGFloat(widthConstant) * pickerViewWidth
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bodyPartScrollView {
            setPickerContainerView.contentOffset = CGPoint(x: CGFloat(3.0) * bodyPartScrollView.contentOffset.x, y: 0)
        }
        else if scrollView == setPickerContainerView {
            bodyPartScrollView.contentOffset = CGPoint(x: setPickerContainerView.contentOffset.x / CGFloat(3.0), y:0)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bodyPartScrollView {
            pageSetContainerView()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == bodyPartScrollView {
            pageSetContainerView()
        }
    }
    
    func pageSetContainerView() {
        let pickerViewWidth = setPickerContainerView.frame.width
        let currentXContentOffset = setPickerContainerView.contentOffset.x
        let incorrectOffset = currentXContentOffset.truncatingRemainder(dividingBy: pickerViewWidth)
        var newXContentOffset = CGFloat(0.0)
        if incorrectOffset < pickerViewWidth / 2.0 {
            newXContentOffset = currentXContentOffset - incorrectOffset
        }
        else {
            newXContentOffset = currentXContentOffset - incorrectOffset + pickerViewWidth
        }
        UIScrollView.animate(withDuration: 0.25, animations: {
            self.setPickerContainerView.contentOffset = CGPoint(x: newXContentOffset, y: 0.0)
        })
    }
    
    
    
    
    

}

