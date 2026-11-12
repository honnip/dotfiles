{ inputs, ... }:
{
  additions =
    final: _prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };

  # gcr-ssh-agent spawns its askpass shim for passphrase prompts.
  # Replace the shim with a dispatcher: graphical dialog on the
  # desktop, terminal prompt on the tty of an SSH session.
  gcr-askpass-dispatch = _final: prev: {
    gcr_4 = prev.gcr_4.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        mv $out/libexec/gcr4-ssh-askpass $out/libexec/gcr4-ssh-askpass.real
        install -m755 ${./gcr-ssh-askpass-dispatch.sh} $out/libexec/gcr4-ssh-askpass
        substituteInPlace $out/libexec/gcr4-ssh-askpass --replace-fail '@real@' "$out/libexec/gcr4-ssh-askpass.real"
      '';
    });
  };
}
