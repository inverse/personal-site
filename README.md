# malachisoord.com

[![Netlify Status](https://api.netlify.com/api/v1/badges/9d3d8828-c3f5-4150-b051-15f707c14ae9/deploy-status)](https://app.netlify.com/sites/malachisoord/deploys)

My personal site based on [Poole][0], running on [Netify][2].

## Setup

### Requirements

- Ruby
  - Ubuntu `apt install ruby ruby-dev`
  - Arch `pacman -S ruby`
- Bundler `gem install bundler`

### Steps


```bash
bundle
./scripts/start
```

### Creating Content

[jekyll-compose][1] has been included to speed up content curration.

#### New Page

```bash
bundle exec jekyll page "My New Page"
```

#### New Post

```bash
bundle exec jekyll post "My New Post"
```

#### New Draft

`bundle exec jekyll draft "My new draft"`

#### Publish Draft

```bash
bundle exec jekyll publish _drafts/my-new-draft.md
```

or specify a specific date on which to publish it

```bash
bundle exec jekyll publish _drafts/my-new-draft.md --date 2014-01-24
```

#### Unpublish Post

```
bundle exec jekyll unpublish _posts/2014-01-24-my-new-draft.md
```

## Image Optimisation

```
docker build -t image-optimise:local -f tools/image-optimise/Dockerfile  tools/image-optimise/
docker run -it -v $(pwd):/data image-optimise:local /data
```

[0]: https://getpoole.com/
[1]: https://github.com/jekyll/jekyll-compose
[2]: https://www.netlify.com
