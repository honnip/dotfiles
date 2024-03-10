{
  boot = {
    plymouth = { enable = true; };
    loader.timeout = 0;
    kernelParams = [
      "quiet"
      "loglevel=4"
      "systemd.show_status=auto" # show only error messages. this might not be needed
      "udev.log_level=3" # stop systemd from printing its version
      "rd.udev.log_level=3" # same ^. but when it's in an initramfs
      "vt.global_cursor_default=0" # hide the cursor on tty
    ];
  };
}
