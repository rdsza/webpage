---
layout: archive
title: "CV"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

<!-- ============================================================
     This page is driven by _data/cv.yml.
     To update your CV, edit that file — not this template.
     ============================================================ -->

<!-- PDF download available when files/cv.pdf is present -->
{% capture cv_pdf %}{{ base_path }}/files/cv.pdf{% endcapture %}
<a href="{{ cv_pdf }}" class="btn btn--info">Download CV (PDF)</a>

{% if site.data.cv.summary %}
{{ site.data.cv.summary }}
{% endif %}

Education
======
{% for edu in site.data.cv.education %}
* **{{ edu.degree }}**, {{ edu.institution }}, {{ edu.year }}{% if edu.details %}
  * {{ edu.details }}{% endif %}
{% endfor %}

Work experience
======
{% for job in site.data.cv.experience %}
* {{ job.dates }}: **{{ job.title }}**
  * {{ job.institution }}
  * {{ job.description }}{% if job.supervisor %}
  * Supervisor: {{ job.supervisor }}{% endif %}{% if job.highlights %}
  * Key contributions:{% for h in job.highlights %}
    * {{ h }}{% endfor %}{% endif %}
{% endfor %}

Skills
======
{% for skill in site.data.cv.skills %}
* {{ skill.name }}{% if skill.items %}{% for item in skill.items %}
  * {{ item }}{% endfor %}{% endif %}
{% endfor %}

Publications
======
<ul>{% for post in site.publications reversed %}
  {% include archive-single-cv.html %}
{% endfor %}</ul>

Conferences & Workshops
======
{% for conf in site.data.cv.conferences %}
* **{{ conf.title }}**
  * {{ conf.type }} — {{ conf.event }}, {{ conf.location }} ({{ conf.date }})
{% endfor %}

Academic Service & Outreach
======
{% for s in site.data.cv.service %}
* **{{ s.role }}**{% if s.dates != "" %} ({{ s.dates }}){% endif %}{% if s.description != "" %}
  * {{ s.description }}{% endif %}
{% endfor %}

Mentorship
======
{% for m in site.data.cv.mentorship %}
* {{ m.name }} — {{ m.role }}{% if m.dates != "" %} ({{ m.dates }}){% endif %}
{% endfor %}

Grants & Fellowships
======
{% for g in site.data.cv.grants %}
* **{{ g.name }}**, {{ g.funder }} ({{ g.dates }})
{% endfor %}

Awards
======
{% for a in site.data.cv.awards %}
* **{{ a.name }}**{% if a.event %}, {{ a.event }}{% endif %}{% if a.year %} ({{ a.year }}){% endif %}{% if a.funder %}, {{ a.funder }}{% endif %}{% if a.dates %} ({{ a.dates }}){% endif %}
{% endfor %}

Languages
======
{% for l in site.data.cv.languages %}
* {{ l.language }} ({{ l.level }})
{% endfor %}

{% if site.data.cv.certifications %}
Certifications
======
{% for c in site.data.cv.certifications %}
* **{{ c.name }}**, {{ c.institution }} ({{ c.year }})
{% endfor %}
{% endif %}

Talks
======
<ul>{% for post in site.talks reversed %}
  {% include archive-single-talk-cv.html %}
{% endfor %}</ul>

Teaching
======
<ul>{% for post in site.teaching reversed %}
  {% include archive-single-cv.html %}
{% endfor %}</ul>
