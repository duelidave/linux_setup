#!/usr/bin/bash

set -o nounset
set -o errexit

# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
    echo '{"dependencies": {}}'> package.json
fi
npm install coc-snippets coc-pyright coc-json coc-tsserver coc-angular @yaegassy/coc-ansible coc-blade coc-cmake coc-css coc-cssmodules coc-dash-complete coc-docker coc-ember coc-eslint coc-git coc-git coc-graphql coc-html coc-htmldjango coc-htmlhint coc-html-css-support coc-java coc-markdownlint coc-rls coc-rust-analyzer coc-sh coc-sql coc-stylua coc-svelte coc-swagger @yaegassy/coc-tailwindcss3 coc-tailwindcss coc-toml coc-vimlsp coc-xml coc-yaml
