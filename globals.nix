rec {
  # user information
  username = "aaron";
  userfullname = {
    first = "Aaron";
    last = "Bushnell";
    full = "Aaron Bushnell";
  };
  useremail = "aabushnell@gmail.com";

  allTargetAttrs = {
    # linux
    x86_linux = "x86_64-linx";
    # darwin
    aarch64_darwin = "aarch64-darwin";
  };

  allTargets = builtins.attrValues allTargetAttrs;
}
