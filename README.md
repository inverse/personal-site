# malachisoord.com

My personal site based on [Poole][0].

## Setup

### Requirements

- Ruby + dev (`apt install ruby ruby-dev`)
- Bundler (`gem install bundler`)

### Steps

- `bundle install`
- `bundle exec jekyll serve`

### Creating Content

[jekyll-compose][1] has been included to speed up content curration. 

#### New Page

`bundle exec jekyll page "My New Page"`

#### New Post

`bundle exec jekyll post "My New Post"`

#### New Draft

`bundle exec jekyll draft "My new draft"`

#### Publish Draft

`bundle exec jekyll publish _drafts/my-new-draft.md`

or specify a specific date on which to publish it

`bundle exec jekyll publish _drafts/my-new-draft.md --date 2014-01-24`

#### Unpublish Post

`bundle exec jekyll unpublish _posts/2014-01-24-my-new-draft.md`

[0]: http://getpoole.com/
[1]: https://github.com/jekyll/jekyll-compose
