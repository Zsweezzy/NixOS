{ pkgs, ... }:

{
  # Theme assets live next to this file; home-manager links them into the
  # per-user XDG dirs that Plasma scans.
  home.file = {
    ".local/share/color-schemes/TokyoNightMoon.colors".source = ./plasma/TokyoNightMoon.colors;
    ".local/share/plasma/desktoptheme/Monochrome".source = ./plasma/desktoptheme/Monochrome;
    ".local/share/plasma/look-and-feel/Monochrome".source = ./plasma/look-and-feel/Monochrome;
    ".local/share/aurorae/themes/Monochrome".source = ./plasma/aurorae/Monochrome;

    # Ctrl+Alt+T -> kitty. KGlobalAccel only picks up .desktop files that opt
    # in as command shortcuts, hence the flag. (home.file, not
    # xdg.desktopEntries: that option throws "extraConfig removed" on HM 26.05.)
    ".local/share/applications/kitty-terminal.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Kitty Terminal
      Exec=${pkgs.kitty}/bin/kitty
      NoDisplay=true
      StartupNotify=false
      X-KDE-GlobalAccel-CommandShortcut=true
    '';
  };

  home.packages = with pkgs; [
    bibata-cursors
    papirus-icon-theme
  ];

  # The exact GTK theme from C3PO (~/.local/share/themes), not the nixpkgs
  # Tokyonight-Dark, so GTK apps match the Plasma palette.
  home.file.".local/share/themes/Tokyonight-Dark-Moon".source =
    ./gtk/themes/Tokyonight-Dark-Moon;

  # GTK apps follow the same palette; Plasma drives the Qt side.
  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    theme.name = "Tokyonight-Dark-Moon";
    iconTheme.name = "Papirus-Dark";
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      size = 22;
    };
    gtk3.extraConfig."gtk-decoration-layout" = "icon:minimize,maximize,close";
    gtk4.extraConfig."gtk-decoration-layout" = "icon:minimize,maximize,close";
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "Breeze";
  };

  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "TokyoNightMoon";
      theme = "Monochrome";
      iconTheme = "Papirus-Dark";
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 22;
      };
      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__Monochrome";
      };
      splashScreen.theme = "Monochrome";
      wallpaper = ./plasma/wallpaper.jpg;
      wallpaperFillMode = "preserveAspectCrop";
    };

    # Bottom panel, same widget set as C3PO: launcher, tasks, pager, spacer,
    # tray, clock. Applied by a Plasma desktop script on login.
    panels = [
      {
        location = "bottom";
        height = 44;
        alignment = "center";
        opacity = "adaptive";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.pager"
          { panelSpacer = { expanding = true; }; }
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    shortcuts = {
      "services/kitty-terminal.desktop"._launch = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"._launch = [ ];
    };
  };
}
