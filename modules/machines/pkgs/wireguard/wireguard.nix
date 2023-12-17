{ config, lib, pkgs, ... }: let
  cfg = config.my.wireguard;
in {

  options.my.wireguard = with lib; {
    enable = mkEnableOption ""; # I'm too lazy to fill those out
    address = mkOption {};
    peer = mkOption {};
    endpoint = mkOption {};
    privateKey = mkOption {
      type = types.path;
    };
  };

  config.systemd.services.wg = {
    description = "wg network interface";
    # Absolutely require the wg network namespace to exist.
    bindsTo = [ "netns@wg.service" ];
    # Require a network connection.
    requires = [ "network-online.target" "nss-lookup.target" ];
    # Start after and stop before those units.
    after = [ "netns@wg.service" "network-online.target" "nss-lookup.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writers.writeDash "wg-up" ''
        ${pkgs.iproute}/bin/ip link add wg type wireguard
        ${pkgs.wireguard}/bin/wg set wg \
          private-key ${cfg.privateKey} \
          peer ${cfg.peer} \
          allowed-ips 0.0.0.0/0,::/0 \
          endpoint ${cfg.endpoint}
        ${pkgs.iproute}/bin/ip link set wg netns wg up
        ${pkgs.iproute}/bin/ip -n wg address add ${cfg.address.IPv4} dev wg
        ${pkgs.iproute}/bin/ip -n wg -6 address add ${cfg.address.IPv6} dev wg
        ${pkgs.iproute}/bin/ip -n wg route add default dev wg
        ${pkgs.iproute}/bin/ip -n wg -6 route add default dev wg
      '';
      ExecStop =  pkgs.writers.writeDash "wg-down" ''
        ${pkgs.iproute}/bin/ip -n wg link del wg
        ${pkgs.iproute}/bin/ip -n wg route del default dev wg
      '';
    };
  };
}
