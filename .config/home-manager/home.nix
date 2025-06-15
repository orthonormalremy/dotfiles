{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # `home.stateVersion` handled in ./home.init.nix

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    _1password-cli
    helix
    just
    nushell
    ripgrep
    sshs
    stow
  ];

  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
