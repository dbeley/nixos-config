{ inputs, ... }:
{
  home.packages = [ inputs.cursor.packages.x86_64-linux.cursor ];
}
