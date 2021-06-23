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
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public static let logout = ImageAsset(name: "logout")
  public static let backgroundPrimaryPressed = ColorAsset(name: "backgroundPrimaryPressed")
  public static let defaultBackground = ColorAsset(name: "defaultBackground")
  public static let scrollViewBackground = ColorAsset(name: "scrollViewBackground")
  public static let tableViewSeparator = ColorAsset(name: "tableViewSeparator")
  public static let bar1 = ColorAsset(name: "bar1")
  public static let bar2 = ColorAsset(name: "bar2")
  public static let textPrimary = ColorAsset(name: "textPrimary")
  public static let textSupplementary = ColorAsset(name: "textSupplementary")
  public static let cellBorder = ColorAsset(name: "cellBorder")
  public static let curve1 = ColorAsset(name: "curve1")
  public static let curve2 = ColorAsset(name: "curve2")
  public static let ph1 = ColorAsset(name: "ph1")
  public static let ph2 = ColorAsset(name: "ph2")
  public static let ph3 = ColorAsset(name: "ph3")
  public static let arrowDown = ImageAsset(name: "arrowDown")
  public static let arrowRight = ImageAsset(name: "arrowRight")
  public static let backspace = ImageAsset(name: "backspace")
  public static let faceid = ImageAsset(name: "faceid")
  public static let touchid = ImageAsset(name: "touchid")
  public static let background = ImageAsset(name: "background")
  public static let add = ImageAsset(name: "add")
  public static let card = ImageAsset(name: "card")
  public static let creditCard = ImageAsset(name: "credit_card")
  public static let defaultUser = ImageAsset(name: "defaultUser")
  public static let customers = ImageAsset(name: "customers")
  public static let signin = ImageAsset(name: "signin")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

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
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
