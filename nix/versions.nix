{ pkgs }:

# Central version definitions for the dev shell.
#
# When bumping a version here, sync the matching var in Taskfile.yml
#   PYTHON_VERSION  → pythonVersion
#   NODE_VERSION    → nodeVersion
#   GOLANG_VERSION  → goVersion
#   TERRAFORM_VERSION → terraformVersion

rec {
  python = pkgs.python311;
  pythonVersion = "3.11";

  nodejs = pkgs.nodejs_24;
  nodeVersion = "24";

  go = pkgs.go;
  goVersion = "1.24";

  terraform = pkgs.terraform;
  terraformVersion = "1.11";
}
