{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  package = pkgs.ungoogled-chromium;
  cfg = config.home.programs.chromium;
in
{
  options = {
    home.programs.chromium.enable = mkEnableOption "Enables chromium";
  };
  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium;
      # extensions =
      #   # Fetch snippet from @SandroHc
      #   let
      #     createChromiumExtensionFor =
      #       browserVersion:
      #       {
      #         id,
      #         sha256,
      #         version,
      #       }:
      #       {
      #         inherit id;
      #         crxPath = builtins.fetchurl {
      #           url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
      #           name = "${id}.crx";
      #           inherit sha256;
      #         };
      #         inherit version;
      #       };
      #     createChromiumExtension = createChromiumExtensionFor (pkgs.lib.versions.major package.version);
      #   in
      #   [
      #     # uBlock Origin
      #     (createChromiumExtension {
      #       id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      #       sha256 = "sha256:0c2y84bwyliqkff7xn6swvg6fbsprc65p79bvnxdh88wzqyhf3pd";
      #       version = "1.67.0";
      #     })
      #     # Sponsorblock
      #     (createChromiumExtension {
      #       id = "mnjggcdmjocbbbhaepdhchncahnbgone";
      #       sha256 = "sha256:0v86g3d12bnwwzvi482wfdw0qdiqhr26v0jzrd36cji744vybwca";
      #       version = "6.1.0";
      #     })
      #     # Return dislike
      #     (createChromiumExtension {
      #       id = "gebbhagfogifgggkldgodflihgfeippi";
      #       sha256 = "sha256:0svqnwj0vnl9cwl6jwbc6iczvl79fj0yqmj1ii61j06bazscjzlv";
      #       version = "4.0.2";
      #     })
      #     # Bitwarden
      #     (createChromiumExtension {
      #       id = "nngceckbapebfimnlniiiahkandclblb";
      #       sha256 = "sha256:1njzbgk4y4jr6x361d3v0wsn6v8g4rsjr27lx66414x9bpcnrr5w";
      #       version = "2025.11.0";
      #     })
      #   ];
    };
  };
}
