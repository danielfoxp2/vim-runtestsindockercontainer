## INTRODUCTION

This plugin is for the ones that develop in elixir using a docker container
and wants to run the app tests in another container, without leave vim.

## ASSUMPTIONS

My code is not very flexible. It is assuming a lot of things, such:

* The docker container where elixir is installed is named 'elixir'
* The elixir cucumber flavor in use is white_bread
* The development is under a umbrella project
* The unit tests tool used is espec or exunit
* The root of you projects is named as 'work' - e.g.: "*/work/my_system/*"

Feel free to change and add flexibility as you want it.

## MAPPINGS AND USAGE

`<cr>` => a.k.a `Enter` => to run tests on a specific file

`<leader>a` => to run all unit tests at once

## CONCLUSION

This plugin needs some attention, to work with non umbrella projects for example. But for now it is what it is...
