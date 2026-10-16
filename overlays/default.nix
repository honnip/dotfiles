{ inputs, ... }:
{
  additions =
    final: _prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };
}
