# Used by update-formula.sh: sets each release URL's version and the sha256 under it.
BEGIN {
  n = split(ENVIRON["SUMS"], lines, "\n")
  for (i = 1; i <= n; i++) {
    split(lines[i], f, " ")
    if (length(f[1]) == 64) sha[f[2]] = f[1]
  }
}
/url "https:\/\/github.com\/Dino-HQ\/dino\/releases\/download\// {
  sub(/download\/v[^\/]+\//, "download/v" version "/")
  asset = $0
  sub(/.*\//, "", asset)
  sub(/".*/, "", asset)
  if (!(asset in sha)) { print "no sha256 for " asset " in v" version " SHA256SUMS" > "/dev/stderr"; exit 1 }
  print
  next
}
/sha256 "/ && asset != "" {
  sub(/sha256 "[^"]*"/, "sha256 \"" sha[asset] "\"")
  asset = ""
}
{ print }
