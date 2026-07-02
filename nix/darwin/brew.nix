{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [ "font-source-code-pro" ];
    brews = [ "ksh" "ag" "cmake" ];
  };
}
