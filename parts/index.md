# Parts inventory

The full parts list — the single URL every label points to for now.

**Source of truth:** [`parts.csv`](parts.csv) in this folder. Edit that file (any
spreadsheet or text editor), commit, and the table below updates automatically. A
raw CSV doesn't render on its own, so this page reads it and draws the table.

<input id="parts-filter" type="search" placeholder="Filter parts…"
       style="width:100%;max-width:420px;padding:8px 10px;margin:0 0 12px;
              font-size:1em;border:1px solid #ccc;border-radius:6px" />
<div id="parts-table">Loading parts…</div>

<script>
(function () {
  function parseCSV(text) {
    var rows = [], row = [], field = '', inq = false;
    for (var i = 0; i < text.length; i++) {
      var c = text[i];
      if (inq) {
        if (c === '"') { if (text[i + 1] === '"') { field += '"'; i++; } else inq = false; }
        else field += c;
      } else if (c === '"') { inq = true; }
      else if (c === ',') { row.push(field); field = ''; }
      else if (c === '\n' || c === '\r') {
        if (c === '\r' && text[i + 1] === '\n') i++;
        row.push(field); rows.push(row); row = []; field = '';
      } else field += c;
    }
    if (field.length || row.length) { row.push(field); rows.push(row); }
    return rows.filter(function (r) { return !(r.length === 1 && r[0] === ''); });
  }

  fetch('parts.csv', { cache: 'no-store' })
    .then(function (r) { return r.text(); })
    .then(function (text) {
      var rows = parseCSV(text.trim());
      if (!rows.length) { document.getElementById('parts-table').textContent = 'No parts yet.'; return; }
      var head = rows[0], body = rows.slice(1);
      var html = '<table style="border-collapse:collapse;width:100%">';
      html += '<thead><tr>' + head.map(function (h) {
        return '<th style="text-align:left;border-bottom:2px solid #444;padding:6px 10px">' + h + '</th>';
      }).join('') + '</tr></thead><tbody>';
      html += body.map(function (r) {
        return '<tr>' + head.map(function (_, i) {
          return '<td style="border-bottom:1px solid #ddd;padding:6px 10px">' + (r[i] || '') + '</td>';
        }).join('') + '</tr>';
      }).join('');
      html += '</tbody></table>';
      var container = document.getElementById('parts-table');
      container.innerHTML = html;

      var filter = document.getElementById('parts-filter');
      filter.addEventListener('input', function () {
        var q = filter.value.toLowerCase();
        container.querySelectorAll('tbody tr').forEach(function (tr) {
          tr.style.display = tr.textContent.toLowerCase().indexOf(q) > -1 ? '' : 'none';
        });
      });
    })
    .catch(function () {
      document.getElementById('parts-table').innerHTML =
        'Could not load <a href="parts.csv">parts.csv</a>.';
    });
})();
</script>

---

*To add a part: append a row to `parts.csv` in the form
`Category,Item,Qty,Bin,Notes`. Next step will give each category its own page/URL;
for now this single list is where all labels point.*
