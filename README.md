# Fieldnote: the Wbcom EmDash plugin showcase

A standard EmDash 1.2 blog site (made with `npm create emdash@latest --template blog --platform node`) running all five Wbcom EmDash plugins with realistic content. Fieldnote is a made-up notes app company. The site shows how each plugin looks and works on an ordinary EmDash site, and it is the model data every plugin is built and tested against.

| Plugin | What Fieldnote uses it for | Pages |
| --- | --- | --- |
| [Listora](https://plugins.emdashcms.com/plugins/@vapvarun.bsky.social/listora) | A partner directory: 10 consultants and trainers with photos, a map and city filters | `/listings/` |
| [WB Reviews](https://plugins.emdashcms.com/plugins/@vapvarun.bsky.social/reviews) | Star ratings and reviews under blog posts, with owner replies | every post |
| [WB Polls](https://plugins.emdashcms.com/plugins/@vapvarun.bsky.social/polls) | A poll on every post, one on a single post, one on the About page | posts, `/pages/about` |
| [Product Roadmap](https://plugins.emdashcms.com/plugins/@vapvarun.bsky.social/roadmap) | A public roadmap with voting and a changelog | `/roadmap/`, `/changelog/` |
| [KnowX](https://plugins.emdashcms.com/plugins/@vapvarun.bsky.social/knowx) | A help center with topics, articles, FAQs and search | `/docs/` |

## Run it

Needs Node.js 22.16 or later and `sqlite3`.

```bash
npm install
bash scripts/build-model-site.sh   # builds data.db from model/: content, menus, categories, photos
npm run dev                          # http://localhost:4321
```

Then sign in to the admin, open **Plugins**, then **Registry**, and install Listora, WB Reviews, WB Polls, Product Roadmap and KnowX. The content types they use already exist. Each plugin's own guide covers its settings.

`model/` holds only authored content and stock photos. The database (`data.db`) and `.env` are never committed.

## What is site code here

Everything under `src/` that is not part of the EmDash blog template was copied from each plugin's site kit by following that plugin's install guide:

- `src/pages/listings/`, `src/listora-block/`, `src/lib/listora.ts`: Listora
- `src/components/Reviews.astro`, `RatingBadge.astro`, `src/lib/reviews-strings.ts`: WB Reviews
- `src/components/Poll.astro`, `PollSlot.astro`, `MyVotes.astro`, `src/lib/polls-strings.ts`: WB Polls
- `src/pages/roadmap/`, `src/pages/changelog/`, `src/components/VoteButton.astro`, `src/lib/roadmap-*.ts`: Product Roadmap
- `src/pages/docs/`, `src/components/DocSearch.astro`, `Helpful.astro`, `StillNeedHelp.astro`, `src/lib/knowx*.ts`: KnowX
- `src/lib/wbcom-kit.ts`, `src/styles/wbcom-base.css`: shared by all five

The post and page templates (`src/pages/posts/[slug].astro`, `src/pages/pages/[slug].astro`) place the rating badge, reviews and poll slot with the entry's own id (`post.data.id`, `page.data.id`).

## Good to know

- The admin sign-in shortcut `/_emdash/api/setup/dev-bypass` resets the main menu and footer to the blog template's defaults. Run `scripts/build-model-site.sh` again to restore them, or sign in another way.
- Plugin developers do not work on this site: they load the same model data into their own lab. See `model-site/` in the plugin starter.

## License

Site code: the EmDash blog template's license. Photos in `model/uploads/` are stock images from Unsplash and Picsum.
