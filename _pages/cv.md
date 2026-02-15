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

<a href="{{ base_path }}/files/cv.pdf" class="btn btn--info">Download CV (PDF)</a>

Education
======
{% for edu in site.data.cv.education %}
* {{ edu.degree }}, {{ edu.institution }}, {{ edu.year }}
{% endfor %}

Work experience
======
{% for job in site.data.cv.experience %}
* {{ job.dates }}: {{ job.title }}
  * {{ job.institution }}
  * {{ job.description }}{% if job.supervisor %}
  * Supervisor: {{ job.supervisor }}{% endif %}
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
