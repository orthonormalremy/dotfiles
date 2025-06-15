{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "rdahlke";
    userEmail = "orthonormalremy@gmail.com";
  };
}