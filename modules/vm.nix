{ inputs, lib, ... }:
{
  perSystem = { pkgs, ... }: {
    packages = lib.mapAttrs' (
      hostName: hostSystem:
      lib.nameValuePair "vm-${hostName}" (
        pkgs.writeShellApplication {
          name = "vm-${hostName}";
          text = ''
            ${hostSystem.config.system.build.vm}/bin/run-${hostName}-vm "$@"
          '';
        }
      )
    ) inputs.self.nixosConfigurations;
  };
}
