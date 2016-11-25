//
//  ExerciseModel.swift
//  Workout
//
//  Created by Stephen Lasky on 11/20/16.
//  Copyright © 2016 Stephen Lasky. All rights reserved.
//

import Foundation

class Exercise {
    let name : String
    let weights : [Double]
    
    init(name: String) {
        self.name = name
        let baseWeightConstant = 2.5
        var _weights = [Double]()
        for index in 0..<300 {
            _weights.append(baseWeightConstant * Double(index))
        }
        weights = _weights
    }
}

class BodyPart {
    let name : String
    let exercises : [Exercise]
    
    
    init(name: String, exercises: [Exercise]) {
        self.name = name
        self.exercises = exercises
    }
    
    func exerciseAtIndex(index: Int) -> Exercise {
        return exercises[index]
    }
    func numberOfExercises() -> Int {
        return exercises.count
    }
}

class ExerciseModel {
    let bodyParts : [BodyPart]
    
    init() {
        // TEST DATA //
        var bodyPartNames = ["Biceps", "Triceps", "Legs", "Back", "Shoulders", "Chest"]
        var bodyPartExercises = [String: [Exercise]]()
        bodyPartExercises["Biceps"] = [Exercise(name: "Bar Curl"), Exercise(name: "Dumbell Curl")]
        bodyPartExercises["Triceps"] = [Exercise(name: "Skull Crusher"), Exercise(name: "Bench Press")]
        bodyPartExercises["Shoulders"] = [Exercise(name: "Bar Military Press"), Exercise(name: "Dumbell Military Press")]
        bodyPartExercises["Back"] = [Exercise(name: "Pull Up"), Exercise(name: "Lat Pulldown")]
        bodyPartExercises["Chest"] = [Exercise(name: "Bench Press"), Exercise(name: "Dumbell Flys")]
        bodyPartExercises["Legs"] = [Exercise(name: "Squat"), Exercise(name: "Leg Press")]
        var _bodyParts = [BodyPart]()
        for bodyPartName in bodyPartNames {
            _bodyParts.append(BodyPart(name: bodyPartName, exercises: bodyPartExercises[bodyPartName]!))
        }
        bodyParts = _bodyParts
    }
    
    func bodyPartAtIndex(index: Int) -> BodyPart {
        return bodyParts[index]
    }
    func numberOfBodyParts() -> Int {
        return bodyParts.count
    }
    func exerciseNameWithBodyPartIndexAndExerciseIndex(bodyPartIndex: Int, exerciseIndex: Int) -> String {
        return bodyParts[bodyPartIndex].exerciseAtIndex(index: exerciseIndex).name
    }
    func numberOfExercisesWithBodyPartIndex(index: Int) -> Int {
        return bodyParts[index].numberOfExercises()
    }
    func exerciseWeightWithBodyPartIndexAndExerciseIndexAndWeightIndex(bodyPartIndex: Int, exerciseIndex: Int, weightIndex: Int) -> Double {
        return bodyParts[bodyPartIndex].exerciseAtIndex(index: exerciseIndex).weights[weightIndex]
    }
}























