{ config,
  pkgs,
  lib,
... }:
### testing gpg sign for git commits
let
  # this is a set, for a pkg , not a service
  pkgsUnstable = import <nixpkgs-unstable> {};

  # wrappers for pkgs, bins, custom bash scripts
  #1
  gitIdentity =
    pkgs.writeShellScriptBin "git-identity" (builtins.readFile ./git-identity);
  #2
   gitImport =
     pkgs.writeShellScriptBin "git-import" (builtins.readFile ./git-import);
   #3
   gitMaintain = pkgs.writeShellScriptBin "git-maintain" (builtins.readFile ./git-maintain);
   #4
   gitValid = pkgs.writeShellScriptBin "git-valid" (builtins.readFile ./git-valid);
   #5
   gitCheck  = pkgs.writeShellScriptBin "git-check" (builtins.readFile ./git-check);
   #6
   branchProtect =
     pkgs.writeShellScriptBin "branch-protect" (builtins.readFile ./branch-protect);
   #7
   #custom emacs package, to practice, override attrs
   buildEmacs = (pkgs.emacsPackagesFor pkgs.emacs29).emacsWithPackages;
   emacsPkg = buildEmacs (epkgs:

builtins.attrValues {
#inherit (epkgs.melpaPackages) yodel;
inherit (epkgs.melpaPackages) aria2;
inherit (epkgs.melpaPackages) multi-vterm;
inherit (epkgs.melpaPackages) vterm;
inherit (epkgs.melpaPackages) magit;
inherit (epkgs.melpaPackages) nix-mode;
inherit (epkgs.elpaPackages) auctex;

inherit (epkgs.treesit-grammars) with-all-grammars;

});

  username = "dev";
  #for containers
  #hostCfg = config
  #userUid = hostCfg.users.users.${config.ncfg.primaryUser.name}.uid;
  accounts.email.accounts = {
    personal = {
      address = "847157+carnotweat@users.noreply.github.com";
      gpg.key = "1FB20D8EE8067117";
      primary = true;
      realName = "sameer";
    };
  };
# let ends
in
{

  fonts.fontconfig.enable = true;

  home = {
    username = "dev";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
    file = {
      # from mutable config to immutable ones, can be done later with nix modules to be imported here
      gpgSshKeys = {
        target = ".gnupg/sshcontrol";
        text = ''
          CC1491E6DA09B2F583BB3B1C08F688491941A512
          EEE0D3359F9A30466588C7210E34D49BDE28FE18
        '';
      };
      # file var
      #.emacs.d".source = ~/.emacs.d/init.el;
      # # ".emacs.d/emacs.el".source = ~/dotfiles/.emacs.el;
      #fixing
      #"nyxt".source = ~/dotfiles/nyxt-config;
      #attrsets
      ".tmux.conf" = {
        text = ''
          set-option -g default-shell /run/current-system/sw/bin/fish
          set-window-option -g mode-keys vi
          set -g default-terminal "screen-256color"
          set -ga terminal-overrides ',screen-256color:Tc'
        '';
        #         ".openssl".text = ''

      };
    };
      # programs.openssl is not a nix option or systemd service .. I guess

      sessionVariables = {
        EDITOR = "emacs";
        TERMINAL = "qterminal";
        
        TERMINFO_DIRS = "${pkgs.foot.terminfo.outPath}/share/terminfo";
        # FZF_DEFAULT_OPTS = ''
        # '';
      };

      packages = with pkgs;[
        # wrapping in the derviation
        #applying overrides with parentheses w/o a conflict in order yet. No lib.mk..
        (nerdfonts.override { fonts = [
          "FantasqueSansMono"
          "JetBrainsMono"
                              ]; })
        #nix utils for guix
        niv   #paths and channels
        nix-du
        morph
        lazygit
        #pkgsUnstable.nwg-displays
        #pkgsUnstable.nwg-look
        restic
        prometheus
        (lib.hiPrio rofi)
        #rofi-wayland
        #pkgsUnstable.gopusinfo
        pkgsUnstable.autotiling
        #pkgsUnstable.nwg-bar
        #pkgsUnstable.nwg-menu
        #pkgsUnstable.nwg-dock
        #pkgsUnstable.nwg-drawer
        #pkgsUnstable.nwg-panel
        pkgsUnstable.cargo
        python39
        extra-container
        fortune
        nmap
        orjail
        wireshark
        parted
	mergerfs
        watchexec
        out-of-tree
        cage
        just
        gotools
        debootstrap
        zbar
        runc
        socat
        docker
        docker-compose
        nixos-generators
        openring
        tmuxinator
        tini
        virt-manager
        python311Packages.supervisor
        waypipe
        distrobuilder
        colmena
        buildah
        podman
        podman-compose
        qemu
        clamav
        flannel
        crun
        skopeo
        umoci
        fcp
        mailutils
        xdg-utils
        (lib.hiPrio pkgsUnstable.rustup)
        racket
        haunt
        ispell
        clisp
        spidermonkey_102
        pkgsUnstable.typst
        pkgsUnstable.typst-lsp
        pkgsUnstable.tree-sitter
        nodePackages.typescript
        nodePackages.typescript-language-server
        evince
        #apvlv
        texlive.combined.scheme-small
        multimarkdown
        pipx
        #djview
        #ditaa
        #graphviz
        #guix
        #git shell scripts
        gitIdentity
        gitImport                              #utils
        gitMaintain
        gitValid
        gitCheck
        branchProtect
        ksh                                   #for sdf
        cron
        zdns
        #libsForQt5.kgpg                       #for emacs
        qtpass
        #pkgsUnstable.emacs29-pgtk
        wget
        pinentry
        gnupg1
        busybox
        pwgen
        xorg.xdpyinfo
        xkbvalidate
        flameshot
        nyxt
	lieer
        weston
        mpv
        chromium
        foot.terminfo
        nushell
        openssl
        haproxy
        bsd-finger
        bat
        nixos-option
        nix-index
        ouch
        aria
        jmtpfs
        any-nix-shell
        arandr
        bottom
        dig
        drawio
        exa
        lsd
        (lib.hiPrio parallel)
        moreutils
        fd
        duf
        mu
        redsocks
        isync
        zfstools
        step-cli
        certmgr
        stunnel
        #branch later
        # order of packages matter since both main and ext are enabled globally
        (pkgs.pass.withExtensions (exts: [
        exts.pass-otp
        exts.pass-audit
        exts.pass-genphrase
        exts.pass-import
        exts.pass-tomb
        exts.pass-update
        ]
        ))
        ripgrep
        ranger
        rage
        tree
        flameshot
        tmuxinator
        borgbackup
        (lib.hiPrio emacsPkg)
        (lib.hiPrio aspell)
	(aspellWithDicts (dicts: with dicts; [ en en-computers en-science es]))
        #pass-wayland
        #commented out to avoid collisions, add wl, user adn enable for them
        dmenu
        rofi-pass
        (lib.hiPrio pass-nodmenu)
        #pass
        wofi
      ];

  };

    programs =
      {

        bash = {
          enable = true;
          sessionVariables = {
            EDITOR = "emacs";
            GPG_TTY = "$(tty)";
            SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
            #pinentry = "./$HOME/.nix-profile/bin/pinentry";
            PASSWORD_STORE_GPG_OPTS="--no-throw-keyids";
            
    };
        initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
    historyIgnore = [ "ls" "cd" "exit" ];
    historyControl = [ "ignoredups" "ignorespace" ];
    bashrcExtra = ''
      . ~/oldbashrc
      . ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      . ~/.nix-profile/lib/stunnel
            ## only for wayland to get foot to work
             # WAYLAND_DISPLAY='wayland-1'
             # export $WAYLAND_DISPLAY
             #foot = "WAYLAND_DISPLAY=wayland-1 foot";
             #export XDG_SESSION_TYPE=wayland
      #update to current gpg config
      export GPG_TTY
      export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export
GIT_SSL_CAINFO="/etc/ssl/certs/ca-certificates.crt"

export NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
export DOCKER_HOST=unix:///run/podman/podman.sock
export PASSWORD_STORE_ENABLE_EXTENSIONS="true"
export PASSWORD_STORE_EXTENSIONS_DIR="$HOME/.nix-profile/lib/password-store/extensions";
export PASSWORD_STORE_DIR="$HOME/.password-store";
    '';
    shellAliases = {
      # Shell basics
      #alias pinentry = "./$HOME/.nix-profile/bin/pinentry";
      #alias gpg = "gpg --pinentry-mode loopback";
    };
  };

  fish = {
    enable = true;
    package = pkgs.fish;
    plugins = [{
      name="foreign-env";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-foreign-env";
        rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
        sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
      };
    }];
# use gpg instead of ssh-agent
    shellInit = let fishUserPaths =
      builtins.concatStringsSep " "
        [ "$HOME/.nix-profile/bin"
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
        ];
                in ''
                   set fish_user_paths '${fishUserPaths}'
                    '';
    shellAliases = {
      #foot = "WAYLAND_DISPLAY=wayland-1 foot";
      #pinentry = "~/.nix-profile/bin/pinentry";
    };
  };
  foot =
    {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          #font = "Jetbrains Mono:size=11";
          dpi-aware = "yes";
        };
        mouse = {
          hide-when-typing = "yes";
        };
      };
    };

# now import it
        gpg = {
          enable = true;
          # goes to gpg.conf
          settings = {
            default-key = "1FB20D8EE8067117";
            keyid-format = "0xlong";
            pinentry-mode = "loopback";
              no-emit-version = true;
              charset = "utf-8";
              fixed-list-mode = true;
              list-options = "show-uid-validity";
              verify-options = "show-uid-validity";
              with-fingerprint = true;
              require-cross-certification = true;
              no-symkey-cache = true;
              use-agent = true;
          };
        };
        zsh = {
          enable = true;
           enableCompletion = true;
          shellAliases = {
            pbcopy = "xclip -selection c";
            pbpaste = "xclip -selection clipboard -o";
          };

          initExtra = pkgs.lib.mkOrder 1501 ''
            if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
            source "${pkgs.bash-preexec}/share/bash/bash-preexec.sh"
            eval "$(${pkgs.atuin}/bin/atuin init bash)"
            fi
          '';
        };
        fzf = {
          enable = true;
          enableZshIntegration = true;
        };
        ssh =
          { enable = true;
            extraConfig = "AddKeysToAgent yes";
          };
        # shadow-client = {
        #   # Enabled by default when using import
        #   # enable = true;
        #   channel = "prod";
        #   };
        #extra-container.enable = true;
        
        emacs = { enable = true;
                  package = pkgs.emacs29;
		  extraPackages = epkgs: with epkgs; [
    emacsPkg
    #permission denied, overlay & use-package
    #pdf-tools
    #org-pdftools
    ];
#                      extraConfig = ''
#      (setq standard-indent 2)
#      (load-file "~/.emacs.d/init.el")
#    '';
                };
      
        tmux = { enable = true;
                 package = pkgs.tmux;
                 aggressiveResize = true;
                 clock24 = true;
                 # disableConfirmationPrompt = true;
                 extraConfig = ''
                      set -g allow-rename on
                      set -g set-titles on
                      set -ga terminal-overrides ",xterm-foot:Tc"
                    '';
                    plugins = [ pkgs.tmuxPlugins.sensible ];
                    secureSocket = false;
                    terminal = "screen-256color";
                  };
                  browserpass = {
                  enable = true;
                  browsers = ["firefox" "chrome"];
                  };

          keychain =
            {
              enable = true;
            };
            direnv = {
              enable = true;
              nix-direnv.enable = true;

            };
            starship = {
              enable = true;
              settings = {
                add_newline = false;
                character = {
                  # success_symbol = "[x]bold green";
                  # error_symbol = "[x]bold red";
                };
            };
            };
## now import it
      git = {
        enable = true;

        extraConfig = {
          user.signingkey = "1FB20D8EE8067117";
          commit.gpgsign = true;
          merge.gpgsign = true;
          #gpg.format = "ssh";
          #user variables;
          user.useConfigOnly = true;
          # the `push` identity
          user.push.name = "carnotweat";
          user.push.email = "847157+carnotweat@users.noreply.github.com";
          # the `commit` identity - fake as git doesn't take same authentic ID, for personal and commit, need not be work or personal.
          user.commit.name = "carnotweat";
          user.commit.email = "847157+carnotweat@users.noreply.github.com";
        user.merge.name = "carnotweat";
        user.merge.email = "847157+carnotweat@users.noreply.github.com";
        };
        aliases = {
          identity = "! git-identity";
          id = "! git-identity";
          amend = "commit --amend -C HEAD";
        };
        extraConfig = {
          core = {
            pager             = "${pkgs.less}/bin/less --tabs=4 -RFX";
            logAllRefUpdates  = true;
            precomposeunicode = false;
            whitespace        = "trailing-space,space-before-tab";
          };
        };

      };
      foot.server.enable = true;
      # upgrade it to 121
      firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
  #can't force wayland yet
      #forceWayland = false;
      extraPolicies = {
        ExtensionSettings = {};
        };
    };
  };
      };

#now import this as service, goes to gpg-agent.conf
services.gpg-agent = {
  enable = true;
  #goes to gpg-agent.conf
  defaultCacheTtl = 1800;
  enableSshSupport = true;
  #defaultCacheTtl = 36000;
  maxCacheTtl = 36000;
  defaultCacheTtlSsh = 36000;
  maxCacheTtlSsh = 36000;
  extraConfig = ''
    pinentry-program ${pkgs.pinentry}/bin/pinentry-curses
    allow-emacs-pinentry
    allow-loopback-pinentry
  '';
};

#services.haproxy.enable = true;
# services.ssh-over-tls = {
#   cert_pem = ./modules/stunnel.pem;
#   sshd_port = 22;
#   httpd_port = 80;
#   tls_port = 443;
# };
#services.kanshi.systemdTarget = '';
#services.guix.enable = true;
services.emacs = {
  enable = true;
  package = pkgs.emacs29;
  # extraPackages = epkgs: with epkgs; [
  #   emacsPkg
  #   ];
};
#Starting Emacs Daemon with systemd

systemd.user.services.emacs.Unit = {
  After = [ "graphical-session-pre.target" ];
  PartOf = [ "graphical-session.target" ];
};
#systemd.user.startServices = "sd-switch";
#services.resilio.enable = true;

#services.emacs.package = pkgs.emacs29-pgtk;
# services.emacs.package = with pkgs; ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: [ epkgs.mu4e ]));
#to be uncommented after testing that everything on sway works
  # wayland.windowManager.sway = {
  #   enable = true;
  #   config = rec {
  #     modifier = "Mod4";
  #     # Use kitty as default terminal
  #     terminal = "kitty";
  #     startup = [
  #
  #       {command = "chromium";}
  #     ];
  #   };
  # };
manual.manpages.enable = false;
# manual.html.enable = false;
# manual.json.enable = false;
programs.home-manager.enable = true;
      }
