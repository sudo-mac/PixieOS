{pkgs, ...}: {
  services.minecraft-servers.servers.fabric.symlinks.mods =
    pkgs.linkFarmFromDrvs "mods"
    (
      builtins.attrValues {
        Fabric-API = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/9YVrKY0Z/fabric-api-0.115.0%2B1.21.1.jar";
          sha512 = "e5f3c3431b96b281300dd118ee523379ff6a774c0e864eab8d159af32e5425c915f8664b1cd576f20275e8baf995e016c5971fea7478c8cb0433a83663f2aea8";
        };

        ArchitecturyAPI = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/Wto0RchG/architectury-13.0.8-fabric.jar";
          sha512 = "7a24a0481732c5504b07347d64a2843c10c29e748018af8e5f5844e5ea2f4517433886231025d823f90eb0b0271d1fa9849c27e7b0c81476c73753f79f19302a";
        };

        Sodium = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/AANobbMI/versions/59wygFUQ/sodium-fabric-0.8.2%2Bmc1.21.11.jar";
          sha512 = "0ab706031f954e4acfc0897536dcd182aaced35b912ee05f00a4c79609064c22d4249d7c1399b3359af974b258520664bbeb079d46f2e167f9f4d12ed86aeb37";
        };

        Iris = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/YL57xq9U/versions/Q4YiZeCX/iris-fabric-1.10.4%2Bmc1.21.11.jar";
          sha512 = "e555eb98aa0306d8a6337d4eb9402f7c994906c341bc5f1f0f9929a164bfd88266c714a4446635c961d17228691d0f7b15d8d74917ed5cec5f4fc6feb9d32005";
        };

        ComputerCraft = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/gu7yAYhd/versions/YoUTrY6U/cc-tweaked-1.21.1-fabric-1.117.0.jar";
          sha512 = "14v5ramnraads66rknkp7ki8r93sh8yxylvpwqsf9nnhizhjfzw2dzlwjir0acj656mp8m01djphx7m4wl5qlj3k8hba7wz1861mdpz";
        };

        JustEnoughItems = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/TvqzuFwN/jei-1.21.1-fabric-19.27.0.340.jar";
          sha512 = "04d4067931010578b55aee55b1e38f7ea2ea3ce8d258ae5d9ece7facfcfcb41349a457ca8bd2ca502577616b84b1c14dbd00b2985ffc6cde5c3d1ec2dd214a04";
        };

        SkinRestorer = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/d9veLdqw/skinrestorer-2.5.0%2B1.21-fabric.jar";
          sha512 = "c8966ac9f3285c056f285883b67adc7fd1e69a9187c699438c9d58f9cf4e158d5455113a54ef46b8bd1a598e91f8368580dddcf0ebd50421090adbb2bcd5bda0";
        };
      }
    );
}
