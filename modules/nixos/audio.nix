{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # module-x11-bell segfaults in its X11 IO-error handler when the session's X
  # connection dies at logout (loop_destroy_source from inside the callback),
  # which then makes drkonqi abort in a loop. It only plays the terminal bell,
  # and without DISPLAY it is skipped, so strip the display from the service.
  systemd.user.services.pipewire.serviceConfig.UnsetEnvironment = [ "DISPLAY" "XAUTHORITY" ];
}
