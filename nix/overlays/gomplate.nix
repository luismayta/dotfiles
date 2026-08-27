# Overlay to fix gomplate version in nixpkgs
# The upstream package has a bug in ldflags (v4 instead of v5)
final: prev: {
  gomplate = prev.gomplate.overrideAttrs (oldAttrs: {
    ldflags = [
      "-s"
      "-X github.com/hairyhenderson/gomplate/v5/version.Version=${oldAttrs.version}"
    ];
  });
}
