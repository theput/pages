---
layout: notebook
title: Lab notes
summary: Build notes and experiment journals, one notebook page at a time.
---

Build notes and experiment journals. Each page is one circuit, one measurement, or one idea.

{% assign notes = site.pages | where: "layout", "notebook" | where_exp: "p", "p.project" | sort: "date" | reverse %}
<ul class="nb-index">
{% for p in notes %}
  <li><a href="{{ p.url | relative_url }}">{{ p.title }}</a> <span class="when">{{ p.project }} · {{ p.date | date: "%-d %b %Y" }}</span></li>
{% endfor %}
</ul>
