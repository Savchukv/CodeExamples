//
//  UpdateManager.swift
//
//  Created by Василий Савчук on 01/02/2019.
//  Copyright © 2019
//

import UIKit

final class UpdateManager {

    private var appsInfo: [AppsInfo]?
    private let manifestBaseURL = "itms-services://your_url"
    private let internalErrorText = "Обновление не удалось. Обратитесь в тех. поддержку"
    var completionHandlerForGetAppVersion: ((Any?, NSError?) -> Void)?

    func getAppsInfo(handler: @escaping () -> Void) {
        NetworkManager.getAppsInfo { [weak self] (result, error) in
            if let handler = self?.completionHandlerForGetAppVersion {
                handler(result, error as NSError?)
            }
            self?.appsInfo = result?.value
            handler()
        }
    }

    private func getAppInfo() -> (minVersion: String?, maxVerion: Version?) {
        guard let appsInfo = appsInfo else { return (nil, nil) }

        let filteredAppVersion = appsInfo
            .filter { application in
                return application.app_id.contains("enterprise")
            }
            .first

        let minVersion = filteredAppVersion?.minimum_version
        let maxVersion = availableVersion(versions: filteredAppVersion?.versions)
        return (minVersion, maxVersion)
    }

    private func getAppBundleVersion() -> String? {
        if let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return bundleVersion
        }
        return nil
    }

    func isNeedCriticalUpdateApp() -> Bool {
        guard let appServerVersion = getAppInfo().minVersion else { return false }
        guard let appBundleVersion = getAppBundleVersion() else { return false }
        return appServerVersion.compare(appBundleVersion, options: .numeric) == .orderedDescending
    }

    func isNeedUpdateApp() -> Bool {
        guard let appServerVersion = getAppInfo().maxVerion?.version else { return false }
        guard let appBundleVersion = getAppBundleVersion() else { return false }
        return appServerVersion.compare(appBundleVersion, options: .numeric) == .orderedDescending
    }

    @discardableResult
    func launchUpdateApp() -> Result<Void, ApplicationInternalError> {
        guard let urlString = getAppInfo().maxVerion?.uri,
            let url = URL(string: manifestBaseURL + urlString)
            else {
                let error = ApplicationInternalError.UpdateManagerError(errorDescription: internalErrorText)
                return Result.failure(error)
        }
        UIApplication.shared.open(url)
        return Result.success(())
    }

    private func availableVersion(versions: [Version]?) -> Version? {
        guard let versions = versions else { return nil }
        let version = versions
            .filter(eligible(version:))
            .sorted(by: { (first, second) -> Bool in
                first.version.compare(second.version, options: .numeric) == .orderedDescending
            })
            .first
        return version
    }

    private func eligible(version: Version) -> Bool {
        guard let percent = version.percent,
              let uuid = UIDevice.current.identifierForVendor?.uuidString,
              let actual = Int(uuid.prefix(2), radix: 16)?.remainderReportingOverflow(dividingBy: 100)
              else { return true }
        return actual.partialValue <= percent
    }
}
