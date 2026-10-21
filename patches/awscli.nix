{ pkgs }:
old:
if old.version == "1.44.21" then
  {
    # AWS CLI 1.46 bundles its matching botocore and s3transfer versions.
    # The nixpkgs 1.44.21 package requires older SDKs than nixpkgs provides.
    version = "1.46.1";
    src = pkgs.fetchFromGitHub {
      owner = "aws";
      repo = "aws-cli";
      tag = "1.46.1";
      hash = "sha256-qA4FOgzulvGDQoCDeooID/A7ASfVi25NJayOxTc6wqo=";
    };

    dependencies =
      with pkgs.python3Packages;
      [
        docutils
        pyyaml
        colorama
        rsa
        jmespath
        python-dateutil
        urllib3
      ]
      ++ [
        pkgs.groff
        pkgs.less
      ];

    installCheckPhase = ''
      runHook preInstallCheck

      $out/bin/aws --version | grep -F 'aws-cli/1.46.1'
      AWS_EC2_METADATA_DISABLED=true $out/bin/aws s3api list-buckets \
        --generate-cli-skeleton input > /dev/null

      runHook postInstallCheck
    '';
  }
else
  { }
