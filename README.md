# GitHub Pages to Substack

GitHub Pages remains the canonical source. This workflow exports only approved,
opted-in articles to a separate, unlimited, full-text RSS feed. It does not log
into Substack, import posts, publish there, send emails, or store credentials.
There are no Substack APIs, session cookies, or browser-automation dependencies.

## Select and Review

Add exactly this boolean to an existing article's YAML frontmatter:

```yaml
substack: true
```

Do not change its original date, permalink, title, body, or other metadata.
Omitting the flag, using `false`, or using the string `"true"` excludes a post.
`published: false`, `draft: true`, `_drafts`, and future-dated posts are excluded
even if a diagnostic Jekyll build exposes them. There is no latest-10/latest-20
limit. The current review selection is the November 4 midterms article and the
July 17 Oracle article. These flags are export eligibility, not approval to
publish on Substack.

Install the Gemfile dependencies with Bundler and install librsvg:

```sh
brew install librsvg                 # macOS
# Debian/Ubuntu: apt-get install librsvg2-bin fonts-dejavu-core fonts-liberation
bundle install
bundle exec ruby test/substack_export_test.rb
bundle exec ruby scripts/build-substack.rb /tmp/j-abed-substack-preview
bundle exec ruby scripts/validate-substack.rb /tmp/j-abed-substack-preview
```

On this Mac, prepend `PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"` to the Bundler
commands to use the working Ruby 3.3 installation. The build wrapper explicitly
loads the export hook after the `github-pages` gem initializes; a plain
`bundle exec jekyll build` suppresses custom plugin discovery. Legacy/safe-mode
builds produce an empty feed marked `disabled`, and export validation rejects it.

The validator prints the complete selected list with original dates. Inspect
`/tmp/j-abed-substack-preview/substack-export/manifest.json` for canonical URLs,
content fingerprints, image files, and review warnings. Review every full-text
HTML preview before importing. For local review:

```sh
ruby -run -e httpd /tmp/j-abed-substack-preview -p 4178
```

Open `http://localhost:4178/substack-export/`. Preview images use local paths;
the actual RSS always uses publicly accessible absolute HTTPS URLs.

## Activate GitHub Pages

The export workflow requires GitHub Actions publishing instead of the legacy
Pages build. Set **Settings > Pages > Build and deployment > Source** to
**GitHub Actions**. Push approved changes to `main` or run
**Build and Deploy Pages** manually to deploy.
The workflow runs regression tests, builds through the explicit wrapper,
validates the export, and uploads the whole site including generated PNGs.
Pull requests build and validate but do not deploy. Only GitHub Pages is deployed;
there is no automatic Substack publication or email step.

After a successful deployment, review:

- Feed: `https://j-abed.github.io/substack-feed.xml`
- Selected list and previews: `https://j-abed.github.io/substack-export/`
- Manifest: `https://j-abed.github.io/substack-export/manifest.json`

Check that the live feed has `export:status` equal to `ready`, the reviewed post
count, and original `pubDate` values. Open every generated image on the public
site before giving the feed to Substack. Do not use the existing all-post Atom
feed for selective import; it remains unchanged.

## Historical Backfill

1. Review the selected list, dates, complete article text, captions, images,
	 citations, and appendices. Approve this exact batch explicitly before import.
2. In Substack, open **Settings > Import/Export > Import posts** and paste the
	 dedicated public feed URL, not the home page or all-post Atom feed.
3. Review the discovered archive and count. Keep the articles free unless a
	 different audience has been expressly approved. The final import confirmation
	 publishes web posts; importing is not a draft-only staging operation.
4. Confirm ownership and Substack's terms only when ready to publish the reviewed
	 batch. Do not confirm a bulk import merely to preview its results.
5. Check the imported articles against the manifest: original publication dates,
	 full text, chart captions, source links, table rows, appendix, and canonical
	 footer. Correct any imported date in that post's settings to match the manifest.
6. Leave **Send via email and the Substack app** off for archival imports and
	 corrections. Imported posts appear on the web; emailing is a separate action.

If the importer cannot use this feed or you need draft-first review, manually
copy the rendered preview into a Substack draft, upload the generated PNG files
if necessary, and review it without publishing. On explicitly approved web-only
publication, restore the original publication date in the post's settings.
Substack's own instructions document this manual fallback. Never edit or
re-date the GitHub Pages original to work around an importer problem.

## Future Posts and Updates

For each future article, finish and publish the canonical GitHub Pages article,
add `substack: true` when appropriate, rebuild, and review the new manifest.
The export updates automatically with the site; Substack is not automatically
subscribed or synchronized to this feed. Re-import through the same manual UI
only after approving the new/updated batch.

On re-import, select **Update existing posts**. Canonical article URLs are stable
RSS links and GUIDs, and original dates never become build dates. This helps the
importer identify existing articles, but Substack does not document a guaranteed
GUID-to-post matching algorithm: test one existing article before repeating a
large import. Review the candidate count and date mapping before confirmation.
Maintain a private ledger of canonical URL, Substack URL, original date, and last
approved `content_sha256`; the generated manifest supplies those source fields.

If **Update existing posts** is absent or matching is uncertain, stop the
re-import and manually edit the mapped existing Substack post. Do not create a
duplicate. Do not resend corrections automatically. Removing a flag removes
that article from future exports, not from Substack; deletion there is manual.

To intentionally email a newly approved article, edit that one Substack post,
choose **Continue**, review audience and delivery, and explicitly select
**Send via email and the Substack app**. This is a separate approval from web
import. Never send the historical archive as a newsletter batch.

## Export Presentation

- Full rendered HTML is XML-escaped in `content:encoded`, not shortened to an excerpt.
- Inline and local external SVG charts become white-background PNGs at 3x width
	(minimum 1600, maximum 8192 pixels). Original SVG assets remain untouched.
- Simple tables become one stacked paragraph per original row, with exact column
	labels and cell content, so they do not require horizontal email scrolling.
	Merged-cell/multi-header tables fail clearly instead of silently losing data.
- Appendix disclosures become expanded sections. Scripts, controls, stylesheet
	dependencies, and chart tooltip UI are removed, not article prose.
- Iframes, canvas, video/audio, and embedded objects become an original-content
	link and, when available, a static image. Configure a preview without modifying
	the article in `_config.yml`:

```yaml
substack:
	static_images:
		/article-permalink: /assets/article/static-preview.png
```

Missing previews stop the build; replacements produce manifest review warnings.
Existing video posters can be reused. Unknown script-only widgets require a manually prepared
static illustration and review; this exporter cannot execute JavaScript to
discover their content. External SVGs must be supplied as local PNGs or made
self-contained locally. No arbitrary remote assets are downloaded during build.
Existing external bitmap URLs remain absolute and must be checked manually.

Generated files live only in the build destination, under `assets/substack/`
and `substack-export/`. No original Markdown body is rewritten. Stable
content-addressed images avoid timestamp-dependent links within a consistent
renderer/font environment; PNG bytes may differ across operating systems or
renderer upgrades, without changing article GUIDs or original dates.

Generated images are rebuilt from the current selection, not kept as a permanent
archive. Before changing charts or removing a flag, verify that Substack has
copied the images into its own storage, or upload permanent copies there during
the approved edit. An older content-addressed source image may otherwise need
re-import after a rebuild. Do not assume the importer rehosts every image.

Local preview/validation does not prove Substack's final sanitizer and editor
will retain all formatting. An explicitly reviewed account import is still
required to verify the actual Substack result. No account import was performed.

## Official References

- [Substack: importing posts and Update existing posts](https://support.substack.com/hc/en-us/articles/360037830351)
- [Substack: imported posts and email delivery](https://support.substack.com/hc/en-us/articles/360041912391)
- [GitHub: custom Pages workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)

Documentation checked November 5, 2026. Review current UI options before each
import; they are not controlled by this repository.
