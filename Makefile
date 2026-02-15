# ==============================================================================
# Makefile for academic webpage
# ==============================================================================
# Usage:
#   make serve          — Start local dev server with live reload
#   make new-post       — Scaffold a new blog post
#   make new-pub        — Scaffold a new publication
#   make new-talk       — Scaffold a new talk
#   make new-teaching   — Scaffold a new teaching entry
#   make generate-pubs  — Regenerate publications from TSV
#   make generate-talks — Regenerate talks from TSV
#   make build          — Build the site for production
#   make clean          — Remove generated site files
# ==============================================================================

.PHONY: serve build clean new-post new-pub new-talk new-teaching generate-pubs generate-talks

# ---------------------------------------------------------------------------
# Local Development
# ---------------------------------------------------------------------------

serve:
	bundle exec jekyll serve --livereload

build:
	bundle exec jekyll build

clean:
	bundle exec jekyll clean

# ---------------------------------------------------------------------------
# Content Scaffolding
# ---------------------------------------------------------------------------
# Each target prompts for a title, generates a filename with today's date,
# copies the matching template, and fills in the date/slug placeholders.
# ---------------------------------------------------------------------------

DATE := $(shell date +%Y-%m-%d)
YEAR := $(shell date +%Y)
MONTH := $(shell date +%m)

new-post:
	@read -p "Post title: " title; \
	slug=$$(echo "$$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$$//'); \
	file="_posts/$(DATE)-$$slug.md"; \
	sed -e "s/YYYY-MM-DD/$(DATE)/g" \
	    -e "s|YYYY/MM/your-url-slug|$(YEAR)/$(MONTH)/$$slug|g" \
	    -e "s/Your Post Title/$$title/" \
	    _templates/post.md > "$$file"; \
	echo "✓ Created $$file"

new-pub:
	@read -p "Publication title: " title; \
	slug=$$(echo "$$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$$//'); \
	read -p "Publication date (YYYY-MM-DD) [$(DATE)]: " pubdate; \
	pubdate=$${pubdate:-$(DATE)}; \
	file="_publications/$$pubdate-$$slug.md"; \
	sed -e "s/YYYY-MM-DD/$$pubdate/g" \
	    -e "s/YYYY-MM-DD-url-slug/$$pubdate-$$slug/g" \
	    -e "s/Your Paper Title/$$title/" \
	    _templates/publication.md > "$$file"; \
	echo "✓ Created $$file"

new-talk:
	@read -p "Talk title: " title; \
	slug=$$(echo "$$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$$//'); \
	read -p "Talk date (YYYY-MM-DD) [$(DATE)]: " talkdate; \
	talkdate=$${talkdate:-$(DATE)}; \
	file="_talks/$$talkdate-$$slug.md"; \
	sed -e "s/YYYY-MM-DD/$$talkdate/g" \
	    -e "s/YYYY-MM-DD-url-slug/$$talkdate-$$slug/g" \
	    -e "s/Your Talk Title/$$title/" \
	    _templates/talk.md > "$$file"; \
	echo "✓ Created $$file"

new-teaching:
	@read -p "Course title: " title; \
	slug=$$(echo "$$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$$//'); \
	file="_teaching/$(YEAR)-$$slug.md"; \
	sed -e "s/YYYY-MM-DD/$(DATE)/g" \
	    -e "s/YYYY-course-slug/$(YEAR)-$$slug/g" \
	    -e "s/Course Title/$$title/" \
	    _templates/teaching.md > "$$file"; \
	echo "✓ Created $$file"

# ---------------------------------------------------------------------------
# Markdown Generators (from TSV data)
# ---------------------------------------------------------------------------

generate-pubs:
	cd markdown_generator && python publications.py
	@echo "✓ Regenerated publications from TSV"

generate-talks:
	cd markdown_generator && python talks.py
	@echo "✓ Regenerated talks from TSV"
