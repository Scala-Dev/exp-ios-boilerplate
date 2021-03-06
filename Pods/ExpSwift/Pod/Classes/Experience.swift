//
//  Experience.swift
//  Pods
//
//  Created by Cesar on 9/9/15.
//
//

import Foundation
import PromiseKit
import Alamofire


public final class Experience: Model,ResponseObject,ResponseCollection {

    public let uuid: String
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        
        super.init(response: response, representation: representation)
    }
    
    
     public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Experience] {
        var experiences: [Experience] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for experienceRepresentation in representation {
                if let experience = Experience(response: response, representation: experienceRepresentation) {
                    experiences.append(experience)
                }
            }
        }
        return experiences
    }
    
    public func getDevices() -> Promise<SearchResults<Device>>{
        return Promise { fulfill, reject in
            Alamofire.request(Router.findDevices(["location.uuid":self.uuid]))
                .responseCollection { (response: Response<SearchResults<Device>, NSError>) in
                    switch response.result{
                    case .Success(let data):
                        fulfill(data)
                    case .Failure(let error):
                        return reject(error)
                    }
            }
        }
    }
    
    /**
     Get Current Experience
     @return Promise<Experience>.
     */
    public func getCurrentExperience() -> Promise<Experience?>{
        return Device.getCurrentDevice().then{ (device:Device?) -> Promise<Experience?> in
            return Promise<Experience?> { fulfill, reject in
                if let experience:Experience = device?.getExperience(){
                    fulfill(experience)
                }else{
                    fulfill(nil)
                    expLogging("Experience - getCurrentExperience NULL")
                }
            }
        }
    }

    
}
