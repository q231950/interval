// Partly taken from the Kitura-Starter repository

// Kitura-Starter contains examples for creating custom routes.
import Kitura
import LoggerAPI
import HeliumLogger
import Controller

// HeliumLogger disables all buffering on stdout
HeliumLogger.use(LoggerMessageType.info)

// Create Controller
let controller = Controller()
Log.info("Server will be started on '\(controller.url)'.")

// Condifure Kitura
Kitura.addHTTPServer(onPort: controller.port, with: controller.router)

// Start Kitura-Starter server
Kitura.run()
