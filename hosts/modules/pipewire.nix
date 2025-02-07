{ pkgs, ... }:
{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    extraConfig.pipewire = {
      "99-input-denoising" = {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "DeepFilter Noise Canceling Source";
              "media.name" = "DeepFilter Noise Canceling";
              "filter.graph" = {
                nodes = [
                  {
                    type = "ladspa";
                    name = "DeepFilter Mono";
                    plugin = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                    label = "deep_filter_mono";
                    control = {
                      "Attenuation Limit (dB)" = 100;
                    };
                  }
                ];
              };
              "audio.rate" = 48000;
              "audio.position" = "[MONO]";
              "capture.props" = {
                "node.passive" = true;
              };
              "playback.props" = {
                "media.class" = "Audio/Source";
              };
            };
          }
        ];
      };
    };
  };
}
