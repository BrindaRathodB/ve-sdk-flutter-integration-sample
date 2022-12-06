import Foundation
import BanubaVideoEditorSDK
import BanubaMusicEditorSDK
import BanubaOverlayEditorSDK
import BanubaAudioBrowserSDK
import VideoEditor
import VEExportSDK
import Flutter

protocol VideoEditor {
    func openVideoEditorDefault(fromViewController controller: FlutterViewController, flutterResult: @escaping FlutterResult)
    
    func openVideoEditorPIP(fromViewController controller: FlutterViewController, videoURL: URL, flutterResult: @escaping FlutterResult)
}

class VideoEditorModule: VideoEditor {
    
    private var videoEditorSDK: BanubaVideoEditor?
    private var flutterResult: FlutterResult?
    
    func openVideoEditorDefault(
        fromViewController controller: FlutterViewController,
        flutterResult : @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        
        initializeVideoEditor(getAppDelegate().provideCustomViewFactory())
        
        let config = VideoEditorLaunchConfig(
            entryPoint: .camera,
            hostController: controller,
            animated: true
        )
        
        DispatchQueue.main.async {
            self.startVideoEditor(from: controller, config: config)
        }
    }
    
    func openVideoEditorPIP(
        fromViewController controller: FlutterViewController,
        videoURL: URL,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        
        initializeVideoEditor(getAppDelegate().provideCustomViewFactory())
        
        let pipLaunchConfig = VideoEditorLaunchConfig(
            entryPoint: .pip,
            hostController: controller,
            pipVideoItem: videoURL,
            musicTrack: nil,
            animated: true
        )
        
        DispatchQueue.main.async {
            self.startVideoEditor(from: controller, config: pipLaunchConfig)
        }
    }
    
    private func initializeVideoEditor(_ externalViewControllerFactory: FlutterCustomViewFactory?) {
        let config = VideoEditorConfig()
        videoEditorSDK = BanubaVideoEditor(
            token:"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",
            configuration: config,
            externalViewControllerFactory: externalViewControllerFactory
        )
        
        videoEditorSDK?.delegate = self
    }
    
    private func startVideoEditor(from controller: FlutterViewController, config: VideoEditorLaunchConfig) {
        self.videoEditorSDK?.presentVideoEditor(
            withLaunchConfiguration: config,
            completion: nil
        )
    }
    
    private func getAppDelegate() -> AppDelegate {
        return  UIApplication.shared.delegate as! AppDelegate
    }
}


// MARK: - Export flow
extension VideoEditorModule {
    func exportVideo() {
        let manager = FileManager.default
        // File name
        let firstFileURL = manager.temporaryDirectory.appendingPathComponent("banuba_demo_ve.mov")
        if manager.fileExists(atPath: firstFileURL.path) {
            try? manager.removeItem(at: firstFileURL)
        }
        
        // Video configuration
        let exportVideoConfigurations: [ExportVideoConfiguration] = [
            ExportVideoConfiguration(
                fileURL: firstFileURL,
                quality: .auto,
                useHEVCCodecIfPossible: true,
                watermarkConfiguration: nil
            )
        ]
        
        // Export Configuration
        let exportConfiguration = ExportConfiguration(
            videoConfigurations: exportVideoConfigurations,
            isCoverEnabled: true,
            gifSettings: nil
        )
        
        // Export func
        videoEditorSDK?.export(
            using: exportConfiguration,
            exportProgress: nil
        ) { [weak self] (success, error, coverImage) in
            // Export Callback
            DispatchQueue.main.async {
                if success {
                    let exportedVideoFilePath = firstFileURL.absoluteString
                    print("Export video completed successfully. Video: \(exportedVideoFilePath))")
                    
                    let data = [AppDelegate.argExportedVideoFile: exportedVideoFilePath]
                    self?.flutterResult?(data)
                    
                    // Remove strong reference to video editor sdk instance
                    self?.videoEditorSDK = nil
                } else {
                    print("Export video completed with error: \(String(describing: error))")
                    self?.flutterResult?(FlutterError(code: AppDelegate.errMissingExportResult,
                                                      message: "Export video completed with error: \(String(describing: error))",
                                                      details: nil))
                    
                    // Remove strong reference to video editor sdk instance
                    self?.videoEditorSDK = nil
                }
            }
        }
    }
}

// MARK: - BanubaVideoEditorSDKDelegate
extension VideoEditorModule: BanubaVideoEditorDelegate {
    func videoEditorDidCancel(_ videoEditor: BanubaVideoEditor) {
        videoEditor.dismissVideoEditor(animated: true) {
            // remove strong reference to video editor sdk instance
            self.videoEditorSDK = nil
        }
    }
    
    func videoEditorDone(_ videoEditor: BanubaVideoEditor) {
        videoEditor.dismissVideoEditor(animated: true) { [weak self] in
            self?.exportVideo()
        }
    }
}
