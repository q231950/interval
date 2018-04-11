// Partly taken from the Kitura-Starter repository

import Foundation
import Kitura
import CloudEnvironment

public class Controller {

  public let router: Router
  let cloudEnv: CloudEnv
    
  public var port: Int {
    get { return cloudEnv.port }
  }

  public var url: String {
    get { return cloudEnv.url }
  }

  public init() {
    // Create CloudEnv instance
    cloudEnv = CloudEnv()

    // All web apps need a Router instance to define routes
    router = Router()

    // Serve static content from "public"
    router.all("/", middleware: StaticFileServer())
  }
}
