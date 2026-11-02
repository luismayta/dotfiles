{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [ "font-source-code-pro" ];
    brews = [ "ksh" "the_silver_searcher" "cmake" ];
  };
}
