// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public static let logout = ImageAsset(name: "logout")
  public static let location = ImageAsset(name: "Location")
  public static let minus = ImageAsset(name: "Minus")
  public static let plus = ImageAsset(name: "Plus")
  public static let maps = ImageAsset(name: "maps")
  public static let omega = ImageAsset(name: "omega")
  public static let faceid = ImageAsset(name: "faceid")
  public static let touchid = ImageAsset(name: "touchid")
  public static let backspace = ImageAsset(name: "backspace")
  public static let customers = ImageAsset(name: "customers")
  public static let map = ImageAsset(name: "map")
  public static let signin = ImageAsset(name: "signin")
  public static let add = ImageAsset(name: "add")
  public static let arrowDown = ImageAsset(name: "arrowDown")
  public static let arrowRight = ImageAsset(name: "arrowRight")
  public static let creditCard = ImageAsset(name: "credit_card")
  public static let background = ImageAsset(name: "background")
  public static let card = ImageAsset(name: "card")
  public static let defaultUser = ImageAsset(name: "defaultUser")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

public extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
