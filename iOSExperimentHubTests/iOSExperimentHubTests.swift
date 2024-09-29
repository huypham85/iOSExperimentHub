//
//  iOSExperimentHubTests.swift
//  iOSExperimentHubTests
//
//  Created by HuyPT3 on 19/03/2024.
//

import XCTest
@testable import iOSExperimentHub

final class iOSExperimentHubTests: XCTestCase {
    /*
     1 mảng số nguyên
     1 số s
     tìm ra 2 số đầu tiên có tổng là s

     [2, 7, 8, 15] , s = 9
     duyệt qua mảng

     map[2] = 0
     map[7] = 1
     ....
     
     */
    class Solution {
        func findTwoSum(_ array: [Int], _ target: Int) -> [Int] {
            var map: [Int: Int] = [:]
            
            for i in 0 ..< array.count {
                let sub = target - array[i]
                if let index = map[sub] {
                    return [i, index]
                }
                
                map[array[i]] = i
            }
            
            return []
        }
    }

    func testExample1() throws {
        let s = Solution()
        let array = [2, 7, 8, 15]
        let target = 9
        XCTAssertEqual(s.findTwoSum(array, target), [1,0])
    }
    
    func testExample2() throws {
        let s = Solution()
        let array = [2, 7, 8, 1]
        let target = 9
        XCTAssertEqual(s.findTwoSum(array, target), [1,0])
    }
    
    func testExample3() throws {
        let s = Solution()
        let array = [8, 7, 2, 10, 1]
        let target = 9
        XCTAssertEqual(s.findTwoSum(array, target), [2, 1])
    }
    
    func testExample4() throws {
        let s = Solution()
        let array = [8, 7, 2, 10, 1]
        let target = 20
        XCTAssertEqual(s.findTwoSum(array, target), [])
    }
}
