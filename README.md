<!-- vim: set ft=markdown textwidth=80: -->
# natanlao.github.io

This is the code for my personal website. It's a static site generated with
Haskell, with pre/post-processing help from Sass and minify, and hosted on
GitHub Pages.

This setup is incredibly heavyweight for what right now is just a landing page.
I would normally tell you to stop asking about it so I don't have to defend my
design decisions, but I would actually love to talk to you if you're reading
this, so go ahead. I like meeting new people.

## Build process

1. Install Stack, then use Stack to install Hakyll (i.e., `stack install
   haykll`). This should automatically install GHC.
1. Install npm, then install Sass (i.e., `npm install -g sass`).
1. Install [minify][install-minify].
1. Build the site:

       $ stack build
       $ stack exec site build

  [install-minify]: https://github.com/tdewolff/minify/tree/master/cmd/minify#installation

## Continuous deployment

GitHub Actions builds the site, then pushes the build to the `gh-pages` branch.
The source code for the site is stored on the `develop` branch.

Continuous deployment is arguably overkill for a project like this. I
implemented it because I wanted to be able to make changes to my site using the
GitHub web editor then see those changes reflected without having to do a manual
build, or anything incredibly easy or trivial like that.

The build takes some 30-40 minutes starting from scratch. If dependencies are
cached, this process only takes a few minutes.

