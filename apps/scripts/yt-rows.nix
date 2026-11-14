{ gawk, writeShellApplication }:
writeShellApplication {
  name = "yt-rows";
  runtimeInputs = [ gawk ];
  text = ''
    # Mise en forme commune aux trois sélecteurs (ytq, ytf, ytc).
    #
    # Entrée : un enregistrement par ligne, champs séparés par \x1f
    #
    #   id  date  durée  vues  chaîne  titre
    #
    #   date   epoch (0 ou vide = inconnue)
    #   durée  secondes, ou « M:SS » / « H:MM:SS »
    #   vues   nombre, ou étiquette de YouTube (« 686,562 views », « 2.2M
    #          views ») ; vide = inconnu, « 1,234 watching » est ignoré
    #
    # Sortie : une ligne par vidéo pour fzf, terminée par \0
    #
    #   ID│AAAA-MM-JJ HH:MM  titre
    #      durée · vues · chaîne
    #
    # Les champs vides sont omis et l'ordre d'entrée est conservé : c'est le
    # seul endroit où le format d'affichage est décidé.
    exec gawk -F'\x1f' '
      # « 686,562 views », « 2.2M views », « 948 » -> nombre
      function to_views(s,   u, mul, k, last, bare) {
        if (s == "") return ""
        if (s ~ /^[0-9]+$/) return s + 0
        sub(/[ ]*(views?|vues?|de vues)$/, "", s)
        gsub(/ /, "", s)
        if (s !~ /^[0-9][0-9.,]*[KMBkmb]?[dD]?$/) return ""
        mul = 1
        if (match(s, /[KMBkmb][dD]?$/)) {
          u = toupper(substr(s, RSTART, RLENGTH))
          s = substr(s, 1, RSTART - 1)
          if (u == "K") {
            mul = 1000
          } else if (u == "MD" || u == "B") {
            mul = 1000000000
          } else {
            mul = 1000000
          }
        }
        # « 686,562 » : séparateurs de milliers ; « 2,2 » : virgule décimale
        bare = gensub(/[.,]/, "", "g", s)
        k = length(s) - length(bare)
        last = s
        sub(/^.*[.,]/, "", last)
        if (k == 1 && length(last) < 3) {
          sub(/,/, ".", s)
        } else {
          s = bare
        }
        return int(s * mul + 0.5)
      }

      function to_secs(s,   p, n, i, k) {
        if (s == "") return 0
        if (s !~ /:/) return s + 0
        k = split(s, p, ":")
        n = 0
        for (i = 1; i <= k; i++) n = n * 60 + p[i]
        return n
      }

      function fmt_dur(s,   n, h, m, r) {
        n = to_secs(s)
        if (n <= 0) return ""
        h = int(n / 3600)
        m = int((n % 3600) / 60)
        r = n % 60
        if (h > 0) return sprintf("%d:%02d:%02d", h, m, r)
        return sprintf("%d:%02d", m, r)
      }

      function human(v,   n) {
        n = v + 0
        if (n >= 1000000000) return sprintf("%.1f Md", n / 1000000000)
        if (n >= 1000000) return sprintf("%.1f M", n / 1000000)
        if (n >= 1000) return sprintf("%.0f k", n / 1000)
        return sprintf("%d", n)
      }

      function clean(s) {
        gsub(/│/, "¦", s)
        gsub(/\t/, " ", s)
        return s
      }

      {
        id = $1
        if (length(id) != 11) next

        when = ($2 + 0 > 0) ? strftime("%Y-%m-%d %H:%M", $2 + 0) : ""

        meta = fmt_dur($3)
        v = to_views($4)
        if (v != "") {
          lab = (v == 1) ? " vue" : " vues"
          meta = (meta == "" ? "" : meta " · ") human(v) lab
        }
        if ($5 != "") meta = (meta == "" ? "" : meta " · ") $5

        printf "%s│%-16s  %s\n   %s%c", id, clean(when), clean($6), clean(meta), 0
      }
    '
  '';
}
