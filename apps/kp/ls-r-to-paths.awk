# Turn `keepassxc-cli ls -R` output into full entry paths.
#
# Input (groups end with "/", children are indented two spaces per level,
# groups with no entries show a localized placeholder such as "[vide]"):
#
#   Entry One
#   Travail/
#     Github
#     Sub/
#       Deep
#   Vide/
#     [vide]
#
# Output:
#
#   Entry One
#   Travail/Github
#   Travail/Sub/Deep
{
  match($0, /^ */); depth = RLENGTH / 2; name = substr($0, RLENGTH + 1)
  if (name == "" || name ~ /^\[/) next
  if (name ~ /\/$/) { g[depth] = substr(name, 1, length(name) - 1); next }
  path = ""
  for (i = 0; i < depth; i++) path = path g[i] "/"
  print path name
}
